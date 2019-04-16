#include <iostream>
#include <cmath>
#include <ctime>
#include <string>
using namespace std;

struct TriviaNode
{
	string question;
	string answer;
	int	points;
	TriviaNode* next;

};

TriviaNode addQuestion(string question, string answer, int points, TriviaNode* next);
int main() {
	TriviaNode* trivia;
	TriviaNode current;
	trivia = &current;
	string player = "Bernie";
	string response;
	string question;
	string answer;
	int points;	
	cout<<"* * * Welcome to "<<player<<"'s trivia quiz game * * *"<<endl;
	cout<<"Enter a question: ";
	cin>>question;
	while (cin.fail())
  	{
     	cout << "ERROR -- You did not enter an integer";

     // get rid of failure state
     	// cout<<question;
     	cin.clear();
     	cout<<"Enter a question: ";
		cin>>question; 
	}	
	cout<<"\nEnter an answer: ";
	cin>>answer;
	cout<<"\nEnter award points: ";
	cin>>points;
	current = addQuestion(question,response,points,trivia);
	// trivia = &current;
	cout<<"Continue? (Yes/No): ";
	cin>>response;
	// current.next = trivia;
	TriviaNode* prev = &current;
	 while(response.compare("no") != 0) {
	 	// trivia = current
		// TriviaNode current;
		cout<<"Enter a question: ";
		cin>>question;

		cout<<"\nEnter an answer: ";
		cin>>answer;
		cout<<"\nEnter award points: ";
		cin>>points;
		current = addQuestion(question,response,points, current.next);
		prev->next = &current;
		prev = &current;
		cout<<"Continue? (Yes/No): ";
		cin>>response;
	 }

}

TriviaNode addQuestion(string question, string answer, int points, TriviaNode* next) {
	TriviaNode q1 = {question, answer, points,next};
	return q1;
}






