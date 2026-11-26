#!/bin/bash
# uso: bash montar.sh <pasta_falas> <saida.mp4>   (precisa de ffmpeg no PATH)
set -e; F="$1"; OUT="$2"; DIR="$(cd "$(dirname "$0")" && pwd)"
OFF=(100 5250 10640 16830 23660 30730 38760 44790 53780 64370)
IN=(-i "$DIR/login-raio-x_sem-audio.mp4"); FC=""; MIX=""
for i in $(seq 1 10); do n=$(printf %02d $i); IN+=(-i "$F/fala$n.wav"); o=${OFF[$((i-1))]}; FC+="[$i:a]aresample=48000,adelay=${o}|${o}[a$i];"; MIX+="[a$i]"; done
FC+="${MIX}amix=inputs=10:normalize=0,loudnorm=I=-14:TP=-1.5:LRA=11[aout]"
ffmpeg -y "${IN[@]}" -filter_complex "$FC" -map 0:v -map "[aout]" -c:v copy -c:a aac -b:a 192k -ar 48000 "$OUT"
