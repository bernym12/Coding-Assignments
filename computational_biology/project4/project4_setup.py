from os import listdir
from math import sqrt,pi,exp
from pickle import dump, load

def read_file(input_text):
    with open(input_text,'r') as f:
        initial = [x.strip('\n') for x in f.readlines()]
    return initial

'''
Retrieves the first matrix of the PSSM file
Removes all extra information such as the sequencing and numbers in 
the first two columns and the first row
'''
def read_pssm_file(pssm_file):
    initial = read_file(pssm_file)[3:]
    final = []
    for line in initial:
        if "Lambda" in line:
            break
        line = line.split(' ')
        temp = [val for val in line if val != '']
        if(temp):
            temp.pop(0)
            temp.pop(0)
        final.append(list(map(int,temp[:20])))
    final.pop()
    return final


'''
Initally insert and append two rows of -1's into the pssm matrix
Then window where j is always 5 rows away from the ith index
Append this 200 length feature row into the overall result matrix
'''
def init_pssm_matrix(pssm_file):
    matrix = []
    initial = read_pssm_file(pssm_file)
    buffer = [-1]*20
    initial.insert(0,buffer)
    initial.insert(0,buffer)
    initial.append(buffer)
    initial.append(buffer)
    for i in range(2,len(initial)-2):
        for j in range(2, len(initial)-2):
            if ((j < (i+5))):
                continue
            row_attr = []
            row_attr.extend(initial[i-2])
            row_attr.extend(initial[i-1])
            row_attr.extend(initial[i])
            row_attr.extend(initial[i+1])
            row_attr.extend(initial[i+2])
            row_attr.extend(initial[j-2])
            row_attr.extend(initial[j-1])
            row_attr.extend(initial[j])
            row_attr.extend(initial[j+1])
            row_attr.extend(initial[j+2])
            matrix.append([row_attr, (i-1,j-1)])
    return matrix

'''
Takes in an rr file and extracts the indices where
contacts occur for that protein sequence
'''
def process_rr_file(rr_file):
    init = read_file(rr_file)[1:]
    final = dict()
    for line in init:
        line = line.split(' ')
        temp = [val for val in line if val != '']
        if (int(temp[0]) not in final):
            final[int(temp[0])] = list()
        final[int(temp[0])].append(int(temp[1]))
    return final

'''
Combines corresponding pssm with its rr file
Also balances the data by removing noncontact rows.
The number to remove is determined by the difference of 
noncontact and contact rows.
'''
def pair_rr_with_pssm(pssm, rr):
    contact = 0
    noncontact = 0
    for row in pssm:
        if row[1][0] in rr:
            if row[1][1] in rr[row[1][0]]:
                row.append(1)
                contact += 1
            else:
                row.append(0)
                noncontact += 1
        else:
            row.append(0)
            noncontact += 1
    diff = noncontact - contact
    for i in range(len(pssm)-1, -1,-1):
        if (diff == 0):
            break
        elif pssm[i][-1] == 0:
            del(pssm[i])
            diff -= 1
    return pssm

'''
Gets the first 75% of the files
Gets the matrix for each one
Then concats these matrices into a single matrix
'''
def retrieve_training_data():
    total_training_data = []
    rr_files = listdir("rr")
    pssm_files = listdir("pssm")
    for i in range(int(0.75*len(pssm_files))):
        pssm = init_pssm_matrix("pssm/" + pssm_files[i])
        rr = process_rr_file("rr/" + rr_files[i])
        final = pair_rr_with_pssm(pssm, rr)
        total_training_data.extend(final)
    return total_training_data

'''
Calculates the probability that output on a specific row 
will be a contact.
Takes in the list of weighted vectors and the x values
of that row. 
'''
def prob_of_one(w, x):
    summation = sum([w1*x1 for w1,x1 in zip(w[1:],x)])
    num = exp(-(w[0]+ summation))
    return 1/(1+num)

'''
Updates the w value that has been passed into
by using the column that corresponds
with the index of the w,
the values of every row in the training data, xl,
and the outputs of those rows, yl.
'''
def update_w(oldw,w, xi, training_data, yl):
    new_w = 0
    summation = 0
    n = 0.0001
    for i in range(len(xi)):
        xl = training_data[i][0]
        summation += xi[i]*(yl[i]-prob_of_one(w,xl))
    new_w = oldw + n*summation
    return new_w

'''
Performs the gradient ascent on the training data.
By updating the w's until the difference between two 
subsequent w's is less than epsilon
or the loop has run 100000 times
'''
def grad_ascent(training_data):
    epsilon = 0.00001
    runs = 100000
    w_diff = 100
    new_w = [0]*201
    w_initial = [0.01]*201
    x0 = [1]*len(training_data)
    yl = [x[-1] for x in training_data]
    while (runs > 0):
        print(runs)
        for i in range(len(w_initial)):
            if (i == 0):
                new_w[i] = update_w(w_initial[i],w_initial,x0,training_data,yl)
            else:
                column = [x[0][i-1] for x in training_data]
                new_w[i] = update_w(w_initial[i],w_initial,column, training_data,yl)
        w_diff = abs(w_initial[0]-new_w[0])
        w_initial = new_w
        runs -= 1
        save_data("w.pickle", w_initial)
    return w_initial

'''
Stores data of passed in object
to a pickle file with the passed 
in file_name as its file name
'''
def save_data(file_name, obj):
    with open(file_name, 'wb') as f:
        dump(obj, f)

        
if __name__ == "__main__":
    # matrix = init_pssm_matrix("pssm/1a3a.pssm")
    # rr = process_rr_file("rr/1a3a.rr")
    # pair_rr_with_pssm(matrix,rr)
    # training_data = retrieve_training_data() 
    # save_data("training.pickle", training_data)
    training_data = list()  
    with open("training.pickle", 'rb') as f:
        training_data = load(f)
    w = grad_ascent(training_data)
    save_data("w.pickle", w)    
    