#!/bin/bash
# Junta a narração (fala01..08.wav) ao vídeo sem áudio. Uso: bash montar.sh <pasta_das_falas> <saida.mp4>
set -e; D="$1"; OUT="$2"; HERE="$(cd "$(dirname "$0")" && pwd)"
STARTS=(0.15 5.90 13.95 21.40 25.65 30.10 36.25 42.25)
IN=(); F=""; for i in 0 1 2 3 4 5 6 7; do n=$(printf %02d $((i+1))); IN+=(-i "$D/fala$n.wav"); ms=$(python3 -c "print(int(${STARTS[$i]}*1000))"); F+="[$((i+1)):a]aresample=48000,adelay=${ms}|${ms}[a$i];"; done
F+="[a0][a1][a2][a3][a4][a5][a6][a7]amix=inputs=8:normalize=0,apad,atrim=0:51.7,loudnorm=I=-14:TP=-1.5:LRA=11[aout]"
ffmpeg -y -i "$HERE/quiz-silent.mp4" "${IN[@]}" -filter_complex "$F" -map 0:v -map "[aout]" -c:v copy -c:a aac -b:a 192k -ar 48000 -ac 2 -shortest "$OUT"
