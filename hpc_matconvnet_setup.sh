#!/bin/bash

# Author: Ryan McCormick
# File: matconv_setup.sh
# Purpose: To setup everything necessary for matconvnet
#                  as well as CUDA and CUDNN for GPU acceleration


# Setup directory for all downloads if it doesn't already exist
mkdir -p $HOME/bin
cd $HOME/bin

### VLFEAT

# Download vlfeat from their website if it's not already downloaded
if [ ! -f "$HOME/bin/vlfeat-0.9.20-bin.tar.gz" ]; then
        wget http://www.vlfeat.org/download/vlfeat-0.9.20-bin.tar.gz
fi

# Untar it, move into the directory, and build the files
tar -xvzf vlfeat-0.9.20-bin.tar.gz
cd vlfeat-0.9.20

# mlpath will be matlab's root path
# Should look something like /usr/local/MATLAB/R2017a
mlpath=`matlab -e | sed -n 's/MATLAB=//p'`

# Run mex script
make MEX="$mlpath/bin/mex"

# Testing VLFeat installation
echo "run('vlfeat-0.9.20/toolbox/vl_setup')" > "$HOME/bin/startup.m"
echo "quit" >> "$HOME/bin/startup.m"

echo
echo "VLFeat successfully installed!"
echo

### MATCONVNET
cd $HOME/bin

# Download if it doesn't exist
if [ ! -f "$HOME/bin/matconvnet-1.0-beta24.tar.gz" ]; then
        wget http://www.vlfeat.org/matconvnet/download/matconvnet-1.0-beta24.tar.gz
fi

tar -xvzf matconvnet-1.0-beta24.tar.gz
cd matconvnet-1.0-beta24

mcnpath="$HOME/bin/matconvnet-1.0-beta24"
# Check for GPU or CPU compilation
echo
echo "Enter if you want to compile for 'CPU' or 'GPU' (if you have it): "
read processor

# CPU
if [[ "$processor" == "CPU" ]] || [[ "$processor" == "cpu" ]]; then
        echo "addpath matlab" > cpu_setup.m
        echo "vl_compilenn" >> cpu_setup.m
        echo "vl_setupnn" >> cpu_setup.m
        #echo "vl_testnn" >> cpu_setup.m
        #echo "quit" >> cpu_setup.m
        matlab -nodisplay -nodesktop -r "run cpu_setup.m"

        echo
        echo "MatConvNet setup correctly for CPU!"
        echo

# GPU - difficult to automate because of nvidia account and sudo requirements
elif [[ "$processor" == "GPU" ]] || [[ "$processor" == "gpu" ]]; then
        echo "You will need root priveliges to setup gpu compilation!"
        echo "Download Cuda 8.0 from https://developer.nvidia.com/cuda-downloads"
        echo "Follow the instructions on their website for your operating system...\n"
        echo "Move the cuda files into '$HOME/bin'"
        echo "Add the line 'export LD_LIBRARY_PATH=$HOME/bin/cuda-8.0/lib64:$LD_LIBRARY_PATH' to your ~/.bashrc and then execute 'source ~/.bashrc'"
        echo "Download cudnn v5.1 for Cuda 8.0 from https://developer.nvidia.com/rdp/cudnn-download"
        echo "Move the '---/cudnn/lib64' files into '$HOME/bin/cuda/lib64' and '---/cudnn/include' files into '---/cuda/include'"

        echo "Have you downloaded both Cuda 8.0 and cudnn v5.1 for Cuda 8.0? Enter [y/n]: "
        read answer

        if [[ "$answer" -eq "y" ]]; then
                echo "addpath matlab" > gpu_compile.m
                echo "mex -setup C" >> gpu_compile.m
                echo "mex -setup C++" >> gpu_compile.m
                echo "vl_compilenn('enableGpu', true, 'enableCudnn', true,'enableImreadJpeg', true)" >> gpu_compile.m
                echo "addpath matlab" > gpu_setup.m
                echo "vl_setupnn" >> gpu_setup.m
                echo "%vl_testnn('gpu', true, 'cpu', false)" >> gpu_setup.m
                matlab -nodisplay -nodesktop -r "run 'gpu_compile.m'"
                matlab -nodisplay -nodesktop -r "run 'gpu_setup.m'"
                echo "See '$mcnpath/gpu_setup.m' or '$mcnpath/gpu_compile.m' for any instructions that failed"
                echo "vl_testnn was commented out for time's sake, but if something isn't working, just run that commented line in 'gpu_setup.m'"
        fi

fi

