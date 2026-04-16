---
name: ansible
description: Best practices for writing Ansible playbooks, roles, inventory management, and automation workflows
license: MIT
compatibility: opencode
---

## What I do

- Write idiomatic YAML playbooks, tasks, and handlers
- Structure Ansible roles following Galaxy conventions (`tasks/`, `handlers/`, `defaults/`, `vars/`, `templates/`, `files/`, `meta/`)
- Manage inventory files, `group_vars/`, and `host_vars/`
- Use `ansible-vault` for encrypting secrets
- Write Jinja2 templates for config file generation
- Advise on connection types (SSH, WinRM, local)
- Use `tags`, `when` conditionals, `loops`, and `blocks` correctly
- Optimize playbooks with `gather_facts`, `async`, and `delegate_to`
- Write and run `molecule` tests for roles
- Advise on AWX/Ansible Tower/AAP integration

## When to use me

Use when working on Ansible playbooks (`.yml`/`.yaml`), roles, inventory files, `ansible.cfg`, or any Ansible automation tasks.

## Key conventions

- Always use FQCN (Fully Qualified Collection Names) for modules, e.g. `ansible.builtin.copy`
- Prefer `ansible-lint` compliance — avoid deprecated syntax
- Use `defaults/main.yml` for overridable variables, `vars/main.yml` for fixed ones
- Avoid `shell` and `command` modules when an idempotent module exists
- Use `notify` + handlers for service restarts instead of direct tasks
- Pin collection versions in `requirements.yml`
- Never store plaintext secrets — use `ansible-vault` or a secrets manager

## Documentation Resources

- Ansible Documentation: <https://docs.ansible.com/>

## Project-Specific Documentation

The `ansible/usage/` folder in the working project contains reference docs for this codebase. Always read these before working on a playbook:

- `ansible/usage/server-backend-playbook.md` — full import chain, tag reference, key variables, and common invocations for `server-backend.yml`
