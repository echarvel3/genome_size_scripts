
INPUT_DIR="./decontam_jellyfish/"
OUTPUT_DIR="./full_cov_respect/"

mkdir ${OUTPUT_DIR}

#Readys histogram files for inital RESPECT coverage estimate run.

echo -e "Input\tread_length" > ${OUTPUT_DIR}/hist_info.txt
find "${INPUT_DIR}" -name 'read_lengths.txt' | xargs -I {} cat {} >> ${OUTPUT_DIR}/hist_info.txt

find "${INPUT_DIR}" -name *'.hist' | xargs -I {} realpath {} | xargs -I {} ln -s {} ${OUTPUT_DIR}


