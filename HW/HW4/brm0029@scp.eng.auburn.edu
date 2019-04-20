/**
* Bernard Moussad
* Brm0029
* hw4_brm0029.cpp
* g++ hw4_brm0029.cpp
* I researched methods of implementing merge sort considering 
* that's how I actually implemented my initial attempts of sorting.
* I also looked up how to create and write to a file.
*/

#include <iostream>
#include <fstream>
#include <cstdlib>

using namespace std;

const int MAX_SIZE = 100;

int readfile(int inputArray[], ifstream& instream);
void printList(int list[], int size);
int sort(int list1[], int list2[], int size1, int size2, int outputArray[]);
void finalList(int list[], int size);
void writefile(int outputArray[], int outputArray_size);

int main() {
    string filename;
    string name("Bernie Moussad");
    ifstream inStream;
    int list1[MAX_SIZE];
    int listSize1;
    int list2[MAX_SIZE];
    int listSize2;
    int outputArray[MAX_SIZE];
    int outputArray_size;
    cout<<"*** Welcome to "<<name<<"’s sorting program ***"<<endl;
    
    //Tests to see if the input filename is valid. Prints error if invalid
    //and asks user to input a filename again.
    do {
        cout << "Enter the first input file name: ";
        cin >> filename;
        inStream.open((char*)filename.c_str());
        if (inStream.fail()) {
            cout << "Input file opening failed." << endl;
        } 
    } while (inStream.fail());

    listSize1 = readfile(list1, inStream);
    inStream.close( );

    cout<<"The list of "<<listSize1<<" numbers in file "<<filename<<" is:"<<endl;
	printList(list1, listSize1);

	//Tests to see if the input filename is valid. Prints error if invalid
    //and asks user to input a filename again.
     do {
        cout << "Enter the second input file name: ";
        cin >> filename;
        inStream.open((char*)filename.c_str());
        if (inStream.fail()) {
            cout << "Input file opening failed." << endl;
        } 
    } while (inStream.fail());

    listSize2 = readfile(list2, inStream);
    inStream.close( );

    cout<<"The list of "<<listSize2<<" numbers in file "<<filename<<" is:"<<endl;
    printList(list2, listSize2);

    cout<<"The sorted list of "<< listSize1 + listSize2<<" numbers is: ";
    outputArray_size = sort(list1, list2, listSize1, listSize2,outputArray);
    writefile(outputArray,outputArray_size);
    finalList(outputArray, outputArray_size);
	return 0;
}

//This function takes in the file and an empty array.
//It then occupies the array with the integers from the input file.
//It also counts the numbers in the input file and returns the size
//of the array.
int readfile(int inputArray[], ifstream& instream) {
    int i;
    for (i = 0; !instream.eof(); i++) {
        instream >>inputArray[i];    
    }
    return i++;
}

//This function prints out each value in the array on a new line.
//It takes in the array and its size 
void printList(int list[], int size) {
    for (int i = 0; i < size; i++) {
        cout<<list[i]<<endl;
    }
    cout<<'\n';
}

//This function prints out the final sorted list 
//in a row with a space between each number.
//It takes in the sorted array and its size
//as the parameters.
void finalList(int list[], int size) {
    for (int i = 0; i < size; i++) {
        cout<<list[i]<<" ";
    }
}

//This function writes the final sorted array to a text file
//named 'output.txt'.
//It takes the inputs of the final array and its size.
void writefile(int outputArray[], int outputArray_size) {
    ofstream myfile;
    myfile.open("output.txt");
    for (int i = 0; i < outputArray_size; i++) {
        myfile<<outputArray[i]<<"\n";
    }   
    myfile.close();
}

//This function takes the input arrays and sorts them into the outputarray.
//It takes in the two input arrays, their sizes, and the output array.
//It returns the size of the output array.
int sort(int list1[], int list2[], int size1, int size2, int outputArray[]) {
    int total = size1 + size2;
    int i = 0;
    int j = 0;
    int k = 0;
    while (j < size1 && k < size2) {
        if (list1[j] < list2[k]) {
            outputArray[i] = list1[j];
            j++;
        }
        else {
            outputArray[i] = list2[k];
            k++;
        }
        i++;
    }
    while (j < size1) {
        outputArray[i] = list1[j];
        i++;
        j++;
    }
    while (k < size2) {
        outputArray[i] = list2[k];
        i++;
        k++;
    }
   return total; 
}


