
#include <iomanip>
// #include "scheduler.h"
#include "stat_info.h"

struct stat_info comp_stat_info(vector<jobs> finished_list) {
      jobs curr_job;
      stat_info stats;
      for(int i = 0; i < finished_list.size(); i++) {
         curr_job = finished_list.at(i);
         stats.waiting_time += (curr_job.finish_time - curr_job.arrival_time - curr_job.burst_time);
         stats.turnaround_time += (curr_job.finish_time - curr_job.arrival_time);
         stats.response_time += (curr_job.start_time - curr_job.arrival_time);     
         stats.cpu_usage += curr_job.burst_time / (curr_job.finish_time - curr_job.arrival_time);
      }
      stats.waiting_time /= finished_list.size();
      stats.turnaround_time /= finished_list.size();
      stats.response_time /= finished_list.size();
      stats.cpu_usage *= 100;
      return stats;
   }

   int display_stat_info(stat_info stats) {
        cout << fixed << showpoint<< setprecision(2);
        cout << "Average waiting time:  " << stats.waiting_time << endl;
        cout << "Average response time:  " << stats.response_time << endl;
        cout << "Average turnaround time:  " << stats.turnaround_time << endl;
        cout << "Overall CPU usage:  " << stats.cpu_usage << "%" << endl;
        return 0;
   }

