# Product Requirements Document (PRD)

## Overview
opencpu-psychometrics delivers a Docker image that runs OpenCPU with a curated set
of psychometrics-focused R packages preinstalled. It targets quick startup for
analysis workflows without manual server provisioning.

## Goals
- Provide a ready-to-run OpenCPU server with psychometrics libraries bundled.
- Publish container images on a regular cadence (nightly) and on demand (main).
- Keep dependency tracking in place for security and compliance workflows.

## Non-goals
- Hosting or operating a managed OpenCPU service.
- Providing a web UI beyond OpenCPU/RStudio defaults.
- Supporting multiple OS base images.

## Target users
- Data scientists and analysts who need OpenCPU with psychometrics packages.
- Internal teams that want a repeatable container for CI or deployment.

## Functional requirements
- The container runs OpenCPU and exposes it on port 8004.
- The image is available via GitHub Container Registry (GHCR).
- Builds run on pushes to main and on a scheduled nightly basis.
- Tagged variants include `latest` and `nightly`.

## Non-functional requirements
- Build reproducibility with pinned GitHub Actions versions.
- Dependency visibility via SBOM generation and upload.
- Reasonable startup time for interactive use.

## Success metrics
- Successful scheduled builds without manual intervention.
- Image pull and startup success across environments.
- SBOM upload completes on CI builds.

## Assumptions and risks
- OpenCPU PPA and CRAN repositories remain available.
- Package installations may be impacted by upstream changes.
- Long build times are acceptable due to dependency volume.
