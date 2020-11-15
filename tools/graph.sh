#!/usr/bin/env bash

ffmpeg -i "$1" -filter_complex "showwavespic=s=1920x1080" -frames:v 1 output.png

