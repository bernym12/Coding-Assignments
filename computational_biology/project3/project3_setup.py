import sys
import os
from math import sqrt
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
After we do that, then combine each of this matrices into a single one.
Then calculate the mean and std. dev for each column xi
If looking at the first row, then append two rows of 20 -1's in the front.
If looking at second row, then only append one row of 20 -1's.
If looking at the next to last row, append one row of 20 -1's to the end of it.
If looking at the last row, append two rows of 20 -1's to the end of it.
Then create a tuple pair that contains the row paired with the ss value for that row
'''

# TODO: REALLY NEEDS TO BE REDUCED
def init_pssm_matrix(pssm_file, ss_file):
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
        matrix.append((row_attr,ss[i]))
    return matrix

'''
Gets the first 75% of the files
Gets the matrix for each one
Then concats these matrices into a single matrix
'''
def retrieve_test_data():
    total_test_data = []
    ss_files = os.listdir("ss")
    pssm_files = os.listdir("pssm")
    for i in range(int(0.75*len(pssm_files))):
        initial = init_pssm_matrix("pssm/" + pssm_files[i], "ss/" + ss_files[i])
        total_test_data.extend(initial)
    return total_test_data

def divide_test_data(test_data):
    c = []
    e = []
    h = []
    for row in test_data:
        if row[1] == "C":
            c.append(row)
        elif row[1] == "E":
            e.append(row)
        else:
            h.append(row)
    return c,e,h
    
def mean(data):
    return sum(data)/float(len(data))

def std_dev(data):
    avg = mean(data)
    var = sum([(x-avg)**2 for x in data])/float(len(data)-1)
    return sqrt(var)

def separate_data(test_data):
    calcs = {}
    label = test_data[0][1]
    for i in range(len(test_data[0][0])):
        column = [x[0][i] for x in test_data]   
        tup = (mean(column), std_dev(column))
        key = str(i) + label
        calcs[key] = tup
    return calcs

if __name__ == "__main__":
    test_data = retrieve_test_data()   
    classes = divide_test_data(test_data)
    calcs = []
    for label in classes:
        calcs.append(separate_data(label))
    print(calcs)