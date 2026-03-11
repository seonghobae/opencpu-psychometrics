# Architecture

## Overview

This repository ships a multi-architecture Docker image manifest for
`ghcr.io/seonghobae/opencpu-psychometrics`.
The image layers Ubuntu, OpenCPU, system libraries, Rust, and a
large R package set used for psychometrics workloads.
GitHub Actions verifies the repository by building the image on pull
requests and by building plus publishing it from
`.github/workflows/docker-publish.yml` on pushes to `main`, the nightly
schedule, and release tag paths.

## Build Pipeline

1. `.github/workflows/docker-publish.yml` runs
   `docker/setup-qemu-action`, `docker/setup-buildx-action`, and
   `docker/build-push-action` on pushes, pull requests, and the
   nightly schedule.
2. `Dockerfile` installs Ubuntu packages, OpenCPU from the official
   PPA, the CRAN apt repository, and the required R ecosystem
   packages.
3. Pull requests build the `linux/amd64` and `linux/arm64` targets for
   verification without publishing them.
4. Pushes, tags, and scheduled runs publish a manifest list for
   `linux/amd64` and `linux/arm64`, so the same image tag resolves to
   the native architecture on supported runners and hosts.
5. The workflow signs published images and uploads an SBOM when the
   event is not a pull request.

## Stability Constraints

- The hosted GitHub runner is the limiting environment for the Docker
  build.
- The R package installation layer is capped with `R_INSTALL_NCPUS=2`
  to reduce peak runner load during `docker/build-push-action`.
- `BiocManager::install(..., update = FALSE)` is used to avoid a full
  Bioconductor update sweep during nightly builds.
