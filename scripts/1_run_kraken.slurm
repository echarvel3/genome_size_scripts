#!/bin/bash
#SBATCH --job-name="kraken-2"
#SBATCH --partition=shared
#SBATCH --account=uot138
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=15
#SBATCH --array=1
#SBATCH --mem=30G
#SBATCH -o logs/kraken-2_%j_%a.out
#SBATCH -e logs/kraken-2_%j_%a.err
#SBATCH -t 12:00:00

source ${HOME}/.bashrc
source ${HOME}/miniconda3/etc/profile.d/conda.sh

NTHREADS=15
SCRIPT_DIR="../skimming_scripts-echarvel"

OUT_DIR="./kraken2_reads"
INPUT_DIR="./bbmap_reads/"

date
conda activate kraken2

set -x

echo "========"

mkdir --parents ${OUT_DIR}/folder_${SLURM_ARRAY_TASK_ID}

# Decontaminates reads using Kraken2's PLUS-PFP 16GB library.

for file in $(ls "${INPUT_DIR}/folder_${SLURM_ARRAY_TASK_ID}/"); do
            kraken2 \
                --db ./plus-pfp/ \
                "${INPUT_DIR}/folder_${SLURM_ARRAY_TASK_ID}/${file}" \
                --threads ${NTHREADS} \
                --unclassified-out ${OUT_DIR}/folder_${SLURM_ARRAY_TASK_ID}/unclass_${file%".fastq"}.fastq \
                --classified-out ${OUT_DIR}/folder_${SLURM_ARRAY_TASK_ID}/class_${file%".fastq"}.fastq > ${OUT_DIR}/folder_${SLURM_ARRAY_TASK_ID}/class-info_${file%".fastq"}.txt && echo "kraken2 classification done!!"
done

echo "========"
date

