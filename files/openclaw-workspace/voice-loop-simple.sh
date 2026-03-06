#!/bin/bash

# Simple Voice Loop - Records, transcribes, shows you what was said
# You respond normally, I'll speak your message

export PATH="/Users/mattabar/Library/Python/3.9/bin:$PATH"
VOSK_MODEL="/Users/mattabar/.vosk/models/vosk-model-small-en-us-0.15"

clear
echo "🚗 Gay Deceiver - Voice Mode"
echo "============================"
echo ""
echo "🎤 Listening on: Anker PowerConf"
echo "🔊 Speaking through: System audio → Anker"
echo ""
echo "Say 'stop listening' or press Ctrl+C to exit"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

while true; do
  # Visual cue
  echo -n "🎤 [Recording]... "
  
  # Record 5 seconds with silence detection
  rec -q -r 16000 -c 1 -e signed-integer -b 16 /tmp/voice-input.wav \
    silence 1 0.1 1% 1 1.5 3% \
    trim 0 7 2>/dev/null
  
  echo "✓"
  
  # Transcribe
  TRANSCRIPTION=$(python3 -W ignore << 'PYTHON'
from vosk import Model, KaldiRecognizer
import wave, json, sys

try:
    model = Model("/Users/mattabar/.vosk/models/vosk-model-small-en-us-0.15")
    wf = wave.open("/tmp/voice-input.wav", "rb")
    rec = KaldiRecognizer(model, wf.getframerate())
    
    text = ""
    while True:
        data = wf.readframes(4000)
        if not data: break
        if rec.AcceptWaveform(data):
            text += json.loads(rec.Result()).get("text", "") + " "
    text += json.loads(rec.FinalResult()).get("text", "")
    print(text.strip())
except: pass
PYTHON
)
  
  # Skip empty
  if [ -z "$TRANSCRIPTION" ]; then
    echo "   (no speech detected)"
    echo ""
    continue
  fi
  
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🗣️  Matt: $TRANSCRIPTION"
  
  # Exit commands
  if [[ "$TRANSCRIPTION" == *"stop listening"* ]] || [[ "$TRANSCRIPTION" == *"goodbye"* ]]; then
    echo "🚗 Goodbye!"
    say "Goodbye Matt. Talk to you later."
    exit 0
  fi
  
  # For now, just acknowledge - you'd send this to OpenClaw properly
  echo "🚗 (Send this to OpenClaw chat to get my real response)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
done
