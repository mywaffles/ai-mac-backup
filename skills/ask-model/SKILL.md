---
name: ask-model
description: Query a specific AI model for its opinion/answer. Use when the user wants to compare different models' responses or ask "What does Gemini think?" or "Ask Claude Opus about this." Supports all configured models in OpenClaw.
---

# Ask Model

Get a response from a specific AI model to compare perspectives or leverage model-specific strengths.

## Quick Usage

**Ask Gemini:**
```bash
openclaw sessions spawn --runtime subagent \
  --task "What do you think about: <question>?" \
  --model "openrouter/google/gemini-3-pro" \
  --mode run \
  --announce
```

**Ask Claude Opus:**
```bash
openclaw sessions spawn --runtime subagent \
  --task "<question>" \
  --model "openrouter/anthropic/claude-opus-4.6" \
  --mode run \
  --announce
```

**Ask DeepSeek:**
```bash
openclaw sessions spawn --runtime subagent \
  --task "<question>" \
  --model "openrouter/deepseek/deepseek-chat" \
  --mode run \
  --announce
```

## Available Models

Check configured models:
```bash
openclaw config get agents.defaults.models | jq 'keys'
```

Current models:
- `openrouter/anthropic/claude-sonnet-4.5` (default)
- `openrouter/anthropic/claude-opus-4.6`
- `openrouter/google/gemini-3-pro`
- `openrouter/google/gemini-2.5-flash-preview`
- `openrouter/deepseek/deepseek-chat`
- `openrouter/openrouter/auto`

## Workflow Patterns

**Compare responses:**
1. User asks "What does Gemini think about sailboat charters?"
2. Spawn Gemini session with the question
3. Wait for response (auto-announces to chat)
4. Compare with your (Sonnet's) answer

**Get second opinion:**
1. User: "Ask Opus if my Greece budget is realistic"
2. Spawn Opus session with budget details
3. Present both perspectives

**Model-specific strengths:**
- **Gemini:** Math, technical analysis, structured data
- **Claude Opus:** Creative writing, complex reasoning, nuance
- **DeepSeek:** Code generation, technical docs
- **Sonnet (you):** Balanced, fast, conversational

## Advanced: Comparison Loop

For systematic comparison:

```bash
for model in "gemini-3-pro" "claude-opus-4.6" "deepseek-chat"; do
  echo "=== $model ==="
  openclaw sessions spawn --runtime subagent \
    --task "Answer in 2-3 sentences: <question>" \
    --model "openrouter/$model" \
    --mode run
done
```

## Notes

- Responses announce to the current channel (Telegram, WebChat, etc.)
- Each spawn is isolated (no shared context)
- Costs apply per model (check OpenRouter pricing)
- Use `--mode run` for one-shot, `--mode session` for persistent chat
