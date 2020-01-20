#include <bits/stdc++.h> 
#include <cstdlib>
#include "scheduler.h"
#include "stat_info.h"
#include "stat_info.cpp"

using namespace std;

   int main(int argc, char *argv[])
   {
      int clock = 0;
      parse(argc, argv, file_name, policy, quantum);
      readfile(job_list, fp, file_name);
      // error_check() 
      stat_info stats;
      cout << "Scheduling Policy: " << policy << endl;
      cout << "There are " << job_list.size() <<" tasks loaded from \"" << file_name << "\"."<< endl;
      if (quantum > 0) {
         cout << "Quantum: " << quantum << endl;
      }
      cout << "==================================================================" <<endl;
      pause();     
      while (!job_list.empty() || !ready_queue.empty()) {
            int init_size = job_list.size();
            jobs check_time;
            for (int i = 0; i < init_size; i++) {
               check_time = job_list.at(0);
               if (check_time.arrival_time <= clock) {
                  check_time.remaining_time = check_time.burst_time;
                  ready_queue.push_back(check_time);
                  job_list.erase(job_list.begin());
               }
               else {
                  break;
               }
            }
            if (strcmp((char*)policy.c_str(), "FCFS") == 0) {
               fcfs(job_list, ready_queue, finished_list, clock);
            } 
            else if (strcmp((char*)policy.c_str(), "SRTF") == 0) {
               srtf(job_list, ready_queue, finished_list, clock);
            } 
            else if (strcmp((char*)policy.c_str(), "RR") == 0){
               rr(job_list, ready_queue, finished_list, clock, quantum);
            }
            else {
               cout << "Invalid scheduling policy" << endl;
               exit(0);
            }
            clock++;
      }
      cout << "<time " << clock << "> All processes finished ......" << endl;
      cout << "============================================================" << endl;
      stats = comp_stat_info(finished_list);
      display_stat_info(stats);
   }

   int parse(int argc, char *argv[], string &file_name, string &policy, int &quantum ) {
       if (argc < 2  || argc > 4) {        //checks if there are enough args or too many
         cout << "Usage: command file_name [FCFS|RR|SRTF] [time_quantum]\n";
         exit(0);
      }
      
      file_name = argv[1]; //sets file_name
      policy = argv[2];
      if (strcmp(argv[2], "RR") == 0) {   //if schedule option is RR then time quantum is required
         if (argc == 4) {
            sscanf(argv[3],"%d", &quantum);
         }
         else {
            cout << "Please include time_quantum for RR\n";
            exit(0);
         }
      }

   }

   int readfile(vector<jobs> &job_list, ifstream& fp, string file_name) {
      fp.open(file_name); 
      if(fp.fail()) {   //If input file doesn't exist, end program
         cout << "File name " << file_name << " does not exist." << endl;
         exit(0);
      }
      struct jobs hold;
      while(fp >> hold.pid >> hold.arrival_time >> hold.burst_time) { //store each job into a temporary struct and insert it into the vector of jobs
         job_list.push_back(hold);
      }
      fp.close();
   }

   int fcfs(vector<jobs> &job_list, vector<jobs> &ready_queue, vector<jobs> &finished_list, int clock) {
      jobs* curr_job;
      sort(job_list.begin(), job_list.end(), arrival_comp);
      curr_job = &ready_queue.at(0);
            if (ready_queue.empty()) {
               cout << "No jobs currently running" << endl;
            }
            if(curr_job->remaining_time == curr_job->burst_time) {
               curr_job->start_time = clock;
            }
            curr_job->remaining_time--;
            cout << "<time " << clock << "> process "<< curr_job->pid <<" is running" << endl;

            if(curr_job->remaining_time == 0) {
               curr_job->finish_time = clock;
               cout << "<time " << clock << "> process "<< curr_job->pid <<" is finished..." << endl;
               finished_list.push_back(*curr_job);
               ready_queue.erase(ready_queue.begin());  
            }
   }

   int srtf(vector<jobs> &job_list, vector<jobs> &ready_queue, vector<jobs> &finished_list, int clock) {
      jobs* curr_job;
      sort(ready_queue.begin(), ready_queue.end(), remaining_comp);
      curr_job = &ready_queue.at(0);
      if (ready_queue.empty()) {
         cout << "No jobs currently running" << endl;
      }
      if(curr_job->remaining_time == curr_job->burst_time) {
         curr_job->start_time = clock;
      }
      cout << "<time " << clock << "> process "<< curr_job->pid <<" is running" << endl;
      curr_job->remaining_time--;
      if(curr_job->remaining_time == 0) {
         curr_job->finish_time = clock;
         cout << "<time " << clock << "> process "<< curr_job->pid <<" is finished..." << endl;
         finished_list.push_back(*curr_job);
         ready_queue.erase(ready_queue.begin());  
      }
   }

   int rr(vector<jobs> &job_list, vector<jobs> &ready_queue, vector<jobs> &finished_list, int clock, int quantum) {
      jobs* curr_job;
      curr_job = &ready_queue.at(0);
      if (ready_queue.empty()) {
         cout << "No jobs currently running" << endl;
      }
      if(curr_job->remaining_time == curr_job->burst_time) {
         curr_job->start_time = clock;
      }
      cout << "<time " << clock << "> process "<< curr_job->pid <<" is running" << endl;
      curr_job->remaining_time--;
      curr_job->time_run++;
      
      if(curr_job->remaining_time == 0) {
         curr_job->finish_time = clock;
         cout << "<time " << clock << "> process "<< curr_job->pid <<" is finished..." << endl;
         finished_list.push_back(*curr_job);
         ready_queue.erase(ready_queue.begin());  
      } 
      else if (curr_job->time_run == quantum) {
         curr_job->time_run = 0;
         ready_queue.push_back(*curr_job);
         ready_queue.erase(ready_queue.begin());
      }  
   }

   bool arrival_comp(jobs job1, jobs job2) {
      return (job1.arrival_time < job2.arrival_time);
   }

   bool remaining_comp(jobs job1, jobs job2) {
      return (job1.remaining_time < job2.remaining_time);
   }

   void pause() {
	cout << "Press Enter to continue...";
	cin.get(); 
}
