# AGENTS.md

## Project overview

- This repository publishes the `opencpu-psychometrics` Docker image.
- The critical verification path is the Docker build in
  `.github/workflows/docker-publish.yml`.

## Build and test commands

- Docker regression checks: `python3 -m unittest discover -s tests -v`
- Local image build probe:
  `docker build --progress=plain -t opencpu-psychometrics .`
- Local multi-arch workflow probe:
  `docker buildx build --platform linux/amd64,linux/arm64 --progress=plain .`

## Code style

- Keep Dockerfile changes focused on build reliability and image behavior.
- Preserve Ubuntu/OpenCPU/CRAN sources unless there is evidence they
  are the failure source.

## Documentation

- Update `ARCHITECTURE.md` when the Docker build behavior or workflow
  expectations change.
