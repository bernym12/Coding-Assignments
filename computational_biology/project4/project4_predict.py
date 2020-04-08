from project4_setup import read_file, init_pssm_matrix, process_rr_file, prob_of_one, pair_rr_with_pssm

from pickle import load
from sys import argv
from os import listdir

# def retrieve_test_data():
#     total_test_data = []
#     rr_files = listdir("rr")
#     pssm_files = listdir("pssm")
#     for i in range(int(0.75*len(pssm_files))+1,len(pssm_files)):
#         initial = init_pssm_matrix(f"pssm/{pssm_files[i]}")
#         rr = process_rr_file(f"rr/{rr_files[i]}")
#         final = pair_rr_with_pssm(initial, rr)
#         total_test_data.extend(final)
#     return total_test_data

def prediction(matrix, w):
    contacts = list()
    rr_overall = []
    for row in matrix:
        prob = prob_of_one(w, row[0])
        rounded_prob = round(prob)
        if rounded_prob == 1:
            contacts.append( (row[1], prob))
            rr_overall.append(1)
        else:
            rr_overall.append(0)
    contacts = sorted(contacts, key=lambda contacts: contacts[1], reverse=True)
    # print(contacts)
    return rr_overall, contacts

'''
Compares predicted output of each row 
to the actual value of the output
for the entire PSSM
'''
def accuracy(output, pssm):
    correct = 0
    for i in range(len(output)):
        if output[i] == pssm[i]:
            correct += 1
    print("Accuracy:", float(correct/len(pssm)))  
    return  float(correct/len(pssm))

'''
Calculates top L/10, L/5, and L/2 
by comparing the contacts predicted
to the corresponding RR file
'''
def top(contacts, rr, sequence_len):
    l_10 = int(sequence_len/10)
    l_5 = int(sequence_len/5)
    l_2 = int(sequence_len/2)
    l_10_list = contacts[:l_10]
    l_5_list = contacts[:l_5]
    l_2_list = contacts[:l_2]
    l_10_count = 0
    l_5_count = 0
    l_2_count = 0
    for contact in l_10_list:
        if contact[0][0] in rr:
            if contact[0][1] in rr[contact[0][0]]:
                l_10_count += 1
    for contact in l_5_list:
        if contact[0][0] in rr:
            if contact[0][1] in rr[contact[0][0]]:
                l_5_count += 1
    for contact in l_2_list:
        if contact[0][0] in rr:
            if contact[0][1] in rr[contact[0][0]]:
                l_2_count += 1
    print("L10:", float(l_10_count)/l_10)
    print("L5:", float(l_5_count)/l_5)
    print("L2:", float(l_2_count)/l_2)
    return float(l_10_count)/l_10, float(l_5_count)/l_5, float(l_2_count)/l_2

'''
Used to collect all of testing data
and produce an overall accuracy as well
perform all of the top acuracies for 
the testing data.
'''
def testing_data():
    rr_files = listdir("rr")
    pssm_files = listdir("pssm")
    accuracies = []
    tops = {}
    for i in range(int(0.75*len(pssm_files))+1,len(pssm_files)):
        matrix = init_pssm_matrix(f"pssm/{pssm_files[i]}")
        rr = process_rr_file(f"rr/{rr_files[i]}")
        sequence_len = len(read_file(f"rr/{rr_files[i]}")[0])
        pair_rr_with_pssm(matrix, rr)
        true_rr = [x[-1] for x in matrix]
        output, contacts = prediction(matrix, w)
        tops[pssm_files[i]] = top(contacts, rr, sequence_len)
        print(pssm_files[i])
        accuracies.append(accuracy(output, true_rr))
    print("Overall Accuracy:", sum(accuracies)/len(accuracies))

if __name__ == "__main__":
    w = list()
    with open("w.pickle", 'rb') as f:
        w = load(f)
    matrix = init_pssm_matrix(argv[1])
    rr = process_rr_file(argv[2])
    sequence_len = len(read_file(argv[2])[0])
    pair_rr_with_pssm(matrix, rr)
    true_rr = [x[-1] for x in matrix]
    output, contacts = prediction(matrix, w)
    top(contacts, rr, sequence_len)
    accuracy(output, true_rr)
    # testing_data()

