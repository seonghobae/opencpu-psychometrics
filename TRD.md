# Technical Requirements Document (TRD)

## Architecture
- Single Docker image defined in `Dockerfile`.
- Base image: Ubuntu (as defined in `Dockerfile`).
- OpenCPU installed via PPA along with R and system dependencies.
- Psychometrics-related R packages are installed during image build.
- Container exposes port 8004 and starts OpenCPU and related services on boot.

## Build and release pipeline
- GitHub Actions workflow: `.github/workflows/docker-publish.yml`.
- Triggers:
  - Scheduled nightly build.
  - Pushes to `main` and version tags.
- Publishing:
  - Images pushed to GHCR with `latest` and `nightly` tags.
- Security artifacts:
  - SBOM generation and upload to GitHub Advanced Security.

## Runtime behavior
- Services started via `CMD` in the Dockerfile.
- Expected entrypoint behavior is a long-running OpenCPU server.

## Configuration
- Environment variables used in workflow: `REGISTRY`, `IMAGE_NAME`.
- Build-time options: `DEBIAN_FRONTEND=noninteractive`.

## Dependencies
- System packages for OpenCPU and R compilation.
- OpenCPU PPA and CRAN Ubuntu repository.
- GitHub Actions for build, SBOM generation, and dependency submission.

## Testing and verification
- CI build acts as the primary verification step.
- YAML linting can be run locally with `yamllint`.

## Observability and operations
- Use container logs for runtime diagnostics.
- Rebuild image to pick up OS and CRAN updates.

## Security considerations
- Pin GitHub Actions to specific SHAs.
- Upload SBOMs to dependency graph for visibility.
