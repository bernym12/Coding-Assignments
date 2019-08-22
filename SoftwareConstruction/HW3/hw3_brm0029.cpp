/*
* Bernard Moussad
* Brm0029
* hw3_brm0029.cpp
* g++ hw3_brm0029.cpp
* ./a.out
* I used the tips Dr. Li provided in the homework description.
*/
   
#include <iostream>
#include <stdlib.h>
#include <assert.h>
#include <ctime>
using namespace std;

const double AARON_ODDS = (1.0/3.0) * 100;
const double BOB_ODDS = 50; 
const double CHARLIE_ODDS = 100;

void test_at_least_two_alive(void);
/* Test functionality of the at_least_two_alive function */

bool kill_by(double probability);
/* Input: Individual's probability of killing someone
*  Output: Boolean if the user will kill someone
*/

double percentage(int numWins);
/* Input: Number of wins the user had
*  Output: The percentage of battles the user won
*/

double battle1(int& aaron_wins, int& bob_wins, int& charlie_wins);
/* Input: Counters to keep track of each user's wins
*  Implements Aaron's first strategy
*  Ouput: Returns aaron_wins for comparison with his second strategy
*/

double battle2(int& aaron_wins, int& bob_wins, int& charlie_wins);
/* Input: Counters to kee
p track of each user's wins
*  Implement's Aaron's second strategy
*  Output: Returns aaron_wins for comparison with his first strategy
*/
bool at_least_two_alive(bool A_alive, bool B_alive, bool C_alive);
/* Input: A_alive indicates whether Aaron is alive */
/*		  B_alive indicates whether Bob is alive   */
/* 		  C_alive indicates whether Charlie is alive */	
/* Return: true if at least two are alive */
/*         otherwise return false */

void Aaron_shoots1(bool& B_alive, bool& C_alive);
/* Strategy 1: Use call by reference
* Input: B_alive indicates whether Bob alive or dead
* C_alive indicates whether Charlie is alive or dead 
* Return: Change B_alive into false if Bob is killed.
* Change C_alive into false if Charlie is killed.
*/

void Bob_shoots(bool& A_alive, bool& C_alive);
/* Call by reference
* Input: A_alive indicates if Aaron is alive or dead
* C_alive indicates whether Charlie is alive or dead 
* Return: Change A_alive into false if Aaron is killed.
* Change C_alive into false if Charlie is killed.
*/

void Charlie_shoots(bool& A_alive, bool& B_alive);
/* Call by reference
* Input: A_alive indicates if Aaron is alive or dead
* 		 B_alive indicates whether Bob is alive or dead
* Return: Change A_alive into false if Aaron is killed.
		  Change B_alive into false if Bob is killed.
*/

void Aaron_shoots2(bool& B_alive, bool& C_alive);
/* Strategy 2: Use call by reference
* Input: B_alive indicates whether Bob alive or dead
* C_alive indicates whether Charlie is alive or dead * Return: Change B_alive into false if Bob is killed.
* Change C_alive into false if Charlie is killed.
*/


bool at_least_two_alive(bool A_alive, bool B_alive, bool C_alive) {
	return ((A_alive && B_alive) || (A_alive && C_alive) || (B_alive && C_alive));
}

void Aaron_shoots1(bool& B_alive, bool& C_alive) {
	if (kill_by(AARON_ODDS)) {
		if (C_alive) {
			C_alive = false;
		}
		else {
			B_alive = false;
		}
	}	
}

void Bob_shoots(bool& A_alive, bool& C_alive) {
	if (kill_by(BOB_ODDS)) {
		if (C_alive) {
			C_alive = false;
		}
		else {
			A_alive = false;
		}
	}
}

void Charlie_shoots(bool& A_alive, bool& B_alive) {
	if (kill_by(CHARLIE_ODDS)) {
		if (B_alive) {
			B_alive = false;
		}
		else {
			A_alive = false;
		}
	}
}

void Aaron_shoots2(bool& B_alive, bool& C_alive) {
	if (B_alive && C_alive) {
		return void();
	}
	else if (kill_by(AARON_ODDS) && C_alive) {
		C_alive = false;
	}
	else if (kill_by(AARON_ODDS) && B_alive) {
		B_alive = false;
	}
	
}

