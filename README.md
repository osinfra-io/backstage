# <img align="left" width="45" height="45" src="https://github.com/user-attachments/assets/2b9ec893-58ff-4bf3-94c9-fc321d3a173c"> Backstage

**[GitHub Actions](https://github.com/osinfra-io/backstage/actions):**

[![Dependabot](https://github.com/osinfra-io/backstage/actions/workflows/dependabot.yml/badge.svg)](https://github.com/osinfra-io/backstage/actions/workflows/dependabot.yml)

## 📄 Repository Description

This repository manages Backstage resources. It provides a centralized repository for managing all Backstage configurations, plugins, and customizations. It runs on Google Kubernetes Engine (GKE) and leverages various Google Cloud Platform (GCP) services for scalability and reliability. It depends on [google-kubernetes-engine](https://github.com/osinfra-io/google-kubernetes-engine) for cluster provisioning and onboarding of namespaces.

The continuous delivery workflows are implemented using GitHub Actions, ensuring testing, building, and deployment of Backstage components.

## 🏭 Platform Information

- Documentation: [docs.osinfra.io](https://docs.osinfra.io/product-guides/backstage)
- Service Interfaces: [github.com](https://github.com/osinfra-io/backstage/issues/new/choose)

## <img align="left" width="35" height="35" src="https://github.com/osinfra-io/github-organization-management/assets/1610100/39d6ae3b-ccc2-42db-92f1-276a5bc54e65"> Development

Our focus is on the core fundamental practice of platform engineering, Infrastructure as Code.

>Open Source Infrastructure (as Code) is a development model for infrastructure that focuses on open collaboration and applying relative lessons learned from software development practices that organizations can use internally at scale. - [Open Source Infrastructure (as Code)](https://www.osinfra.io)

To avoid slowing down stream-aligned teams, we want to open up the possibility for contributions. The Open Source Infrastructure (as Code) model allows team members external to the platform team to contribute with only a slight increase in cognitive load. This section is for developers who want to contribute to this repository, describing the tools used, the skills, and the knowledge required, along with OpenTofu documentation.

See the [documentation](https://docs.osinfra.io/fundamentals/development-setup) for setting up a development environment.

### 🛠️ Tools

- [pre-commit](https://github.com/pre-commit/pre-commit)
- [osinfra-pre-commit-hooks](https://github.com/osinfra-io/pre-commit-hooks)

### 📋 Skills and Knowledge

Links to documentation and other resources required to develop and iterate in this repository successfully.

- [backstage](https://backstage.io/docs)

### 🔍 Tests

A local instance of Backstage can be used to test some of the changes made to the repository. You can go to the application
directory and start the app using the `yarn dev` command. The `yarn dev` command will run both the frontend and backend as separate
processes (named `[0]` and `[1]`) in the same window.

```none
cd app
```

```none
yarn dev
```

### 📓 OpenTofu Documentation

- [main](deployments/README.md)
- [regional](deployments/regionl/README.md)
