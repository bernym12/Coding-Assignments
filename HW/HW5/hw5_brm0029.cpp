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

int addQuestion(string question, string answer, int points, TriviaNode* &head, TriviaNode* &tail);
void initialTrivia(TriviaNode* &head, TriviaNode* &tail);
int askQuestion(TriviaNode* &head, int numToAsk);

int main() {
	TriviaNode* trivia = NULL;
	TriviaNode* tail = NULL;
	// string player = "Bernie";
	// string response;
	// string question;
	// string answer;
	// int points;	
	// cout<<"* * * Welcome to "<<player<<"'s trivia quiz game * * *"<<endl;
	// cout<<"Enter a question: ";
	// getline(cin,question);

	// cout<<"\nEnter an answer: ";
	// getline(cin,answer);

	// cout<<"\nEnter award points: ";
	// cin>>points;

	// cout<<"Continue? (Yes/No): ";
	// getline(cin,response);

	//  while(response.compare("no") != 0) {
	// 	cout<<"Enter a question: ";
	// 	getline(cin,question);

	// 	cout<<"\nEnter an answer: ";
	// 	getline(cin,answer);
	// 	cout<<"\nEnter award points: ";
	// 	cin>>points;
	// 	cout<<"Continue? (Yes/No): ";
	// 	getline(cin,response);
	//  }
	initialTrivia(trivia, tail);
	//cout<<trivia->question<<endl;
	// TriviaNode* access;
	// access = trivia;
	//cout<<tail<<endl;
	
	askQuestion(trivia, 2);
}

int addQuestion(string question, string answer, int points, TriviaNode* &head, TriviaNode* &tail) {
	TriviaNode* q1 = new TriviaNode;
	if (q1 == NULL) {
		cout<<"ERROR: TriviaNode not created"<<endl;
		return -1;
	}
	q1->question = question;
	q1->answer = answer;
	q1->points = points;

	
	if (head == NULL) {	
		head = q1;
		tail = q1;		
	}
	else {
		tail->next = q1;
		tail = q1;
	}
	return 0;
}

int askQuestion(TriviaNode* &head, int numToAsk) {
	
	if (numToAsk < 1) {
		cout<<"Must ask at least 1 question"<<endl;
		return 1;
	}

	TriviaNode* access = new TriviaNode;
	access = head;
	int start = 0;
	while((access) != NULL && start < numToAsk) {
		cout<<access->question<<endl;
		access = access->next;
		start++;
	}
	return 0;
}

void initialTrivia(TriviaNode* &head, TriviaNode* &tail) {
	addQuestion("How long was the shortest war on record? (Hint: how many minutes)", "38", 100, head, tail);
	addQuestion("What was Bank of America's original name? (Hint: Bank of Italy or Bank of Germany)", "Bank of Italy", 50, head, tail);
	addQuestion("What is the best-selling video game of all time? (Hint: Minecraft or Tetris)", "Tetris", 20, head, tail);
}






