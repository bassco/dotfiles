---
name: github-actions
description: Write GitHub Actions workflows for private repositories with protections against forked repo execution and secret exfiltration
license: MIT
compatibility: opencode
---

## What I do

- Write GitHub Actions workflows (`.github/workflows/*.yml`) for private repositories
- Add fork protection guards to prevent workflows from running in forked repos
- Protect secrets from being exposed in pull requests originating from forks
- Configure permissions with least-privilege `GITHUB_TOKEN` scopes
- Structure reusable workflows, composite actions, and workflow_call patterns
- Set up environment protection rules and deployment gates
- Advise on self-hosted runner security in private repo contexts

## When to use me

Use when writing or reviewing GitHub Actions workflows, especially those that handle secrets, deployments, or sensitive infrastructure in private repositories.

---

## Fork protection

Always guard jobs that access secrets or perform privileged operations. Forks do not receive secrets by default, but pull_request_target and workflow_run triggers run in the base repo context and DO have access to secrets — these are the dangerous triggers.

### Block execution in forks entirely

Add this condition to every job (or the top-level `if` on each job):

```yaml
jobs:
  build:
    if: github.repository == 'your-org/your-repo'
    runs-on: ubuntu-latest
```

Or check that it is not a fork:

```yaml
jobs:
  deploy:
    if: github.event.repository.fork == false
    runs-on: ubuntu-latest
```

### Never use `pull_request_target` with checkout of the PR branch

This is the most common secret-exfiltration vector. Never do this:

```yaml
# DANGEROUS — do not do this
on: pull_request_target
jobs:
  test:
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.event.pull_request.head.sha }} # checks out untrusted code with repo secrets
```

If you must use `pull_request_target`, never check out PR code in that job. Split into two workflows: one that runs untrusted code with no secrets (on: pull_request), and one that runs trusted code with secrets (on: workflow_run, with a completion check).

### Safe pull_request_target pattern (label-gated)

Only allow privileged actions after a maintainer has applied a trusted label:

```yaml
on:
  pull_request_target:
    types: [labeled]

jobs:
  deploy-preview:
    if: |
      github.event.label.name == 'safe-to-deploy' &&
      github.event.repository.fork == false ||
      github.event.pull_request.head.repo.full_name == github.repository
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.event.pull_request.head.sha }}
```

---

## Least-privilege GITHUB_TOKEN

Always explicitly declare the minimum permissions needed. Default permissions vary by org settings — be explicit:

```yaml
permissions:
  contents: read # default: read the repo
  pull-requests: write # only if you need to comment on PRs
  id-token: write # only if using OIDC for cloud auth
  packages: write # only if publishing to GHCR
```

Set `permissions: {}` (no permissions) at the top level and grant only what each job needs:

```yaml
permissions: {} # deny all by default at workflow level

jobs:
  test:
    permissions:
      contents: read
    runs-on: ubuntu-latest

  publish:
    permissions:
      contents: read
      packages: write
    runs-on: ubuntu-latest
```

---

## Secrets handling

- Never echo or print secrets: `echo ${{ secrets.MY_SECRET }}` leaks to logs
- Pass secrets as environment variables, not inline args:

```yaml
# Good
env:
  API_KEY: ${{ secrets.API_KEY }}
run: ./deploy.sh

# Bad — visible in process list and logs
run: ./deploy.sh --key ${{ secrets.API_KEY }}
```

- Use environment-scoped secrets for deployment workflows; require a reviewer:

```yaml
jobs:
  deploy:
    environment: production # triggers required reviewers gate
    runs-on: ubuntu-latest
```

- Prefer OIDC over long-lived credentials for AWS, GCP, Azure:

```yaml
permissions:
  id-token: write
  contents: read

steps:
  - uses: aws-actions/configure-aws-credentials@v4
    with:
      role-to-assume: arn:aws:iam::123456789012:role/my-github-role
      aws-region: us-east-1
```

---

## Pin actions to a full commit SHA

Pinning by tag (e.g. `@v4`) is vulnerable to tag mutation. Pin to a commit SHA for security-critical workflows:

```yaml
# Preferred for sensitive workflows
- uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2

# Acceptable for low-risk steps
- uses: actions/checkout@v4
```

---

## Concurrency control

Cancel in-progress runs to prevent race conditions on deployments:

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

For production deployments, do not cancel in progress — queue instead:

```yaml
concurrency:
  group: deploy-production
  cancel-in-progress: false
```

---

## Key conventions

- Always set `if: github.repository == 'org/repo'` on jobs with secrets or deployments
- Never use `pull_request_target` + untrusted code checkout in the same job
- Declare `permissions` explicitly at workflow and job level
- Pass secrets via `env:`, not inline `${{ secrets.X }}` in `run:` commands
- Use OIDC for cloud provider auth instead of long-lived static credentials
- Pin third-party actions to a commit SHA in security-sensitive workflows
- Gate production deployments behind a named `environment` with required reviewers

## Documentation Resources

- GitHub Actions Documentation: <https://docs.github.com/en/actions>
