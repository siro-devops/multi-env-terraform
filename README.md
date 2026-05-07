# Multi-Environment Terraform with Remote State

Production-grade AWS infrastructure managed across three isolated environments
using a shared Terraform module and S3 remote state. This is how real teams
manage infrastructure — not one big flat config, but composable modules
deployed consistently across dev, staging, and prod.

## What was built

| Environment | VPC CIDR | State file |
|---|---|---|
| dev | 10.0.0.0/16 | s3://siro-devops-terraform-state/dev/terraform.tfstate |
| staging | 10.1.0.0/16 | s3://siro-devops-terraform-state/staging/terraform.tfstate |
| prod | 10.2.0.0/16 | s3://siro-devops-terraform-state/prod/terraform.tfstate |

Each environment has its own isolated VPC, public subnet, private subnet,
and internet gateway — deployed from the same shared module.

## Project structure
multi-env-terraform/
├── modules/
│   └── vpc/
│       ├── main.tf        # VPC, subnets, internet gateway
│       ├── variables.tf   # Input variables
│       └── outputs.tf     # VPC ID, subnet IDs
├── envs/
│   ├── dev/main.tf        # Dev environment config
│   ├── staging/main.tf    # Staging environment config
│   └── prod/main.tf       # Prod environment config
└── .gitignore             # Excludes state files and provider cache
## Key concepts demonstrated

**Shared modules** — one VPC module used by all three environments.
Changes to the module propagate to every environment on next apply.

**Remote state** — state stored in S3 with versioning enabled.
Safe for team use — no local state files, no conflicts.

**Environment isolation** — each environment has its own CIDR range
and its own state file. Dev changes never touch prod.

**No hardcoded values** — everything parameterised through variables.
A new environment is one new main.tf file.

## How to deploy an environment

```bash
cd envs/dev
terraform init
terraform apply -auto-approve
```

## Evidence

![S3 Remote State](screenshotss3-state-files.png)

## Stack

Terraform, AWS VPC, AWS S3, AWS EC2, IAM

## What I would add next

- DynamoDB table for state locking (prevents concurrent applies)
- GitHub Actions pipeline to run terraform plan on PR and apply on merge
- Terragrunt for DRY environment configs
- Separate AWS accounts per environment (true isolation)
- Cost estimation with Infracost on every pull request
