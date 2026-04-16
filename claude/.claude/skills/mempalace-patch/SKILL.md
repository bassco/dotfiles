# MemPalace Plugin Patch

Re-apply after any `opencode-mempalace` plugin update.

## Why

The plugin's `isInitialized()` passes `--palace <path>` to `mempalace status`, but the CLI does not accept that flag — it only reads `MEMPALACE_PALACE_PATH` from the environment. This causes a non-zero exit, `isInitialized` always returns `false`, and the `[SYSTEM — MemPalace Context Load]` banner appears every session.

## Patches

File: `~/.cache/opencode/packages/opencode-mempalace@latest/node_modules/opencode-mempalace/dist/index.js`

> **Important:** OpenCode loads the plugin from `~/.cache/opencode/packages/`, NOT `~/.config/opencode/node_modules/`. Always patch the cache path.

### Patch 1 — isInitialized: drop --palace flag (line ~340)

`mempalace status` does NOT accept `--palace`. It reads `MEMPALACE_PALACE_PATH` from the environment automatically.

Find:

```js
async function isInitialized(dir) {
  const palacePath = path3.join(dir, ".mempalace", "palace");
  const args = ["status", "--palace", palacePath];
```

Replace with:

```js
async function isInitialized(dir) {
  const args = ["status"];
```

### Patch 2 — Eager init at plugin load (line ~26795)

Find:

```js
    return "initializing";
  };
  const { flushDirtySessions } = createPluginDispose({
```

Replace with:

```js
    return "initializing";
  };
  ensureInitialized().catch(() => {});
  const { flushDirtySessions } = createPluginDispose({
```

## Verify

```bash
PLUGIN=~/.cache/opencode/packages/opencode-mempalace@latest/node_modules/opencode-mempalace/dist/index.js
grep -n "ensureInitialized().catch\|const args = \[.status.\]" "$PLUGIN"
```

Should show 2 lines: `const args = ["status"];` at ~341, `ensureInitialized().catch` at ~26796.

Also confirm the palace is healthy:

```bash
MEMPALACE_PALACE_PATH=~/.local/share/mempalace \
  python3 -m mempalace status; echo "exit: $?"
```

Should exit 0 with drawer counts.

## Other setup

- `~/.dotfiles/zsh/.zshenv-work` (symlinked as `~/.zshenv-local`, sourced for ALL shells including GUI-launched) sets:
  - `path=("$HOME/.local/bin" $path)` + `export PATH` — ensures `mempalace` binary is found by OpenCode
  - `export MEMPALACE_PALACE_PATH="$HOME/.local/share/mempalace"`
- `~/.config/opencode/opencode.jsonc` has `palacePath: "~/.local/share/mempalace"` (covers MCP subprocess)
- Palace initialized at `~/.local/share/mempalace` via `mempalace init --yes /Users/bashco/work/grafana-dashboards`
- `disableAutoUpdate: true` in opencode.jsonc prevents patch from being overwritten

## Delete drawers by wing (Python script)

Use this to bulk-delete all drawers in a wing — useful when re-mining or cleaning up wrong wing names.

```python
import chromadb, os

palace_path = os.path.expanduser("~/.local/share/mempalace")
client = chromadb.PersistentClient(path=palace_path)
col = client.get_collection("mempalace_drawers")

WING = "wing_grafana-dashboards"  # change to target wing name

result = col.get(where={"wing": WING}, include=[])
ids = result["ids"]
print(f"Total in {WING}: {len(ids)}")

batch_size = 500
for i in range(0, len(ids), batch_size):
    batch = ids[i:i+batch_size]
    col.delete(ids=batch)
    print(f"Deleted batch {i//batch_size + 1} ({len(batch)} docs)")

print("Done.")
```

Run it with the mempalace Python:

```bash
MEMPALACE_PALACE_PATH=~/.local/share/mempalace \
  /Users/bashco/.local/share/uv/tools/mempalace/bin/python3 delete_wing.py
```

To inspect wing counts first:

```python
import chromadb, os
client = chromadb.PersistentClient(path=os.path.expanduser("~/.local/share/mempalace"))
col = client.get_collection("mempalace_drawers")
result = col.get(include=["metadatas"])
wings = {}
for m in result["metadatas"]:
    w = m.get("wing", "unknown")
    wings[w] = wings.get(w, 0) + 1
for wing, count in sorted(wings.items()):
    print(f"  {wing}: {count}")
```

## Key gotcha

`isInitialized` tries `mempalace`, `python3`, `python` in order. In the grafana-dashboards workspace, `python3` resolves to `.venv/bin/python3` which doesn't have mempalace installed. So the `mempalace` binary must be on PATH — which requires `~/.local/bin` in PATH at GUI-launch level (i.e. `~/.zshenv-local`, NOT `~/.zshrc-local` which only applies to interactive shells).
