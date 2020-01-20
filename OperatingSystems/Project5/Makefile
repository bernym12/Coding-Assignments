#Makefile

CXX = g++
CXXFLAGS = -g
QUANTUM = 1
FILE = task.list
POLICY = FCFS

help:
	
scheduler:	scheduler.o stat_info.o
	$(CXX) $(CXXFLAGS) -o scheduler scheduler.o

scheduler.o:	scheduler.cpp stat_info.cpp scheduler.h stat_info.h
	$(CXX) $(CXXFLAGS) -c scheduler.cpp

run:
ifeq ($(POLICY), RR) 
	./scheduler $(FILE) $(POLICY) $(QUANTUM)
else
	./scheduler $(FILE) $(POLICY)
endif
