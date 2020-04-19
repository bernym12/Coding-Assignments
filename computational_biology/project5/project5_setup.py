from os import listdir
from math import sqrt,pi,exp
from pickle import dump, load

'''
Attributes used in order to see if an acid had a particular attribute.
Neccesary for prediction of the acid's solvent accessibility
'''
attributes = {"hydro":["A","C","F","G","I","L","M","P","T","V","W","Y"],
                "polar":["D","E","H","K","N","Q","R","S","T","Y"],
                "small":["A","C","D","G","N","P","S","T","V"],
                "proline":["P"],
                "tiny":["A","G","S"],
                "aliphatic":["I","L","V"],
                "aromatic":["F","H","W","Y"],
                "positive":["H","K","R"],
                "negative":["A","E"],
                "charged":["H","K","R","A","E"]}

'''
Reads in each line of 
a file and stores it into a list
'''
def read_file(input_text):
    with open(input_text,'r') as f:
        initial = [x.strip('\n') for x in f.readlines()]
    return initial

'''
Parse through a PSSM file and
returns both halves of it
'''
def read_pssm_file(pssm_file):
    initial = read_file(pssm_file)[3:]
    right = []
    left = []
    for line in initial:
        if "Lambda" in line:
            break
        line = line.split(' ')
        temp = [val for val in line if val != '']
        if(temp):
            temp.pop(0)
            temp.pop(0)
        left.append(list(map(int,temp[:20])))
        right.append(list(map(int,temp[20:40])))
    left.pop()
    right.pop()
    return left,right

'''
Initally insert and append two rows of -1's into the pssm matrix
Then create a row that uses a window of i+2 to i-2 for a total of
100 features. 
Append this 100 length feature row into the overall result matrix
'''
def window_pssm(pssm_matrix):
    matrix = []
    buffer = [-1]*20
    pssm_matrix.insert(0,buffer)
    pssm_matrix.insert(0,buffer)
    pssm_matrix.append(buffer)
    pssm_matrix.append(buffer)
    for i in range(2,len(pssm_matrix)-2):
        row_attr = []
        row_attr.extend(pssm_matrix[i-2])
        row_attr.extend(pssm_matrix[i-1])
        row_attr.extend(pssm_matrix[i])
        row_attr.extend(pssm_matrix[i+1])
        row_attr.extend(pssm_matrix[i+2])
        matrix.append(row_attr)
    return matrix
    
'''
Finds all the possible pair combinations
for all of the files in PSSM
and returns a list of these pairs
'''
def retrieve_pairs():
    pssm_files = listdir("pssm")
    pair_list = []
    for p1 in range(len(pssm_files)):
        for p2 in range(p1+1,len(pssm_files)):
                pair_list.append([pssm_files[p1],pssm_files[p2]])
    return pair_list

'''
Retrieves the first 75% of these pairs
as well as their average tmalign scores
and returns them in a list of tuples
'''   
def retrieve_training_pairs(pairs):
    training_pairs = list()
    for i in range(int(0.75*len(pairs))):
        tmalign_values = tmalign_parse(pairs[i])
        training_pairs.append((pairs[i], mean(tmalign_values)))
    return training_pairs

'''
Retrieves feature data for a list of pairs
and returns this in an overall feature matrix
'''
def retrieve_feature_data(calcs, priors, tree, pair_list):
    total_features = list()
    for pair in pair_list:
        total_features.append((feature_generation(calcs, priors, tree, pair[0]),pair[1]))
    return total_features 

'''
Generates a feature list given a pair of PSSM files.
Features include the averages of the 'weighted observed percentages
rounded down', which is 20 features per PSSM,
the ratios of the secondary structures for each PSSM, which is 3
features per PSSM, and lastly, the ratios of protein solvent accessibility 
of each FASTA, which is 2 features per FASTA, totaling 50 features.
'''
def feature_generation(calcs, priors, tree, pair):
    features = list()
    matrix_1 = read_pssm_file(f"pssm/{pair[0]}")
    matrix_2 = read_pssm_file(f"pssm/{pair[1]}")
    matrix_1_window = window_pssm(matrix_1[0])
    matrix_2_window = window_pssm(matrix_2[0])
    features.extend(average_pssm_columns(matrix_1[1]))
    features.extend(average_pssm_columns(matrix_2[1]))
    features.extend(prediction(matrix_1_window, calcs, priors))
    features.extend(prediction(matrix_2_window, calcs, priors))
    features.extend(predict_exposure(tree, f"{pair[0].split('.')[0]}.fasta"))
    features.extend(predict_exposure(tree, f"{pair[1].split('.')[0]}.fasta"))
    return features


'''
Returns the corresponding tmalign file
given a pair
'''
def find_tmalign(pair):
    return f"{pair[0].split('.')[0]}_{pair[1].split('.')[0]}_tmalign"

'''
Parses the tmalign file of a pair
and returns the scores for that pair
'''  
def tmalign_parse(pair):
    tmalign = find_tmalign(pair)
    tmalign_file = read_file(f"tmalign/{tmalign}")
    scores = list()
    for line in tmalign_file:
        if "TM-score=" in line:
            scores.append(line.split(' ')[1])
    return list(map(float,scores))

