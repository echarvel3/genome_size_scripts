#!/bin/bash
#SBATCH --job-name="bbmap_pipeline"
#SBATCH --partition=shared
#SBATCH --account=uot138
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --array=1
#SBATCH -o logs/bbmap_%j-%a.out
#SBATCH -e logs/bbmap_%j-%a.err
#SBATCH -t 6:00:00

source ${HOME}/.bashrc
source ${HOME}/programs/miniconda3/etc/profile.d/conda.sh
set -x

echo "========"

#SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

RANDOM_SEED=0
NTHREADS=${NTHREADS:-15}
INPUT="./folder_${SLURM_ARRAY_TASK_ID}/"
READ_1="_R1.fastq.gz"
READ_2="_R2.fastq.gz"

date
echo "========"
mkdir -p ./bbmap_reads/folder_${SLURM_ARRAY_TASK_ID}/

#runs bbmap on a set of paired reads

for file in $(realpath "${INPUT}/*${READ_1}"); do
        read1=$file
        read2=${read1%${READ_1}}${READ_2}
        out_read=${file##*/}

        if [ ! -f "./bbmap_reads/folder_${SLURM_ARRAY_TASK_ID}/${out_read%${READ_1}}.fastq" ]; then
            ${SCRIPT_DIR}/other_scripts/bbmap_pipeline.sh "$read1" "$read2" "./bbmap_reads/folder_${SLURM_ARRAY_TASK_ID}/${out_read%${READ_1}}.fastq"
        fi
done

echo "========"
date
