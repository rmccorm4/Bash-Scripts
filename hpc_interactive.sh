#!/bin/bash

# Make sure to load required modules for your code

# Get user input
echo "Enter 'debug' or 'standard' mode: "
read mode

if [[ "$mode" == "debug" ]]; then
    # Run interactive session with gpus in debug mode
	qsub -A $PROJECT -l select=1:ncpus=8:mpiprocs=1:ngpus=1 -q debug -l walltime=1:00:00 -I

elif [[ "$mode" == "standard" ]]; then
	# Run interactive session with gpus in standard mode - numbers are adjustable!
	qsub -A $PROJECT -l select=1:ncpus=28:mpiprocs=28:ngpus=2 -q standard -l walltime=8:00:00 -I
fi

# Setup matconvnet and vlfeat if necessary
#./hpc_matconvnet_setup.sh
