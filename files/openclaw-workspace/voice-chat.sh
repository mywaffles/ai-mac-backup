#!/bin/bash

# Voice Chat Loop with Vosk + OpenClaw
# Continuous voice conversation without typing

export PATH="/Users/mattabar/Library/Python/3.9/bin:$PATH"
VOSK_MODEL="/Users/mattabar/.vosk/models/vosk-model-small-en-us-0.15"

echo "🚗 Gay Deceiver Voice Chat"
echo "=========================="
echo "Using: Anker PowerConf speakerphone"
echo "Press Ctrl+C to exit"
echo ""
echo "Speak now! I'm listening..."
echo ""

while true; do
  # Record 5 seconds of audio
  rec -r 16000 -c 1 -e signed-integer -b 16 /tmp/voice-input.wav trim 0 5 silence 1 0.1 1% 1 1.0 1% 2>/dev/null
  
  # Transcribe with Vosk
  TRANSCRIPTION=$(python3 << EOF
from vosk import Model, KaldiRecognizer
import wave
import json
import sys

try:
    model = Model("$VOSK_MODEL")
    wf = wave.open("/tmp/voice-input.wav", "rb")
    rec = KaldiRecognizer(model, wf.getframerate())
    
    result_text = ""
    while True:
        data = wf.readframes(4000)
        if len(data) == 0:
            break
        if rec.AcceptWaveform(data):
            result = json.loads(rec.Result())
            result_text += result.get("text", "") + " "
    
    final = json.loads(rec.FinalResult())
    result_text += final.get("text", "")
    print(result_text.strip())
except Exception as e:
    print("", file=sys.stderr)
EOF
)
  
  # Skip if no speech detected
  if [ -z "$TRANSCRIPTION" ]; then
    continue
  fi
  
  echo "🎤 You: $TRANSCRIPTION"
  
  # Exit commands
  if [[ "$TRANSCRIPTION" == *"goodbye"* ]] || [[ "$TRANSCRIPTION" == *"stop listening"* ]]; then
    echo "🚗 Goodbye!"
    say "Goodbye Matt!"
    exit 0
  fi
  
  # Send to OpenClaw via curl to local API (simpler than message tool)
  # For now, just echo - you'd integrate with OpenClaw gateway API here
  echo "🚗 Gay: (Processing via OpenClaw...)"
  
  # TODO: Replace this with actual OpenClaw API call
  # For now, using macOS say as placeholder
  RESPONSE="I heard you say: $TRANSCRIPTION"
  echo "   $RESPONSE"
  say "$RESPONSE"
  
  echo ""
done
