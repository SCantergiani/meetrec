#!/usr/bin/env bash
# Install meetrec: whisper-ctranslate2 (uv tool) + bin/* symlinked into ~/.local/bin
set -euo pipefail
for c in uv ffmpeg pactl; do
    command -v "$c" >/dev/null || { echo "missing dependency: $c" >&2; exit 1; }
done
gpu=()
command -v nvidia-smi >/dev/null && gpu=(--with nvidia-cublas-cu12 --with 'nvidia-cudnn-cu12==9.*')
uv tool install --force whisper-ctranslate2 "${gpu[@]}"
mkdir -p ~/.local/bin
ln -sf "$(cd "$(dirname "$0")" && pwd)"/bin/* ~/.local/bin/
echo "Installed: meetrec transcribe diarize meetmerge -> ~/.local/bin (make sure it's in PATH)"
