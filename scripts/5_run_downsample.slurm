#!/bin/bash
#SBATCH --job-name="downsample"
#SBATCH --partition=shared
#SBATCH --account=uot138
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=20G
#SBATCH -o logs/respect_full_%j_%a.out
#SBATCH -e logs/respect_full_%j_%a.err
#SBATCH -t 24:00:00
#SBATCH --array 1

module load cpu/0.15.4
module load parallel/20200822

source ${HOME}/.bashrc
source ${HOME}/miniconda3/etc/profile.d/conda.sh

conda activate skimming_scripts

echo "========"
set -x
NTHREADS=${NTHREADS:-20}
REPLICATES=4

FASTQ_DIR="./kraken2_reads/folder_${SLURM_ARRAY_TASK_ID}/"
JELLY_DIR="./decontam_jellyfish/folder_${SLURM_ARRAY_TASK_ID}/"
PARAMETER_FILE="./full_cov_respect_output/estimated-parameters.txt"

OUT_DIR="./downsampled_fastq/folder_${SLURM_ARRAY_TASK_ID}/"

date

mkdir --parents "${OUT_DIR}"

echo "========"

for x in $(realpath ${FASTQ_DIR}/unclass*); do
	filename=${x##*/}
	line_count=$(grep "${filename}" "${JELLY_DIR}/read_counts.txt" | cut -f2)
	coverage=$(grep "${filename%.fastq}" ${PARAMETER_FILE} | cut -f4)
	target_cov=4

	sample_num=$(printf %.0f $(echo "${line_count}/${coverage}*${target_cov}" | bc -l))

	for y in {1..4}; do
		/usr/bin/time -v seqtk sample -s${y} -2 "${x}" "${sample_num}" > "${OUT_DIR}/${filename%.fastq}_rep${y}.fastq"
	done
done

echo "========"
date
