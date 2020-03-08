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
            for x in range(40):
                row_attr.append(-1)
            row_attr.extend(initial[i])
            row_attr.extend(initial[i+1])
            row_attr.extend(initial[i+2])
        elif i == 1:
            for x in range(20):
                row_attr.append(-1)  
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
        if (train):
            matrix.append((row_attr,ss[i]))
        else:
            matrix.append(row_attr)
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

def retrieve_test_data():
    total_test_data = []
    ss_files = os.listdir("ss")
    pssm_files = os.listdir("pssm")
    for i in range(int(0.75*len(pssm_files))+1,len(pssm_files)):
        initial = init_pssm_matrix("pssm/" + pssm_files[i], "ss/" + ss_files[i], False)
        total_test_data.extend(initial)
    return total_test_data

def divide_training_data(training_data):
    c = []
    e = []
    h = []
    for row in training_data:
        if row[1] == "C":
            c.append(row)
        elif row[1] == "E":
            e.append(row)
        else:
            h.append(row)
    h_prior = len(h)/float(len(training_data))
    c_prior = len(c)/float(len(training_data))
    e_prior = len(e)/float(len(training_data))
    priors = {'H':h_prior,'C':c_prior,'E':e_prior}
    classes = {'H':h,'C':c,'E':e}
    return classes,priors
    
def mean(data):
    return sum(data)/float(len(data))

def std(data):
    avg = mean(data)
    var = sum([(x-avg)**2 for x in data])/float(len(data)-1)
    return sqrt(var)

def calcs_for_data(training_data):
    calcs = {}
    label = training_data[0][1]
    for i in range(len(training_data[0][0])):
        column = [x[0][i] for x in training_data]   
        tup = (mean(column), std(column))
        key = str(i) + label
        calcs[key] = tup
    return calcs

def gaussian(avg,sigma,xi):
    return (1/(sqrt(2*pi)*sigma))*exp(-0.5*((xi-avg)/sigma)**2)

'''
For each xi in a row, calculate the gaussian using the yk piror from test data
as well as the sigma and mean from the test data.
So probably pass in a single row and the dictionary needed for the calcs
calculate yh, ye, yc, so multiply all of the guassians 
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
    return (outcome)

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
    return (correct/float(len(ss_data)))*100

if __name__ == "__main__":
    training_data = retrieve_training_data()   
    classes, priors = divide_training_data(training_data)
    calcs = {}
    for label in classes:
        calcs[label] = (calcs_for_data(classes[label]))
    test_data = retrieve_test_data()
    outcome = prediction(test_data, calcs, priors)
    result = Q3(outcome)
    print(result)
    