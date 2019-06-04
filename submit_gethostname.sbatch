#!/bin/bash
#SBATCH --job-name=get_hostname   # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, AL$
#SBATCH --mail-user=diaz.renata@ufl.edu   # Where to send mail
#SBATCH --account=ewhite
#SBATCH --qos=ewhite-b
#SBATCH --ntasks=1                 # Number of MPI ranks
#SBATCH --cpus-per-task=1            # Number of cores per MPI rank
#SBATCH --mem-per-cpu=1GB
#SBATCH --time=0:05:00       #Time limit hrs:min:sec
#SBATCH --output hostname%j.out
#SBATCH --error hostname%j.err

#This is a generic R submission script
module load R
Rscript get_hostname.R