---
name: terraform
description: Best practices for writing and planning Terraform infrastructure code including modules, state, and provider configuration
license: MIT
compatibility: opencode
---

## What I do

- Write idiomatic HCL using modules, locals, variables, and outputs
- Structure Terraform projects with reusable modules and workspaces
- Configure remote state backends (S3, GCS, Terraform Cloud, etc.)
- Pin provider and module versions appropriately
- Never run `terraform apply`
- Identify and resolve state drift, import existing resources
- Never use `terraform.tfvars`, only use variable or local definitions
- Follow naming conventions and tagging strategies for cloud resources

## When to use me

Use when working on `.tf`, or `.hcl` files, Terraform modules, or infrastructure-as-code tasks involving Terraform.

## Key conventions

- Always use `required_providers` blocks with version constraints
- Prefer `for_each` over `count` for resource iteration
- Use `locals` to avoid repeating expressions
- Keep root modules thin; push logic into child modules
- Never hardcode credentials — use environment variables or secret managers
- Use `terraform init` to initialise
- Use `terraform plan -out=plan.out` when planning
- Run `terraform fmt` and `terraform validate` before committing

## Documentation Resources

- Terraform Documentation: <https://www.terraform.io/docs>
- Terraform AWS Provider: <https://registry.terraform.io/providers/hashicorp/aws/latest/docs>
- Terraform Azure RM Provider: <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs>
- Terraform Azure AD Provider: <https://registry.terraform.io/providers/hashicorp/azuread/latest/docs>
