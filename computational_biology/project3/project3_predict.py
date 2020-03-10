from project3_setup import prediction, read_file, init_pssm_matrix
from pickle import load
from sys import argv

def Q3(outcome, ss):
    ss_data = read_file(ss)[1]
    correct = 0
    for i in range(len(outcome)):
        if outcome[i] == ss_data[i]:
            correct += 1
    print(str(outcome.count('H')/float(ss_data.count('H'))*100)+ '%')
    print(str(outcome.count('C')/float(ss_data.count('C'))*100)+ '%')
    print(str(outcome.count('E')/float(ss_data.count('E'))*100)+ '%')
    return (correct/float(len(ss_data)))*100

if __name__ == "__main__":
    calcs = {}
    priors = {}
    with open("calcs.pickle", 'rb') as f:
        calcs = load(f)
    with open('priors.pickle', 'rb') as f:
        priors = load(f)
    matrix = init_pssm_matrix(argv[1], argv[2], False)
    output = prediction(matrix, calcs, priors)
    result = Q3(output, argv[2])
    print(str(result)+'%')

