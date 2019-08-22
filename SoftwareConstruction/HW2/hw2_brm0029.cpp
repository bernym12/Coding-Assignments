/* 
* Bernard Moussad
* brm0029
* hw2_brm0029.cpp
* g++ hw2_brm0029.cpp
* I wrote this code myself without any help.
*/
  


#include <iostream>
#include <cmath>
using namespace std;

int main()
{
	cout.precision(2);
	double loan, interest, monthlyPayments, ratePerMonth, intrAmount, principal, interestPaid=0;
	const int monthsInYear = 12;
	int month = 0;
	//Input of loan amount
	cout<<"Loan Amount: ";
	cin>>loan;
	//Input of interest
	cout<<"Interest Rate (% per year): ";
	cin>>interest;
	ratePerMonth = interest/monthsInYear;
	cout<<"Monthly Payments: ";
	cin>>monthlyPayments;
	cout<<"******************************************************"<<endl;
	cout<<"\tAmortization Table\n******************************************************"<<endl;
	cout<<"Month\tBalance Payment Rate\tInterest Principal"<<endl;
	cout<<fixed<<month<<"\t$"<<loan<<" N/A\tN/A\tN/A\tN/A"<<endl;
	while (loan > 0) 
		{	
			// Increment of month
			month++;
			// Calculates interest to pay
			intrAmount = loan * (ratePerMonth/100);
			// adds up all of the interest paid
			interestPaid += intrAmount;
			// calculates principal to paid
			principal = monthlyPayments - intrAmount;
			// reduces loan left to pay by subtracting the principal
			loan -= principal;
			// checks to see if loan is negative
			if (loan < 0) 
			{
				principal+=loan;
				monthlyPayments = principal + intrAmount;
				loan = 0;
			} 
			cout<<fixed<<month<<"\t$"<<loan<<" $"<<monthlyPayments<<"\t"<<ratePerMonth<<fixed<<"\t$"<<intrAmount<<"\t$"<<principal<<endl;
					
		}
		cout<<"******************************************************\n"<<endl;
		cout<<"It takes "<<month<<" months to pay off the loan.\nTotal interest paid is: $"<<interestPaid<<endl;
	return 0;	
}