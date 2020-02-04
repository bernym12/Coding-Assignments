import sys
def read_file(input_text):
    with open(input_text,'r') as f:
        input = [x.strip('\n') for x in f.readlines()]
    return input
    
def join_sequences(sequence_list):
    concat_string = ''.join(map(str, sequence_list[1:]))
    final = []
    final.append(sequence_list[0])
    final.append(concat_string)
    return final

def initialize_matrix(input1, input2):
    file1 = read_file(input1)
    file2 = read_file(input2)
    s1 = join_sequences(file1)
    s2 = join_sequences(file2)
    rows,cols = (len(s1[1]) + 1, len(s2[1]) + 1)
    needle_wunsch = [[0]*cols for i in range(rows)]
    for i in range(rows):
        needle_wunsch[i][0] = -i
    for j in range(cols):
        needle_wunsch[0][j] = -j
    return needle_wunsch, s1, s2

def populate_blosum62(blosum62_file):
    initial = [x.strip(" ").split(" ") for x in read_file(blosum62_file)]
    blosum = []
    for row in initial:
        row = [val for val in row if val != '']
        blosum.append(row)
    blosum[0].insert(0, '')
    return blosum

def retrieve_blosum_value(row_letter, col_letter, blosum62):
    col_num = blosum62[0].index(col_letter)
    row_num = 0
    for i,row in enumerate(blosum62):
        if (row[0] == row_letter):
            row_num = i
            break
    return int(blosum62[col_num][row_num])
    
def needleman_wunsch(needle_wunsch, sequence1, sequence2, blosum62):
    for i in range(1, len(sequence1) + 1):
        for j in range(1, len(sequence2) + 1):
            diag = retrieve_blosum_value(sequence1[i-1], sequence2[j-1], blosum62) + needle_wunsch[i-1][j-1]
            hori = retrieve_blosum_value("*", sequence2[j-1], blosum62) + needle_wunsch[i][j-1]
            vert = retrieve_blosum_value(sequence1[i-1],"*" , blosum62) + needle_wunsch[i-1][j]
            needle_wunsch[i][j] = max(diag, vert, hori)
    return needle_wunsch

'''
Horizontal movement = Space in S1
Vertical movement = Space in S2
Diagonal movement = Letters across from each other
So obviously start at bottom right corner and work back.
So do the reverse calcs and see what was possible and that's where you mustve come from.
So look at 3 prev, do normal calcs, and whichever equals the value you are actually at has to be where you came from

'''
def back_track(needle_wunsch, sequence1, sequence2, blosum62):
    new_sequence1 = []
    new_sequence2 = []
    i = len(sequence1)
    j = len(sequence2)
    score = needle_wunsch[i][j]
    while (i > 0 and j > 0):
        hori = retrieve_blosum_value("*", sequence2[j-1], blosum62) + needle_wunsch[i][j-1]
        vert = retrieve_blosum_value(sequence1[i-1],"*" , blosum62) + needle_wunsch[i-1][j]
        if (vert == needle_wunsch[i][j]):
            new_sequence2.append('-')
            new_sequence1.append(sequence1[i-1])
            i -=1
        elif (hori == needle_wunsch[i][j]):
            new_sequence1.append('-')
            new_sequence2.append(sequence2[j-1])
            j -=1
        else: 
            new_sequence1.append(sequence1[i-1])
            new_sequence2.append(sequence2[j-1])
            i -=1
            j -=1
    concat_string1 = ''.join(map(str, new_sequence1[0:]))
    concat_string2 = ''.join(map(str, new_sequence2[0:]))
    # print(concat_string1[::-1])
    # print('\n'+ concat_string2[::-1])
    print(needle_wunsch)
    print("length of s1:", len(sequence1))
    print("length of s2:", len(sequence2))
    print("SCORE:", score)
    print("length of concat_string1:", len(concat_string1))
    print("length of concat_string2:", len(concat_string2))

def main():
    needle_wunsch, sequence1, sequence2 = initialize_matrix(sys.argv[1],sys.argv[2])
    blosum62 = populate_blosum62("blosum62.txt")
    needleman_wunsch(needle_wunsch, sequence1[1], sequence2[1], blosum62)
    back_track(needle_wunsch, sequence1[1], sequence2[1], blosum62)

if __name__=="__main__":
    main()
