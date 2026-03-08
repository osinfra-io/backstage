# Ekklesia Team Instructions

## Repository Overview

- **`pt-ekklesia`** — Backstage developer portal running on GKE; provides the platform service catalog and developer tooling
- **`pt-ekklesia-docs`** — Platform documentation powered by GitBook
- **`pt-ekklesia-repository-templates`** — Standardized skeletons for creating new platform repositories

## GitHub Actions

- Container images are built and pushed via the `build-and-push` called workflow from `osinfra-io/pt-techne-misc-workflows`.
- All GitHub Actions must use full 40-character commit SHAs.
