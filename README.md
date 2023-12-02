# <img align="left" width="45" height="45" src="https://github.com/osinfra-io/backstage/assets/1610100/9a2afb97-282d-4050-83c5-2e41925e4dc6"> Backstage

**[GitHub Actions](https://github.com/osinfra-io/backstage/actions):**

[![Dependabot](https://github.com/osinfra-io/backstage/actions/workflows/dependabot.yml/badge.svg)](https://github.com/osinfra-io/backstage/actions/workflows/dependabot.yml)

**[Infracost](https://www.infracost.io):**

[![infracost](https://img.shields.io/endpoint?url=https://dashboard.api.infracost.io/shields/json/cbeecfe3-576f-4553-984c-e451a575ee47/repos/9f16fb7d-e831-4162-8295-652c0e8342d0/branch/4ea7eb55-1fcf-4d2f-b66b-ce4ba78ff328)](https://dashboard.infracost.io/org/osinfra-io/repos/9f16fb7d-e831-4162-8295-652c0e8342d0?tab=settings)

## Repository Description

This repository manages the infrastructure for the [Backstage](https://backstage.io) platform.

## 🏭 Platform Information

- Documentation: [docs.osinfra.io](https://docs.osinfra.io/product-guides/backstage)
- Service Interfaces: [github.com](https://github.com/osinfra-io/backstage/issues/new/choose)

## <img align="left" width="35" height="35" src="https://github.com/osinfra-io/github-organization-management/assets/1610100/39d6ae3b-ccc2-42db-92f1-276a5bc54e65"> Development

Our focus is on the core fundamental practice of platform engineering, Infrastructure as Code.

>Open Source Infrastructure (as Code) is a development model for infrastructure that focuses on open collaboration and applying relative lessons learned from software development practices that organizations can use internally at scale. - [Open Source Infrastructure (as Code)](https://www.osinfra.io)

To avoid slowing down stream-aligned teams, we want to open up the possibility for contributions. The Open Source Infrastructure (as Code) model allows team members external to the platform team to contribute with only a slight increase in cognitive load. This section is for developers who want to contribute to this repository, describing the tools used, the skills, and the knowledge required, along with Terraform documentation.

See the documentation for setting up a local development environment [here](https://docs.osinfra.io/fundamentals/development-setup).

### 🛠️ Tools

- [infracost](https://github.com/infracost/infracost)
- [pre-commit](https://github.com/pre-commit/pre-commit)
- [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform)
- [terraform-docs](https://github.com/terraform-docs/terraform-docs)

### 📋 Skills and Knowledge

Links to documentation and other resources required to develop and iterate in this repository successfully.

- [backstage](https://backstage.io)

### 📓 Terraform Documentation

- [global](global/infra/README.md)
- [regional](regional/infra/README.md)
