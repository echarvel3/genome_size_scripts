
INPUT_DIR="./downsampled_jellyfish/"
OUTPUT_DIR="./downsampled_respect/"

mkdir ${OUTPUT_DIR}

echo -e "Input\tread_length" > ${OUTPUT_DIR}/hist_info.txt
find "${INPUT_DIR}" -name 'read_lengths.txt' | xargs -I {} cat {} >> ${OUTPUT_DIR}/hist_info.txt

find "${INPUT_DIR}" -name *'.hist' | xargs -I {} realpath {} | xargs -I {} ln -s {} ${OUTPUT_DIR}


