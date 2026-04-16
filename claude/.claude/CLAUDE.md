# Global CLAUDE.md

## Memory

- Use mempalace plugin for memories.
- note: is a prefix I use for when I want you to use mempalace mcp to store a memory

## Git Commit Messages

- Keep commit messages short and concise — one line only (max 72 chars)
- Use the Conventional Commits format: `type(scope): short description`
- Do NOT include a body or bullet-point explanations unless explicitly asked
- Avoid filler phrases like "This commit..." or "Updated X to do Y because Z"

## Beads Task Tracking

<!-- Ticket tracking -->

At the start of every conversation and at the beginning of each new session, run ALL of the following `bd` commands in parallel using Bash:

```bash
bd prime
bd ready
bd memories
bd stats
```

Then continue with normal beads workflow:

- Check beads for existing tasks/context before starting work
- Use beads to track task progress throughout the session
- Update task status as work progresses: claim when starting, ready when done, close when verified

<!-- Coding discipline -->

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## Session Startup

When you receive startup beads context at the beginning of a session, respond with exactly one line:
"Ready. X tasks available, top priority: <title> (<key>)."
