------------------
Usage Instructions
------------------

The environment required to run is Linux with python 3.7.4

Initially, project3_setup.py needs to be run in order to create the calcs.pickle and priors.pickle 
files. These will be needed in order to run the project3_predict.py program.

The results from my runs have been included if you wish to immediately begin running the prediction program.

project3_predict.py requires 2 arguments: a pssm file and it's corresponding ss file. The path to the file must be included within the arguments. The ss file is only used to compare 
against in order to calculate the Q3 accuracy.

Steps:

1) python project3_setup.py
2) python project3_predict.py <pssm_file> <ss_file>
    ex. python project3_predict.py pssm/5ptp.pssm ss/5ptp.ss