---
name: rem
description: Store a memory. REM sleep - extract and persist information to long-term memory.
user-invocable: true
---

# REM - Remember

Store information to the memory tree. Named after REM sleep when memory consolidation occurs.

## Usage

- `/rem` - **Summarize and store the current conversation** (no arguments)
- `/rem <content>` - Store with auto-categorization
- `/rem <category> <content>` - Store in specific category
- `/rem <category>/<subcategory> <content>` - Store in nested path

## Categories

| Category      | Use For                                              |
| ------------- | ---------------------------------------------------- |
| `projects`    | Project-specific context, state, decisions           |
| `decisions`   | Technical choices, architecture decisions, rationale |
| `patterns`    | Recurring solutions, approaches, templates           |
| `preferences` | User style, conventions, communication preferences   |
| `context`     | Domain knowledge, background info, relationships     |

## Instructions

When user runs `/rem`:

### 0. Check for Arguments

If no arguments provided (just `/rem` alone):

1. **Analyze the current conversation** - Review the entire discussion from the beginning
2. **Extract key information** - Identify:
   - Decisions made
   - Problems solved and how
   - Technical approaches discussed
   - Preferences expressed
   - Context established
   - Any actionable outcomes
3. **Generate a structured summary** with:
   - **Topic**: What the conversation was about (2-5 words)
   - **Summary**: Key points in 2-4 sentences
   - **Decisions**: Any choices made (if applicable)
   - **Outcomes**: What was achieved or concluded
   - **Follow-ups**: Any pending items or next steps
4. **Auto-categorize** based on conversation content (see step 2 below)
5. **Generate ID** from topic (see step 3 below)
6. **Store** using the standard memory file format with the summary as content

Example output for `/rem` with no arguments:

```
Analyzed conversation about debugging TikTok rate limiting.

Stored in patterns/rate-limiting: tiktok-retry-exponential-backoff

Summary captured:
- Implemented exponential backoff for 429 responses
- Set max retries to 5 with 2s base delay
- Added jitter to prevent thundering herd
```

If the conversation has no meaningful content to store, inform the user:

```
No substantive content to store from this conversation.
```

---

### 1. Parse Input (when arguments provided)

Extract category (if provided) and content:

- `/rem use terraform for all IaC` → auto-categorize, content = "use terraform for all IaC"
- `/rem decisions use terraform for all IaC` → category = "decisions"
- `/rem decisions/infrastructure use terraform` → path = "decisions/infrastructure"

### 2. Auto-Categorize (if no category given)

Analyze content and select best category:

- Technical choices, "decided", "chose", "prefer X over Y" → `decisions`
- Project names, "in project X", current working directory context → `projects`
- "Always", "never", "style", "format" → `preferences`
- Solutions, "how to", "approach for" → `patterns`
- Background info, explanations, domain terms → `context`

### 3. Generate Memory ID

From content:

- Extract key terms (2-4 words)
- Convert to kebab-case
- Max 50 characters
- Example: "use terraform for all IaC" → `terraform-for-iac`

### 4. Create Subcategory If Needed

If content relates to specific domain, create nested folder:

- Infrastructure decisions → `decisions/infrastructure/`
- AWS patterns → `patterns/aws/`
- Project "skillsdb" → `projects/skillsdb/`

### 5. Write Memory File

Path: `"${HOME}"/.dotfiles/claude/skills/memory/store/<category>/[<subcategory>/]<id>.md`

```markdown
---
id: <id>
created: <ISO timestamp>
source: manual | conversation
tags: [<extracted tags>]
---

# <Title from content>

<Full content>
```

Use `source: conversation` when storing from no-argument mode (conversation summary).
Use `source: manual` when storing explicit user-provided content.

### 6. Confirm

```
Stored in <category>/<subcategory>: <id>
```

## Examples

**Input:** `/rem decisions chose postgres over mysql for better json support`

**Output:**

```
Stored in decisions/databases: postgres-over-mysql
```

Creates: `memory/store/decisions/databases/postgres-over-mysql.md`

---

**Input:** `/rem the user prefers direct communication without analogies`

**Output:**

```
Stored in preferences: direct-communication-style
```

Creates: `memory/store/preferences/direct-communication-style.md`

---

**Input:** `/rem` (no arguments, after a conversation about fixing a CI pipeline)

**Output:**

```
Analyzed conversation about CI pipeline debugging.

Stored in patterns/ci-cd: github-actions-cache-invalidation

Summary captured:
- Identified cache key collision causing stale dependencies
- Fixed by adding hash of package-lock.json to cache key
- Added restore-keys fallback for partial cache hits

Follow-ups: Monitor cache hit rate over next week
```

Creates: `memory/store/patterns/ci-cd/github-actions-cache-invalidation.md`

## Background Mode - Automatic Extraction

For automatic memory extraction from conversations, deploy as background agent:

```
Use the Task tool with subagent_type "general-purpose" to:
1. Read the current conversation transcript
2. Detect memory signals (see below)
3. Extract and categorize memories
4. Store each with appropriate confidence
5. Report what was stored
```

### Memory Signal Detection

**Explicit Signals (Confidence: 0.9-1.0)**

- "I prefer...", "I always...", "I never..."
- "Remember that...", "Don't forget..."
- "My style is...", "I like to..."

**Correction Signals (Confidence: 0.85-0.95)**

- "No, do it this way..."
- "Actually, I meant..."
- "That's not right, use..."
- User immediately reverts Claude's output

**Implicit Signals (Confidence: 0.5-0.7)**

- User consistently modifies same output type
- Repeated clarifying questions
- Technical decisions with explained rationale

**Context Signals (Confidence: 0.3-0.5)**

- Project structure discussions
- Team/organization mentions
- Architecture decisions

### Confidence Scoring

| Signal Type         | Base Confidence |
| ------------------- | --------------- |
| Explicit statement  | 0.9-1.0         |
| Direct correction   | 0.85-0.95       |
| Repeated pattern    | 0.7-0.85        |
| Implicit preference | 0.5-0.7         |
| Context mention     | 0.3-0.5         |

### Deduplication

Before storing, check for similar existing memories:

1. Search by tags for potential matches
2. Compare titles (fuzzy match)
3. If similar exists: offer to update or skip

## Privacy

- Never extract passwords, tokens, or secrets
- Flag sensitive information for user review
- Default to lower confidence for anything potentially sensitive
