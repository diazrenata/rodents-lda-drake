
#!/bin/bash
#SBATCH --job-name=rodents_master   # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, AL$
#SBATCH --mail-user=diaz.renata@ufl.edu   # Where to send mail
#SBATCH --account=ewhite
#SBATCH --qos=ewhite-b
#SBATCH --ntasks=1                 # Number of MPI ranks
#SBATCH --cpus-per-task=1            # Number of cores per MPI rank
#SBATCH --mem-per-cpu=2GB
#SBATCH --time=1:00:00       #Time limit hrs:min:sec
#SBATCH --output rodents%j.out
#SBATCH --error rodents%j.err

#This is a generic R submission script
module load R
Rscript script.R