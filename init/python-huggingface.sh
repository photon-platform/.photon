#!/usr/bin/env bash

title "Huggingface"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

echo
sub "Pytorch"
echo
pip install -U torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

echo
sub "TensorFlow"
echo
pip install -U tensorflow[and-cuda]
# Verify the installation:
python3 -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"


echo
sub "Flax"
echo
pip install -U flax

echo
sub "transformers"
echo
pip install -U transformers


sub "Huggingface settings complete"
elapsed_time $SECTION_TIME | tee -a $LOG

