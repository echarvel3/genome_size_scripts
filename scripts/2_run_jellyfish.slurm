#!/bin/bash
#SBATCH --job-name="jellyfish"
#SBATCH --partition=shared
#SBATCH --account=uot138
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=20G
#SBATCH -o logs/jellyfish_%j_%a.out
#SBATCH -e logs/jellyfish_%j_%a.err
#SBATCH -t 24:00:00
#SBATCH --array=1

module load cpu/0.15.4
module load parallel/20200822

source ${HOME}/.bashrc
source ${HOME}/miniconda3/etc/profile.d/conda.sh

conda activate skimming_scripts

echo "========"
set -x
RANDOM_SEED=0
NTHREADS=${NTHREADS:-1}

INPUT_DIR="./kraken2_reads/folder_${SLURM_ARRAY_TASK_ID}"
OUT_DIR="./decontam_jellyfish-test/folder_${SLURM_ARRAY_TASK_ID}"

date

mkdir --parents "${OUT_DIR}"

echo "========"

# Creates histogram files using jellyfish and also calculates average read length and numer of reads in a file.

touch ${OUT_DIR}/read_lengths.txt
touch ${OUT_DIR}/read_counts.txt

for x in $(realpath ${INPUT_DIR}/unclass*.fastq); do
	
	filename=${x##*/}
	echo -en ${filename%.fastq}.hist"\t" >> ${OUT_DIR}/read_lengths.txt
	echo -en ${filename}"\t" >> ${OUT_DIR}/read_counts.txt
	
	wc -l ${x} | awk '{x=$1/4; printf "%s\t%.0f\n", $2, x}' | cut -f2 >> ${OUT_DIR}/read_counts.txt &

	awk 'NR%4 == 2 {lengths[length($0)]++} END {for (l in lengths) {print l, lengths[l]}}' ${x} |
	awk '{ weighted_sum += $1 * $2; total_weight += $2 } END { print weighted_sum / total_weight }' >> ${OUT_DIR}/read_lengths.txt &

	/usr/bin/time -v jellyfish count -m 31 -s 100M -t ${NTHREADS} -C -o ${OUT_DIR}/${filename%.fastq}.jf ${x}
	/usr/bin/time -v jellyfish histo -h 1000000 ${OUT_DIR}/${filename%.fastq}.jf > ${OUT_DIR}/${filename%.fastq}.hist
done


echo "========"
date