'''
Calculates the possible TM-Alignment Score given the learned weights
and features of a pair of proteins
'''
def f_x(w, x):
    summation = sum([w1*x1 for w1,x1 in zip(w[1:],x)])
    return w[0] + summation

'''
Updates a particular w given its previous value, the features, or x's, in the column
the w corresponds to, the outputs from each row in the training data, 
and the features for the current row being analyzed.
'''
def update_w(oldw,w, xi, training_data, yl):
    summation = 0
    n = 0.000001
    for i in range(len(xi)):
        xl = training_data[i][0]
        summation += xi[i]*(yl[i]-f_x(w,xl))
    new_w = oldw + 2*n*summation
    return new_w

'''
Overall implementation of batch gradient descent:
Continually updates the weights all at once until either
the difference between subsequent weight vectors is less
than epsilon or 1000 runs have been achieved.

Prints out the current iteration, W0 of the old and new weights,
and the differnce between the two weight vectors.
'''
def grad_descent(training_data):
    epsilon = 0.0000001
    runs = 1000
    w_diff = 100
    new_w = [0]*51
    w_initial = [1]*51
    x0 = [1]*len(training_data)
    yl = [x[-1] for x in training_data]
    while (runs > 0 and w_diff > epsilon):
        print(runs)
        for i in range(len(w_initial)):
            if (i == 0):
                new_w[i] = update_w(w_initial[i],w_initial,x0,training_data,yl)
            else:
                column = [x[0][i-1] for x in training_data]
                new_w[i] = update_w(w_initial[i],w_initial,column, training_data,yl)
        print("W_initial:", (w_initial[0]), "W_New:",new_w[0])
        w_diff = abs(mean(w_initial)-mean(new_w))
        print("W_diff:",w_diff)
        w_initial = new_w.copy()
        runs -= 1
        save_file("w_attempt", w_initial)
        write_ws("w_data.txt", w_initial, 1000-runs)
    return w_initial

'''
Save values of weight vector at every iteration
in order to graph converge of weights later
'''
def write_ws(name, obj, time):
    with open(name, "a") as f:
        f.write(f"Ws: {obj}, Time: {time}\n")

'''
Calculates the average of a list of data
'''
def mean(data):
    return sum(data)/float(len(data))

'''
Retrieves each column within the PSSM matrix
and returns a list of the averages
of each of these columns
'''
def average_pssm_columns(pssm):
    averages = []
    for i in range(len(pssm[0])):
        averages.append(mean([x[i] for x in pssm])/100)
    return averages

'''
Calculation for normal gaussian
'''
def gaussian(avg,sigma,xi):
    return (1/(sqrt(2*pi)*sigma))*exp(-0.5*((xi-avg)/sigma)**2)

'''
For each xi in a row, calculate the gaussian using the sigma and mean from the test data. 
Then using the yk prior from test data
calculate the probability of it being that result, yk.
'''
def calc_given_prior(row, calcs, prior, prior_letter):
    gaussian_products = 1
    for i in range(len(row)):
        key = str(i) + prior_letter
        gaussian_products *= gaussian(calcs[key][0],calcs[key][1], row[i])
    return gaussian_products*prior

'''
Determines most likely output for each row given
the data calculated from the training data
and ratios of the predicted outcomes.
'''
def prediction(test_data, calcs, priors):
    outcome = []
    for row in test_data:
        calcs_for_row = {}
        for prior in priors:
            calcs_for_row[prior] = calc_given_prior(row, calcs[prior], priors[prior], prior)
        most_likely = max(calcs_for_row, key=calcs_for_row.get)
        outcome.append(most_likely)
    outcome = ''.join(outcome[0:])
    return float(outcome.count("H"))/len(outcome), float(outcome.count("E"))/len(outcome), float(outcome.count("C"))/len(outcome)

def predict_exposure(tree, fasta):
    sequence = read_file(f"fasta/{fasta}")[1]
    potential_sa = []
    for character in sequence:
        for node in tree:
            if character in attributes[node]:
                potential_sa.append(tree[node][0])
    potential_sa = ''.join(map(str, potential_sa[1:]))
    return float(potential_sa.count('B'))/len(potential_sa), float(potential_sa.count('E'))/len(potential_sa)

def open_pickle(file):
    with open(file, 'rb') as f:
        return load(f)

def save_file(name, obj):
    with open(f"{name}.pickle", 'wb') as f:
        dump(obj, f)

if __name__ == "__main__":
    # calcs = open_pickle("calcs.pickle")
    # priors = open_pickle("priors.pickle")
    # tree = open_pickle("tree.pickle")
    # pairs = retrieve_pairs()
    # training = retrieve_training_pairs(pairs)
    # training_data = retrieve_feature_data(calcs, priors, tree, training)
    # save_file("training_data",training_data)
    new_training = open_pickle("training_data.pickle")
    w = grad_descent(new_training)
    save_file("w", w)
