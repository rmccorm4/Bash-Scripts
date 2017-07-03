#!/bin/bash

# This is a script to make submitting jobs and starting interactive
# sessions on Thunder easier

echo "Enter 'submit' or 'interactive': "
read session

# Interactive Session
if [[ "$session" == "interactive" ]]; then
	echo "Enter 'debug' or 'standard': "
	read choice
	
	if [[ "$choice" == "debug" ]]; then
		echo "Starting interactive session in debug mode..."
		qsub -A $ACCOUNT -q debug -l select=1:ncpus=28:mpiprocs=1:ngpus=1 -I
	
	elif [[ "$choice" == "standard" ]]; then
		echo "Starting interactive session in standard mode..."
		qsub -A $ACCOUNT -q standard -l select=1:ncpus=28:mpiprocs=1:ngpus=1 -I

	else
		echo "You didn't enter valid choices! Quitting script..."

	fi

# Submitting jobs
elif [[ "$session" == "submit" ]]; then
	echo "Enter the full path of the file to submit: "
	read file

	echo "Submitting job for $file..."
	qsub -A $ACCOUNT -q standard -l select=1:ncpus=28:mpiprocs=1:ngpus=1

else
	echo "You didn't enter valid choices! Quitting script..."

fi
