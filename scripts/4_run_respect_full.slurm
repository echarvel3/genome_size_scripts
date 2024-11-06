#!/bin/bash
#SBATCH --job-name="respect_full"
#SBATCH --partition=shared
#SBATCH --account=uot138
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=20G
#SBATCH -o logs/respect_full_%j_%a.out
#SBATCH -e logs/respect_full_%j_%a.err
#SBATCH -t 24:00:00

module load cpu/0.15.4
module load parallel/20200822

source ${HOME}/.bashrc
source ${HOME}/miniconda3/etc/profile.d/conda.sh

conda activate skimming_scripts

echo "========"
set -x
NTHREADS=${NTHREADS:-20}

INPUT_DIR="./full_cov_respect/"
OUT_DIR="./full_cov_respect_output/"

date

mkdir --parents "${OUT_DIR}"

echo "========"

#Runs inital RESPECT run.

respect -d ${INPUT_DIR} -I ${INPUT_DIR}/hist_info.txt -N 1000 -s 50 -o ${OUT_DIR} --threads ${NTHREADS}

echo "========"
date
