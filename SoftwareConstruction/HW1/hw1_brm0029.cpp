//Bernard Moussad
//brm0029
//hw1_brm0029.cpp
//The program calculates the fatal amount of diet coke 
//I received no help at all.
#include <iostream>

using namespace std;

int main() {

	const double FractionOfSweetenerInCoke = 0.001;
	double fatalAmountHuman, fatalAmountMouse, weightHuman, weightMouse;

	cout<<"Please input the weight of the mouse in kg"<<endl;
	cin>>weightMouse;
	cout<<"Please input the fatal amount of sweetener for mouse in kg"<<endl;
	cin>>fatalAmountMouse;
	cout<<"Please input the weight of your dear friend in kg"<<endl;
	cin>>weightHuman;

	fatalAmountHuman = (fatalAmountMouse * weightHuman) / (weightMouse * FractionOfSweetenerInCoke);

	cout<<"The fatal amount of Coke for your friend is: "<<fatalAmountHuman<<" kg"<<endl;

}