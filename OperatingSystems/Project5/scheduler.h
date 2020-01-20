#ifndef SCHEDULER_INCLUDE
#define SCHEDULER_INCLUDE
#include <iostream>
#include <string.h>
#include <vector>
#include <fstream>

using namespace std;

struct jobs {
   int pid;
   int arrival_time;
   int burst_time;
   int start_time = 0;
   int remaining_time = 0;
   int finish_time = 0;
   int time_run = 0;
};


bool arrival_comp(jobs job1, jobs job2);
bool remaining_comp(jobs job1, jobs job2);

int parse(int argc, char *argv[], string &file_name, string &policy, int &quantum);
int readfile(vector<jobs> &job_list, ifstream& fp, string file_name);

int fcfs(vector<jobs> &job_list, vector<jobs> &ready_queue, vector<jobs> &finished_list, int clock);
int srtf(vector<jobs> &job_list, vector<jobs> &ready_queue, vector<jobs> &finished_list, int clock);
int rr(vector<jobs> &job_list, vector<jobs> &ready_queue, vector<jobs> &finished_list, int clock, int quantum);
void pause();

int quantum;
string policy;
string file_name;
ifstream fp;
vector<jobs> job_list;
vector<jobs> ready_queue;
vector<jobs> finished_list;


#endif
