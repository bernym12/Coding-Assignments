import sys
import os
import math
import pickle

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
Reads in text file and stores each line as an element
within a list
'''
def read_file(input_text):
    with open(input_text,'r') as f:
        input = [x.strip('\n') for x in f.readlines()]
    return input

def populate_training_lists():
    learning_fasta = []
    learning_sa = []
    for i, file in enumerate(os.listdir("fasta"), int(.75*len(os.listdir("fasta")))):
        learning_fasta.append(read_file("fasta/" + file)[1])
    for i, file in enumerate(os.listdir("sa"), int(.75*len(os.listdir("sa")))):
        learning_sa.append(read_file("sa/" + file)[1])
    learning_fasta = ''.join(map(str, learning_fasta[1:]))
    learning_sa = ''.join(map(str, learning_sa[1:]))
    buried = learning_sa.count("B")
    proteins = {}
    for i, protein in enumerate(learning_fasta):
        if learning_sa[i] == 'B':
            if protein not in proteins:
                proteins[protein] = '1'
            else:
                proteins[protein] += ('1')
        else:
            if protein not in proteins:
                proteins[protein] = '0'
            else:
                proteins[protein] += ('0')

    count_for_attr = {}
    for protein in learning_fasta:
        for attr in attributes:
            if protein in attributes[attr]:
                if attr not in count_for_attr:
                    count_for_attr[attr] = 1
                else:
                    count_for_attr[attr] += 1
    return learning_fasta, learning_sa, buried, count_for_attr,proteins

def output_given_attr(attr,learning_fasta,learning_sa):
    count_for_attr = {'B': 0, 'E': 0}
    for i,char in enumerate(learning_fasta):
        if (learning_sa[i] == 'B' and char in attributes[attr]):
            count_for_attr['B'] += 1
        elif (learning_sa[i] == 'E' and char in attributes[attr]):
            count_for_attr['E'] += 1
    return max(count_for_attr, key=count_for_attr.get)

def split_attributes(sequence, attribute):
    match_list = []
    diff_list = []
    for char in sequence:
        if char in attributes[attribute]:
            match_list.append(char)
        else:
            diff_list.append(char)
    return match_list, diff_list
    



def calc_entropy(sequence, attribute_count):
    if (attribute_count == 0):
        entropy = -(1)*math.log(1,2)
        return entropy
    prob_attribute = attribute_count / len(sequence)
    if (prob_attribute == 0):
        entropy = -(1-prob_attribute)*math.log((1-prob_attribute),2)
    elif (prob_attribute == 1):
        entropy = -prob_attribute*math.log(prob_attribute,2)
    else:
        entropy = -prob_attribute*math.log(prob_attribute,2) - (1-prob_attribute)*math.log((1-prob_attribute),2)
    return entropy

'''
Really need to pass in the number of times a protein falls under a category
'''
# def calc_gain(learning_fasta, learning_sa, total_entropy, count_for_attr):
#     attr_entr = {}
#     attr_gains = {}
#     for key in count_for_attr:
#         attr_entr[key] = calc_entropy(learning_sa, count_for_attr[key])
#         attr_gains[key] = total_entropy - attr_entr[key]
#     return attr_gains

def calc_gain(sequence, attr, total_entropy):
    attribute_count = 0
    for protein in sequence:
        if protein in attributes[attr]:
            attribute_count += 1
    gain = total_entropy - calc_entropy(sequence, attribute_count)
    return gain

def gain_dict(sequence, total_entropy):
    attr_gains = {}
    for attr in attributes:
       attr_gains[attr] = calc_gain(sequence, attr, total_entropy)
       if (attr_gains[attr] is None):
           attr_gains.pop(attr)
    return attr_gains

'''
Select the attribute with the most gain
If protein has that attribute, output buried
Else, insert attribute with second most gain,
and keep on with that
Can recursively call this by passing in a tree
The remaining charactersitics that haven't been used
''' 
def construct_tree(tree, attr_gains, sequence, total_entropy):
    root = max(attr_gains, key = attr_gains.get)
    if (root not in tree):
        new_gains_common = gain_dict(split_attributes(sequence,root)[0],total_entropy)
        new_gains_diff = gain_dict(split_attributes(sequence,root)[1],total_entropy)
        if (root in new_gains_common):
            new_gains_common.pop(root)
        if (root in new_gains_diff):
            new_gains_diff.pop(root)
        first = max(new_gains_common, key = new_gains_common.get)
        second = max(new_gains_diff, key = new_gains_diff.get)
        tree[root] = (first,second)
        construct_tree(tree, new_gains_common, split_attributes(sequence,root)[0], total_entropy)
        construct_tree(tree, new_gains_diff, split_attributes(sequence,root)[1], total_entropy)

    return tree

def save_tree(tree):
    with open("tree.pickle", 'wb') as f:
        pickle.dump(tree, f)

def predict_output(tree):
    testing_fasta = []
    testing_sa = []
    fasta_files = os.listdir("fasta")
    sa_files = os.listdir("sa")

    start = int(.75*len(fasta_files)) + 1
    for i in range(start, len(fasta_files)):
        testing_fasta.append(read_file("fasta/" + fasta_files[i])[1])
    for i in range(start, len(fasta_files)):
        testing_sa.append(read_file("sa/" + sa_files[i])[1])
    
    testing_fasta = ''.join(map(str, testing_fasta[1:]))
    testing_sa = ''.join(map(str, testing_sa[1:]))

    potential_sa = []
    for character in testing_fasta:
        for node in tree:
            if character in attributes[node]:
                potential_sa.append(tree[node][0])
  
    potential_sa = ''.join(map(str, potential_sa[1:]))
    return testing_sa, potential_sa

def evaluate_performance(testing_sa, potential_sa):
    true_positive = 0
    false_positive = 0
    false_negative = 0
    percentage = 0
    for i,character in enumerate(testing_sa):
        if (character == potential_sa[i] and potential_sa[i] == 'B'):
            true_positive += 1
        elif (character != potential_sa[i] and potential_sa[i] == 'B'):
            false_positive += 1
        elif (character != potential_sa[i] and potential_sa[i] == 'E'):
            false_negative += 1
    for i,char in enumerate(testing_sa):
        if char == potential_sa[i]:
            percentage += 1
    
    precision = true_positive/(true_positive+false_positive)
    recall = true_positive/(true_positive+false_negative)
    f1 = 2*(precision*recall)/(precision+recall)
    # print("Constructed SA: ", potential_sa)
    print("Percent: ", percentage/(len(testing_sa)))
    print("Precision: ", precision)
    print("Recall: ", recall)
    print("F1: ", f1)


def main():
    learning_fasta, learning_sa, buried, count_for_attr, proteins = populate_training_lists()
    total_entropy = calc_entropy(learning_sa, buried)
    attr_gains = gain_dict(learning_fasta, total_entropy)
    # split_attributes(learning_fasta, 'proline')
    tree = {}
    construct_tree(tree, attr_gains, learning_fasta, total_entropy)    
    save_tree(tree)
    testing_sa, potential_sa = predict_output(tree)
    # evaluate_performance(testing_sa, potential_sa)
    print(tree)


if __name__ == "__main__":
    main()