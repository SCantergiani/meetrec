# meetrec

Record a call on Linux, transcribe it locally, and label who said what.

```
[00:00:13] Them A: No, por ahora no.
[00:00:15] Me: dos meses
[00:00:18] Them B: Bueno, a ver, la entrevista va...
```

- **Me / Them**: mic and system audio are recorded as separate tracks, so your lines are always exact.
- **Them A / B / ...**: remote voices split by speaker diarization
  ([sherpa-onnx](https://github.com/k2-fsa/sherpa-onnx): pyannote segmentation 3.0 + 3D-Speaker ERes2Net embeddings, CPU, no HuggingFace token).
- **Transcription**: [whisper-ctranslate2](https://github.com/Softcatala/whisper-ctranslate2) (faster-whisper), `large-v3` by default. NVIDIA GPU if present, else CPU.

Everything runs locally. Models download on first use to `~/.cache/huggingface` and `~/.cache/sherpa-onnx`.

## Install

Needs Linux with PipeWire or PulseAudio, plus `uv`, `ffmpeg`, `pactl` (Arch: `pacman -S uv ffmpeg libpulse`; Debian/Ubuntu: `apt install ffmpeg pulseaudio-utils` + [uv](https://docs.astral.sh/uv/)).
For GPU: just the NVIDIA driver. CUDA libs are installed as Python wheels, so no system CUDA is needed.

```sh
git clone https://github.com/SCantergiani/meetrec ~/Projects/meetrec
~/Projects/meetrec/install.sh
```

Scripts are symlinked into `~/.local/bin`, so `git pull` updates them.

## Use

```sh
meetrec                  # record → press q to stop → ~/Recordings/meeting-DATE.txt
meetrec "" 3             # 3 people on the other side (more reliable than auto-detect)
meetrec large-v3-turbo   # faster model
```

Individual steps:

```sh
transcribe file.ogg [model]                 # .txt/.srt/.vtt/.tsv/.json next to the file
diarize file.ogg file.tsv [num_speakers]    # adds a speaker column to the .tsv
meetmerge ~/Recordings/meeting-DATE         # BASE-me.tsv + BASE-them.tsv → BASE.txt
```

Recordings go to `~/Recordings`; override with `MEETREC_DIR`.

## Limits

- Auto speaker count was tuned on one 40-min call. It can merge voices on short recordings. Pass the count when you know it.
- Labels are letters, not names.
