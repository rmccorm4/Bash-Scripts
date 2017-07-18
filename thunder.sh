#!/bin/bash

# AUTHOR: Ryan McCormick (ATR Center 2017 Intern)
#
# This is a script to make submitting jobs and starting interactive
# sessions on Thunder easier
#
# Run this file by executing './thunder.sh' in the command line
#
# All of the values immediately following '-l' flages are adjustable.
#
# -A $ACCOUNT is a general environment variable that will get the
# information relevant to your account
#
# -q refers to your session as being in 'debug' or 'standard' mode.
# 	* 'debug' mode will usually start faster when requesting an interactive
#	  session but is restricted to only 1 hour of use per session
#	* 'standard' mode allows you to have significantly more time and
#	  is what you should use for extensive testing and submitting jobs
#
# -l is for requesting hardware and time for your jobs
#	* 'select' is the number of nodes you would like
#	* 'ncpus' is the number of cpu cores per node
#	* 'mpiprocs' is the number of MPI processes per node which is only
#	  relevant to code that utilizes MPI and won't affect you otherwise.
#	  It can go effectively go from 1 to 'ncpus'.
#	* 'ngpus' is the number of gpus per node you would like, from 1-2.
#		* On Thunder - only nodes 13-16 can request GPUs (I believe)
#		* To access these nodes, when ssh'ing into thunder you include the
#		  number in your requested hostname
#			* ex) ssh <username>@thunder13.afrl.hpc.mil
#	* 'walltime' is the number of real-time hours that your job can run for
#		* If you do not include anything in your code to stop executing when
#		  finished, such as 'exit' in Matlab, your job might not end until
# 		  the requested time is up. You can double check if your code has
#		  finished by running 'qpeek <job_number>' in the command line
#	* '-l application=MATLAB -l MATLAB=1'
#		* These two flags combined are for running jobs that require a matlab
#		  license, and says to not submit your job until a license is available
#		  so that your job doesn't fail for no licenses being open
#		  
#		  DISCLAIMER: You should really try to compile your Matlab code
#			into a standalone executable using 'mcc -m <matlab_file_name>'
#			because there are only 20 or so Matlab licenses available
#			in total for everyone to share

echo "Enter '1' for an interactive session or '2' to submit a job: "
read session

# Interactive Session
if [[ "$session" == "1" ]]; then
	echo "Enter '1' for debug or '2' for standard: "
	read choice
	
	if [[ "$choice" == "1" ]]; then
		echo "Starting interactive session in debug mode..."
		qsub -A $ACCOUNT -q debug -l select=1:ncpus=28:mpiprocs=1:ngpus=1 -l walltime=01:00:00 -I

	elif [[ "$choice" == "2" ]]; then
		echo "Starting interactive session in standard mode..."
		qsub -A $ACCOUNT -q standard -l select=1:ncpus=1:mpiprocs=1:ngpus=1 -l walltime=08:00:00 -I
	
	else
		echo "You didn't enter valid choices! Quitting script..."
	fi

# Submitting jobs
elif [[ "$session" == "2" ]]; then
	# This can be changed to relative path if you omit the 'cd job_reports'
	# commands below but will lose organization of job reports
	# There is probably a smarter way to handle both of these things
	echo "Enter the absolute path of the shell script to run: "
	read file
	
	# Create an organized place for job reports to go
	mkdir -p job_reports && cd job_reports

	echo "Enter '1' to pass args or '2' to run as is: "
	read choice
	
	if [[ "$choice" == "1" ]]; then
		echo "Enter args as arg1=?,arg2=?,...,argX=? (ARGUMENT NAMES MUST MATCH THOSE IN SCRIPT): "
		read args
		echo "Submitting job for $file with $args..."
		qsub -A $ACCOUNT -q standard -l select=1:ncpus=28:mpiprocs=1:ngpus=1 -l application=MATLAB -l MATLAB=1 -l walltime=148:00:00 -v $args $file
	
	elif [[ "$choice" == "2" ]]; then
		echo "Submitting job for $file with no args..."
		qsub -A $ACCOUNT -q standard -l select=1:ncpus=28:mpiprocs=1:ngpus=1 -l application=MATLAB -l MATLAB=1 -l walltime=148:00:00 $file

	else
		echo "You didn't enter valid choices! Quitting script..."
	fi

else
	echo "You didn't enter valid choices! Quitting script..."
fi
