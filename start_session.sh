#!/bin/bash

# You're going to need to load the modules listed in 'load.sh'

# Choose interactive or submission
echo "Enter interactive or submit: "
read session

if [[ "$session" == "interactive" ]]; then
	# Get queue type
	echo "Enter 'debug' or 'standard' mode: "
	read mode

	if [[ "$mode" == "debug" ]]; then
		# Run interactive session with gpus in debug mode
		echo "Requesting debug session..."
		qsub -A $(ACCOUNT) -l select=1:ncpus=8:mpiprocs=1:ngpus=1 -q debug -l walltime=1:00:00 -I

	elif [[ "$mode" == "standard" ]]; then
		# Run interactive session with gpus in standard mode
		echo "Requesting standard session..."
		# select == num nodes, ncpus == num cores per node, mpiprocs <= ncpus, ngpus == num gpus
		qsub -A $ACCOUNT -l select=1:ncpus=28:mpiprocs=28:ngpus=2 -q standard -l walltime=148:00:00 -I
	fi

elif [[ "$session" == "submit" ]]; then
	# Get network to run
	echo "Enter 'cifar' or 'tiny': "
	read network

	if [[ "$network" == "cifar" ]]; then
		echo "Submitting job for cifar_lenet q-matrix computations..."
		qsub -A $ACCOUNT -l select=1:ncpus=28:mpiprocs=28:ngpus=2 -q standard -l walltime=148:00:00 cifar_job.sh
	elif [[ "$network" == "tiny" ]]; then
		echo "Submitting job for tiny_imagenet q-matrix computations..."
		qsub -A $ACCOUNT -l select=1:ncpus=28:mpiprocs=28:ngpus=2 -q standard -l walltime=148:00:00 tiny_job.sh	
	else
		echo "You didn't enter either of the choices!"
	fi
fi
# Setup matconvnet and vlfeat if necessary
#./hpc_matconvnet_setup.sh
