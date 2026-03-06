#!/bin/bash

# STT Comparison Test Script
# Tests Vosk, Faster-Whisper, WhisperX, and whisper.cpp with the same audio file

export PATH="/Users/mattabar/Library/Python/3.9/bin:$PATH"

echo "🎤 STT Comparison Test"
echo "====================="
echo ""

# Check for test audio file
if [ ! -f "$1" ]; then
  echo "Usage: $0 <audio-file.wav>"
  echo ""
  echo "Example:"
  echo "  # Record 5 seconds of audio:"
  echo "  sox -d test.wav trim 0 5"
  echo "  # Then run comparison:"
  echo "  ./test-stt-comparison.sh test.wav"
  exit 1
fi

AUDIO_FILE="$1"
echo "Testing with: $AUDIO_FILE"
echo ""

# Test 1: Vosk
echo "1️⃣  Testing Vosk (real-time optimized)..."
START=$(date +%s%3N)
vosk-transcriber -m ~/.vosk/models/vosk-model-small-en-us-0.15 -i "$AUDIO_FILE" > /tmp/vosk-output.txt 2>&1
END=$(date +%s%3N)
VOSK_TIME=$((END - START))
echo "   ⏱️  Latency: ${VOSK_TIME}ms"
echo "   📝 Result: $(cat /tmp/vosk-output.txt | head -3)"
echo ""

# Test 2: Faster-Whisper
echo "2️⃣  Testing Faster-Whisper (balanced)..."
START=$(date +%s%3N)
python3 -c "
from faster_whisper import WhisperModel
model = WhisperModel('base.en', device='cpu', compute_type='int8')
segments, info = model.transcribe('$AUDIO_FILE')
for segment in segments:
    print(segment.text, end='')
" > /tmp/faster-whisper-output.txt 2>&1
END=$(date +%s%3N)
FASTER_TIME=$((END - START))
echo "   ⏱️  Latency: ${FASTER_TIME}ms"
echo "   📝 Result: $(cat /tmp/faster-whisper-output.txt)"
echo ""

# Test 3: whisper.cpp
echo "3️⃣  Testing whisper.cpp (C++ lightweight)..."
# Download model if needed
if [ ! -f ~/.whisper-cpp/ggml-base.en.bin ]; then
  mkdir -p ~/.whisper-cpp
  curl -L https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin -o ~/.whisper-cpp/ggml-base.en.bin 2>&1 | tail -1
fi
START=$(date +%s%3N)
whisper-cpp -m ~/.whisper-cpp/ggml-base.en.bin -f "$AUDIO_FILE" --no-timestamps 2>&1 | grep -v "^whisper_" > /tmp/whisper-cpp-output.txt
END=$(date +%s%3N)
CPP_TIME=$((END - START))
echo "   ⏱️  Latency: ${CPP_TIME}ms"
echo "   📝 Result: $(cat /tmp/whisper-cpp-output.txt | head -3)"
echo ""

# Test 4: WhisperX (if you have GPU or want to test on CPU)
echo "4️⃣  Testing WhisperX (accuracy champion, batch-optimized)..."
echo "   ⚠️  Skipping - requires GPU for reasonable performance"
echo "   (Would take 30+ seconds on CPU for a short clip)"
echo ""

# Summary
echo "📊 Summary:"
echo "   Vosk:           ${VOSK_TIME}ms"
echo "   Faster-Whisper: ${FASTER_TIME}ms"
echo "   whisper.cpp:    ${CPP_TIME}ms"
echo ""
echo "💡 For voice commands, Vosk should be fastest!"