void test_at_least_two_alive(void) {
	cout << "Unit Testing 1: Function – at_least_two_alive()\n";
	cout << "Case 1: Aaron alive, Bob alive, Charlie alive\n"; 
	assert(true == at_least_two_alive(true, true, true));
	cout << "Case passed ...\n";
	cout << "Case 2: Aaron dead, Bob alive, Charlie alive\n";
	assert(true == at_least_two_alive(false, true, true)); 
	cout << "Case passed ...\n";
	cout << "Case 3: Aaron alive, Bob dead, Charlie alive\n";
	assert(true == at_least_two_alive(true, false, true)); 
	cout << "Case passed ...\n";
	cout << "Case 4: Aaron alive, Bob alive, Charlie dead\n";
	assert(true == at_least_two_alive(true, true, false)); 
	cout << "Case passed ...\n";
	cout << "Case 5: Aaron dead, Bob dead, Charlie alive\n";
	assert(false == at_least_two_alive(false, false, true)); 
	cout << "Case passed ...\n";
	cout << "Case 6: Aaron dead, Bob alive, Charlie dead\n";
	assert(false == at_least_two_alive(false, true, false)); 
	cout << "Case passed ...\n";
	cout << "Case 7: Aaron alive, Bob dead, Charlie dead\n";
	assert(false == at_least_two_alive(true, false, false)); 
	cout << "Case passed ...\n";
	cout << "Case 8: Aaron dead, Bob dead, Charlie alive\n";
	assert(false == at_least_two_alive(false, false, false)); 
	cout << "Case passed ...\n";
}

bool kill_by(double probability) {
	int shoot_target_result;	
   	shoot_target_result = rand()%100;
   	if (shoot_target_result <= (probability)) {
    	return true;
    }
    return false;
}

void pause() {
	cout << "Press Enter to continue...";
	cin.get(); 
}

double percentage(int numWins) {
	return (numWins/10000.0 * 100.0);
}

double battle1(int& aaron_wins, int& bob_wins, int& charlie_wins) {
	aaron_wins = 0;
	bob_wins = 0;
	charlie_wins = 0;
	for (int times = 0; times < 10000; times++) {
		bool A_alive = true;
		bool B_alive = true;
		bool C_alive = true;
		while (at_least_two_alive(A_alive, B_alive, C_alive)) {
			if (A_alive) {
				Aaron_shoots1(B_alive, C_alive);
				
			}
			if (B_alive) {
				Bob_shoots(A_alive, C_alive);
				
			}
			if (C_alive) {
				Charlie_shoots(A_alive, B_alive);
				
			}
		}
		if (A_alive) {
			aaron_wins++;
		}	
		else if (B_alive) {
			bob_wins++;
		}	
		else {
			charlie_wins++;
		}		
	}
	cout<<"Aaron won "<<aaron_wins<<"/10000 duels or "<<(percentage(aaron_wins))<<"%"<<endl;
	cout<<"Bob won "<<bob_wins<<"/10000 duels or "<<(percentage(bob_wins))<<"%"<<endl;
	cout<<"Charlie won "<<charlie_wins<<"/10000 duels or "<<(percentage(charlie_wins))<<"%"<<endl;
	return (percentage(aaron_wins));
}

double battle2(int& aaron_wins, int& bob_wins, int& charlie_wins) {
	aaron_wins = 0;
	bob_wins = 0;
	charlie_wins = 0;
	for (int times = 0; times < 10000; times++) {
		bool A_alive = true;
		bool B_alive = true;
		bool C_alive = true;
		while (at_least_two_alive(A_alive, B_alive, C_alive)) {
			if (A_alive) {
				Aaron_shoots2(B_alive, C_alive);
				
			}
			if (B_alive) {
				Bob_shoots(A_alive, C_alive);
				
			}
			if (C_alive) {
				Charlie_shoots(A_alive, B_alive);
				
			}
		}
		if (A_alive) {
			aaron_wins++;
		}	
		else if (B_alive) {
			bob_wins++;
		}	
		else {
			charlie_wins++;
		}			
	}
	cout<<"Aaron won "<<aaron_wins<<"/10000 duels or "<<(percentage(aaron_wins))<<"%"<<endl;
	cout<<"Bob won "<<bob_wins<<"/10000 duels or "<<(percentage(bob_wins))<<"%"<<endl;
	cout<<"Charlie won "<<charlie_wins<<"/10000 duels or "<<(percentage(charlie_wins))<<"%"<<endl;
	return (percentage(aaron_wins));
}

int main() {
	int aaron_wins = 0, bob_wins = 0, charlie_wins = 0;
	double result1, result2;
	cout<<"*** Welcome to the Duel Simulator ***"<<endl;
	test_at_least_two_alive();
	pause();
	cout<<"Ready to test strategy 1 (run 10000 times):"<<endl;
	pause();
	srand(time(0));
	result1 = battle1(aaron_wins, bob_wins, charlie_wins);
	cout<<"\nReady to test strategy 2 (run 10000 times):"<<endl;
	pause();
	result2 = battle2(aaron_wins,bob_wins,charlie_wins);
	if (result2 > result1) {
		cout<<"\nStrategy 2 is better than strategy 1."<<endl;
	}
	else {
		cout<<"\nStrategy 1 is better than strategy 2."<<endl;
	}
}

