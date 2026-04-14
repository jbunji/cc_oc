# Model Switching Guide

This guide outlines how to switch the main agent's model between OpenRouter Anthropic (for conversation) and Google Gemini Flash (for coding/speed).

**Important:** After running any `openclaw models set` command, always run `openclaw gateway restart` for the changes to take full effect.

## 1. Switch to OpenRouter Anthropic (for conversation/deep reasoning)

This is the preferred model for general conversation, complex reasoning, and nuanced interactions.

```bash
openclaw models set openrouter/anthropic/claude-sonnet-4-6
openclaw gateway restart
```

## 2. Switch to Google Gemini Flash 2.5 (for coding/fast execution)

This model is faster and ideal for coding tasks, quick edits, and when sub-agents are already on Gemini.

```bash
openclaw models set google/gemini-2.5-flash
openclaw gateway restart
```

## 3. Verify Current Model

To check which model the main agent is currently using, run:

```bash
openclaw session_status
```

This will show the `🧠 Model` line for the active session.
