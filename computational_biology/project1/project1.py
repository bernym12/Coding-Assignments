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

def initialize_matrix(input1, input2, type):
    file1 = read_file(input1)
    file2 = read_file(input2)
    s1 = join_sequences(file1)
    s2 = join_sequences(file2)
    rows,cols = (len(s1[1]) + 1, len(s2[1]) + 1)
    matrix = [[0]*cols for i in range(rows)]
    if (type == "needleman"):
        for i in range(rows):
            matrix[i][0] = -i
        for j in range(cols):
            matrix[0][j] = -j
        return matrix, s1, s2
    else:
        return matrix, s1, s2

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
    
def needleman_wunsch(matrix, sequence1, sequence2, blosum62):
    for i in range(1, len(sequence1) + 1):
        for j in range(1, len(sequence2) + 1):
            diag = retrieve_blosum_value(sequence1[i-1], sequence2[j-1], blosum62) + matrix[i-1][j-1]
            hori = retrieve_blosum_value("*", sequence2[j-1], blosum62) + matrix[i][j-1]
            vert = retrieve_blosum_value(sequence1[i-1], "*", blosum62) + matrix[i-1][j]
            matrix[i][j] = max(diag, vert, hori)
    return matrix

def smith_waterman(matrix, sequence1, sequence2, blosum62):
    for i in range(1, len(sequence1) + 1):
        for j in range(1, len(sequence2) + 1):
            diag = retrieve_blosum_value(sequence1[i-1], sequence2[j-1], blosum62) + matrix[i-1][j-1]
            hori = retrieve_blosum_value("*", sequence2[j-1], blosum62) + matrix[i][j-1]
            vert = retrieve_blosum_value(sequence1[i-1], "*", blosum62) + matrix[i-1][j]
            matrix[i][j] = max(diag, vert, hori, 0)
    return matrix
'''
Horizontal movement = Space in S1
Vertical movement = Space in S2
Diagonal movement = Letters across from each other
So obviously start at bottom right corner and work back.
So do the reverse calcs and see what was possible and that's where you mustve come from.
So look at 3 prev, do normal calcs, and whichever equals the value you are actually at has to be where you came from
'''

def back_track(matrix, sequence1, sequence2, blosum62):
    new_sequence1, new_sequence2 = [], []
    i,j = len(sequence1), len(sequence2)
    score = matrix[i][j]
    while (i > 0 and j > 0):
        hori = retrieve_blosum_value("*", sequence2[j-1], blosum62) + matrix[i][j-1]
        vert = retrieve_blosum_value(sequence1[i-1],"*" , blosum62) + matrix[i-1][j]
        if (vert == matrix[i][j]):
            new_sequence2.append('-')
            new_sequence1.append(sequence1[i-1])
            i -= 1
        elif (hori == matrix[i][j]):
            new_sequence1.append('-')
            new_sequence2.append(sequence2[j-1])
            j -= 1
        else: 
            new_sequence1.append(sequence1[i-1])
            new_sequence2.append(sequence2[j-1])
            i -= 1
            j -= 1

    while(i > 0):
        new_sequence1.append(sequence1[i-1])
        new_sequence2.append("-")
        i -= 1

    while(j > 0):
        new_sequence2.append(sequence2[j-1])
        new_sequence1.append("-")
        j -= 1

    concat_string1 = ''.join(map(str, new_sequence1[0:]))
    concat_string2 = ''.join(map(str, new_sequence2[0:]))
    return concat_string1, concat_string2, score
    
def smith_back_track(matrix, sequence1, sequence2, blosum62):
    new_sequence1, new_sequence2 = [], []
    score = max(map(max, matrix))
    x = [x for x in matrix if score in x][0]
    y = x.index(score)
    x = matrix.index(x)
    i,j = x,y

    while (i > 0 and j > 0 and matrix[i][j] != 0):
        hori = retrieve_blosum_value("*", sequence2[j-1], blosum62) + matrix[i][j-1]
        vert = retrieve_blosum_value(sequence1[i-1],"*" , blosum62) + matrix[i-1][j]
        if (vert == matrix[i][j]):
            new_sequence2.append('-')
            new_sequence1.append(sequence1[i-1])
            i -= 1
        elif (hori == matrix[i][j]):
            new_sequence1.append('-')
            new_sequence2.append(sequence2[j-1])
            j -= 1
        else: 
            new_sequence1.append(sequence1[i-1])
            new_sequence2.append(sequence2[j-1])
            i -= 1
            j -= 1
    
    # new_sequence1.append(sequence1[i-1])
    # new_sequence2.append(sequence2[j-1])

    concat_string1 = ''.join(map(str, new_sequence1[0:]))
    concat_string2 = ''.join(map(str, new_sequence2[0:]))
    return concat_string1, concat_string2, score
    
def format(seq1, seq2, score):
    seq1 = seq1[::-1]
    seq2 = seq2[::-1]
    pattern_match = []
    for i in range(len(seq1)):
        if (seq1[i] == seq2[i]):
            pattern_match.append('|')
        elif (seq1[i] == '-' or seq2[i] == '-'):
            pattern_match.append(' ')
        else:
            pattern_match.append('*')
            
    pattern_match = ''.join(map(str, pattern_match[0:]))
    print("SCORE:", score)
    n = 80
    n_seq1 = [seq1[i:i+n] for i in range(0, len(seq1), n)]
    n_seq2 = [seq2[i:i+n] for i in range(0, len(seq2), n)]
    pattern_match = [pattern_match[i:i+n] for i in range(0, len(pattern_match), n)]
    for i in range(len(n_seq1)):
        print(n_seq1[i])
        print(pattern_match[i])
        print(n_seq2[i], '\n\n')
    print(len(seq1))
    
def main():
    matrix, sequence1, sequence2 = initialize_matrix(sys.argv[1],sys.argv[2], sys.argv[3])
    blosum62 = populate_blosum62("blosum62.txt")
    if (sys.argv[3].lower() == "needleman"):
        needleman_wunsch(matrix, sequence1[1], sequence2[1], blosum62)
        seq1, seq2, score = back_track(matrix, sequence1[1], sequence2[1], blosum62)
        format(seq1, seq2, score)
    elif (sys.argv[3].lower() == "smith"):
        smith_waterman(matrix, sequence1[1], sequence2[1], blosum62)
        seq1, seq2, score = smith_back_track(matrix, sequence1[1], sequence2[1], blosum62)
        format(seq1, seq2, score)
    else:
        print("Please include which algorithm you desire to use")

if __name__=="__main__":
    main()
