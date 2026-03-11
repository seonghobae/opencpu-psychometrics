# Architecture

## Overview

This repository ships a single Docker image for
`ghcr.io/seonghobae/opencpu-psychometrics`.
The image layers Ubuntu, OpenCPU, system libraries, Rust, and a
large R package set used for psychometrics workloads.
GitHub Actions verifies the repository by building and publishing
that image from `.github/workflows/docker-publish.yml`.

## Build Pipeline

1. `.github/workflows/docker-publish.yml` runs
   `docker/build-push-action` on pushes, pull requests, and the
   nightly schedule.
2. `Dockerfile` installs Ubuntu packages, OpenCPU from the official
   PPA, the CRAN apt repository, and the required R ecosystem
   packages.
3. The workflow signs published images and uploads an SBOM when the
   event is not a pull request.

## Stability Constraints

- The hosted GitHub runner is the limiting environment for the Docker
  build.
- The R package installation layer is capped with `R_INSTALL_NCPUS=2`
  to reduce peak runner load during `docker/build-push-action`.
- `BiocManager::install(..., update = FALSE)` is used to avoid a full
  Bioconductor update sweep during nightly builds.
