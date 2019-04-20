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

TriviaNode addQuestion(string question, string answer, int points, TriviaNode* next, TriviaNode* head);
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
	getline(cin,question);
	cout<<"\nEnter an answer: ";
	getline(cin,answer);
	cout<<"\nEnter award points: ";
	cin>>points;
	//current = addQuestion(question,response,points,current,trivia);
	// trivia = &current;
	cout<<"Continue? (Yes/No): ";
	getline(cin,response);
	// current.next = trivia;
	TriviaNode* prev = &current;
	 while(response.compare("no") != 0) {
	 	// trivia = current
		// TriviaNode current;
		cout<<"Enter a question: ";
		getline(cin,question);

		cout<<"\nEnter an answer: ";
		getline(cin,answer);
		cout<<"\nEnter award points: ";
		cin>>points;
		//current = addQuestion(question,response,points, current.next);
		prev->next = &current;
		prev = &current;
		cout<<"Continue? (Yes/No): ";
		getline(cin,response);
	 }

}

TriviaNode addQuestion(string question, string answer, int points, TriviaNode* next, TriviaNode* Head) {
	TriviaNode q1 = {question, answer, points,next};
	return q1;
}






