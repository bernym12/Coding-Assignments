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
    return learning_fasta, learning_sa, buried

def output_given_attr(attr,learning_fasta,learning_sa):
    count_for_attr = {'B': 0, 'E': 0}
    for i,char in enumerate(learning_fasta):
        if (learning_sa[i] == 'B' and char in attributes[attr]):
            count_for_attr['B'] += 1
        elif (learning_sa[i] == 'E' and char in attributes[attr]):
            count_for_attr['E'] += 1
    return max(count_for_attr, key=count_for_attr.get)



def calc_entropy(learning_fasta, learning_sa, attribute):
    prob_attribute = attribute / len(learning_sa)
    entropy = -prob_attribute*math.log2(prob_attribute) - (1-prob_attribute)*math.log2((1-prob_attribute))
    return entropy
     
def calc_gain(learning_fasta, learning_sa, total_entropy):
    prob_attr = {}
    for attribute in attributes:
        for protein in learning_fasta:
            if protein in attributes[attribute]:
                if attribute in prob_attr:
                    prob_attr[attribute] += 1
                else:
                    prob_attr[attribute] = 1
    attr_entr = {}
    attr_gains = {}
    for key in prob_attr:
        attr_entr[key] = calc_entropy(learning_fasta, learning_sa, prob_attr[key])
        attr_gains[key] = total_entropy - attr_entr[key]
    return attr_gains
'''
Select the attribute with the most gain
If protein has that attribute, output buried
Else, insert attribute with second most gain,
and keep on with that
Can recursively call this by passing in a tree
The remaining charactersitics that haven't been used
''' 
def construct_tree(tree, attr_gains,learning_fasta, learning_sa):
    root = max(attr_gains, key = attr_gains.get)
    if (root not in tree):
        if (len(attr_gains) == 1):
            tree[root] = (output_given_attr(root,learning_fasta,learning_sa))
            return tree      
        attr_gains.pop(root)
        tree[root] = (output_given_attr(root,learning_fasta,learning_sa),max(attr_gains, key = attr_gains.get))      

    return construct_tree(tree, attr_gains, learning_fasta, learning_sa)

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

    print("Percent: ", percentage/(len(testing_sa)))
    print("Precision: ", precision)
    print("Recall: ", recall)
    print("F1: ", f1)

def main():
    learning_fasta, learning_sa, buried = populate_training_lists()
    total_entropy = calc_entropy(learning_fasta, learning_sa, buried)
    attr_gains = calc_gain(learning_fasta, learning_sa, total_entropy)
  
    tree = {}
    construct_tree(tree, attr_gains, learning_fasta, learning_sa)
    save_tree(tree)
    testing_sa, potential_sa = predict_output(tree)
    evaluate_performance(testing_sa, potential_sa)
    print(tree)

if __name__ == "__main__":
    main()