---
id: opencode-config-changes
created: 2026-03-13T00:00:00Z
source: manual
tags: [opencode, config, permissions]
---

# OpenCode Global Config Changes

Changes made to `~/.config/opencode/opencode.json`:

- Added `external_directory` permissions:
  - `~/.local/share/opencode/tool-output/**`: `allow`
  - `~/.config/opencode/**`: `allow`
- Added `read` permissions:
  - `~/.local/share/opencode/tool-output/*`: `allow`
  - `~/.config/opencode/*`: `allow`
- Added `edit` and `write` permissions:
  - `~/.config/opencode/*`: `allow`
- Pending: change `grep *` to `rg *` in `bash` permissions (not yet applied — was in plan mode when requested)
