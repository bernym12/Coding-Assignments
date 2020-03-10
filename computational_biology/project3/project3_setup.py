import sys
import os
from math import sqrt,pi,exp
import pickle

'''
need to cocantenate our 75% of fasta files and then compute the sigma and mu for each column.
We will also need to compute it based on if the output is y=0, y=1, or y=2
Store these values into a dictionary of tuple values. 
When we go to predict our values, retrieve the values from this dictionary and do calcs
'''
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
First, do the windowing for each file and make a single matrix that has the 100 attr.
If looking at the first row, then append two rows of 20 -1's in the front.
If looking at second row, then only append one row of 20 -1's.
If looking at the next to last row, append one row of 20 -1's to the end of it.
If looking at the last row, append two rows of 20 -1's to the end of it.
Then create a tuple pair that contains the row paired with the ss value for that row
'''

# TODO: REALLY NEEDS TO BE REDUCED
def init_pssm_matrix(pssm_file, ss_file, train):
    matrix = []
    initial = read_pssm_file(pssm_file)
    ss = read_file(ss_file)[1]
    for i in range(len(initial)):
        row_attr = []
        if i == 0:
            row_attr = [-1 for x in range(40)]
            row_attr.extend(initial[i])
            row_attr.extend(initial[i+1])
            row_attr.extend(initial[i+2])
        elif i == 1:
            row_attr = [-1 for x in range(20)]
            row_attr.extend(initial[i-1])
            row_attr.extend(initial[i])
            row_attr.extend(initial[i+1])
            row_attr.extend(initial[i+2])
        elif i == len(initial)-2:
            row_attr.extend(initial[i-2])
            row_attr.extend(initial[i-1])
            row_attr.extend(initial[i])
            row_attr.extend(initial[i+1])
            for x in range(20):
                row_attr.append(-1)  
        elif i == len(initial)-1:
            row_attr.extend(initial[i-2])
            row_attr.extend(initial[i-1])
            row_attr.extend(initial[i])
            for x in range(40):
                row_attr.append(-1)  
        else:
            row_attr.extend(initial[i-2])
            row_attr.extend(initial[i-1])
            row_attr.extend(initial[i])
            row_attr.extend(initial[i+1])
            row_attr.extend(initial[i+2])
        matrix.append(row_attr)
    if (train):
        matrix = list(zip(matrix, ss))
    return matrix

'''
Gets the first 75% of the files
Gets the matrix for each one
Then concats these matrices into a single matrix
'''
def retrieve_training_data():
    total_training_data = []
    ss_files = os.listdir("ss")
    pssm_files = os.listdir("pssm")
    for i in range(int(0.75*len(pssm_files))):
        initial = init_pssm_matrix("pssm/" + pssm_files[i], "ss/" + ss_files[i], True)
        total_training_data.extend(initial)
    return total_training_data

'''
Gets the remaining 25% of the files
Gets the matrix for each
Then concats into a single matrix
'''
def retrieve_test_data():
    total_test_data = []
    ss_files = os.listdir("ss")
    pssm_files = os.listdir("pssm")
    for i in range(int(0.75*len(pssm_files))+1,len(pssm_files)):
        initial = init_pssm_matrix("pssm/" + pssm_files[i], "ss/" + ss_files[i], False)
        total_test_data.extend(initial)
    return total_test_data

'''
Divides training data in three lists
Rows that result in H
Rows that result in C
Rows that result in E
Also calculates the priors for each
'''
def divide_training_data(training_data):
    separated_data = {}
    priors = {}
    for row in training_data:
        if (row[1] not in separated_data):
            separated_data[row[1]] = list()
        separated_data[row[1]].append(row[0])
    for key in separated_data:
        priors[key] = len(separated_data[key])/float(len(training_data))
    return separated_data,priors

'''
Calculates average of the data
'''
def mean(data):
    return sum(data)/float(len(data))

'''
Calculates standard deviation of the data
'''
def std(data):
    avg = mean(data)
    var = sum([(x-avg)**2 for x in data])/float(len(data)-1)
    return sqrt(var)

'''
Given the data that results in a specific yk (H,E, or C)
Calculates the mean and standard deviation for each column
'''
def calcs_for_data(key, training_data):
    calcs = {}
    for i in range(len(training_data[0])):
        column = [x[i] for x in training_data]
        tup = (mean(column), std(column))
        label = str(i) + key
        calcs[label] = tup
    return calcs

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


def prediction(test_data, calcs, priors):
    outcome = []
    for row in test_data:
        calcs_for_row = {}
        for prior in priors:
            calcs_for_row[prior] = calc_given_prior(row, calcs[prior], priors[prior], prior)
        most_likely = max(calcs_for_row, key=calcs_for_row.get)
        outcome.append(most_likely)
    outcome = ''.join(outcome[0:])
    return (outcome)

'''
Retrives all of the calculations for each prior and stores them
in a dict with the key being the letters for yk (H, E, or C).
'''
def calcs_for_each_prior(divided_data):
    calcs = {}
    for label in divided_data:
        calcs[label] = (calcs_for_data(label, divided_data[label]))
    return calcs

def Q3(outcome):
    ss_files = os.listdir("ss")
    ss_data = ''
    for i in range(int(0.75*len(ss_files))+1,len(ss_files)):
        initial = read_file("ss/" + ss_files[i])
        ss_data += (initial[1])
    correct = 0
    for i in range(len(outcome)):
        if outcome[i] == ss_data[i]:
            correct += 1
    print(outcome.count('H')/float(ss_data.count('H')))
    print(outcome.count('C')/float(ss_data.count('C')))
    print(outcome.count('E')/float(ss_data.count('E')))
    return (correct/float(len(ss_data)))*100

def save_data(calcs,priors):
    with open("calcs.pickle", 'wb') as f:
        pickle.dump(calcs, f)
    with open("priors.pickle", 'wb') as f:
        pickle.dump(priors, f)

if __name__ == "__main__":
    training_data = retrieve_training_data()   
    divided_data, priors = divide_training_data(training_data)
    calcs = calcs_for_each_prior(divided_data)
    save_data(calcs, priors)
    test_data = retrieve_test_data()
    outcome = prediction(test_data, calcs, priors)
    result = Q3(outcome)
    print(result)
    