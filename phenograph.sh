#!/bin/bash

#SBATCH --job-name=CyTOF_20200909_phenograph
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=3GB
#SBATCH --array=1000-12000:1000
#SBATCH --time=02:00:00

Rscript Phenograph.R

