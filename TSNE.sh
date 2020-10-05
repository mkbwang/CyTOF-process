#!/bin/bash

#SBATCH --job-name=CyTOF_20200909_TSNE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1GB
#SBATCH --time=00:30:00

Rscript TSNE.R
