#!/usr/bin/env sh
if ! command -v "espeak-ng" >/dev/null 2>&1 || ! command -v "ffmpeg" >/dev/null 2>&1; then
    echo "This script requires the commands 'espeak-ng' and 'ffmpeg'"
fi

DIR="./layers"
mkdir -p "${DIR}"
while IFS= read -r line; do
    layer="$(echo "${line}" | cut -d";" -f1)"
    text="$(echo "${line}" | cut -d";" -f2)"
    echo "${layer} - ${text}"
    file="${DIR}/layer-${layer}"
    # speed, pitch, capital pitch, word gap
    espeak-ng -v en-us+whisper \
        -s 115 -p 40 -k 1 -g 8 \
        "${text}" -w "${file}.wav"
    ffmpeg -nostdin -loglevel quiet -y -i "${file}.wav" "${file}.mp3"
    rm "${file}.wav"
done < layers.txt
