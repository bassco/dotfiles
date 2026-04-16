---
id: configuration-aliases-validate-workaround
created: 2026-03-14T00:00:00Z
source: conversation
tags: [terraform, pre-commit, validation, configuration_aliases, terraform-config-inspect, mise]
---

# Terraform configuration_aliases — standalone validate workaround

## Problem

`terraform validate` cannot run standalone on modules that declare `configuration_aliases`
in `required_providers`. This is a known upstream Terraform bug (hashicorp/terraform#28490)
present since Terraform 0.15. No native Terraform flag bypasses it.

Error seen:
```
Error: Provider configuration not present
To work with <resource> its original provider configuration at
provider["registry.terraform.io/hashicorp/aws"].<alias> is required, but it has been removed.
```

## Workaround: runtime aliased-providers.tf.json generation

Use `terraform-config-inspect` + `jq` to generate an `aliased-providers.tf.json` file
before `terraform validate` runs, then clean it up after. The file is gitignored.

### Setup

**1. Install `terraform-config-inspect` via mise (`mise.toml`)**:

```toml
"go:github.com/hashicorp/terraform-config-inspect" = "latest"
```

**2. `.generate-providers.sh`** (executable, repo root):

```bash
#!/usr/bin/env bash
set -euo pipefail

DIRS=("." "submodules/waf")  # list all dirs with configuration_aliases

for dir in "${DIRS[@]}"; do
  out=$(terraform-config-inspect --json "$dir" | jq -r '
    [.required_providers[].aliases]
    | flatten
    | del(.[] | select(. == null))
    | if length == 0 then empty else
      reduce .[] as $entry (
        {};
        .provider[$entry.name] //= [] | .provider[$entry.name] += [{"alias": $entry.alias}]
      )
    end
  ')
  if [[ -n "$out" ]]; then
    echo "$out" > "$dir/aliased-providers.tf.json"
  fi
done
```

**3. `.pre-commit-config.yaml`** — add local hooks around `terraform_validate`:

```yaml
repos:
  - repo: local
    hooks:
      - id: generate-terraform-providers
        name: generate-terraform-providers
        entry: .generate-providers.sh
        language: script
        files: \.tf(vars)?$
        pass_filenames: false
        require_serial: true

  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.96.1
    hooks:
      - id: terraform_validate
        # No exclude: needed — aliased-providers.tf.json satisfies the aliases at runtime

  - repo: local
    hooks:
      - id: cleanup-terraform-providers
        name: cleanup-terraform-providers
        entry: bash -c 'rm -f ./aliased-providers.tf.json submodules/waf/aliased-providers.tf.json'
        language: system
        always_run: true
        pass_filenames: false
```

**4. `.gitignore`**:

```
aliased-providers.tf.json
```

### Why not the other workarounds

- **`exclude:` regex** — simple but gives zero validate coverage on excluded modules
- **`examples/` caller directory** — requires maintaining all required variables with values
- **Mock providers / `--var-file`** — `terraform validate` does not accept these flags; not applicable

### Source

pre-commit-terraform PR #332 (merged Feb 2022): https://github.com/antonbabenko/pre-commit-terraform/pull/332/files
