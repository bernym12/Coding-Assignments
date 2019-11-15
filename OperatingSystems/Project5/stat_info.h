#ifndef STAT_INFO_INCLUDE
#define STAT_INFO_INCLUDE
#include "scheduler.h"

struct stat_info {
    float waiting_time = 0;
    float response_time = 0;
    float turnaround_time = 0;
    float cpu_usage = 0;

};

struct stat_info comp_stat_info(vector<jobs> finished_list);
int display_stat_info(struct stat_info);


#endif