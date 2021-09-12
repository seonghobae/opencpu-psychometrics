# opencpu-psychometrics
[![Docker](https://github.com/seonghobae/opencpu-psychometrics/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/seonghobae/opencpu-psychometrics/actions/workflows/docker-publish.yml)

The unofficial fork of opencpu-server with Pre-installed Psychometrics libraries in R.
- Newly built with official Ubuntu 20.04 Docker image and PPA source of the OpenCPU-server.
- Just Removed barrier of timeout limits for psychometrics libraries.

# Notes
- This docker image will be automatic daily update with nightly tag.
- Automatic update will be includes updates of CRAN libraries and Ubuntu apt updates.

# How to use this?
## Nightly Build (with CRAN library Auto updates)
- docker run --name opencpu-psychometrics -d -it -p 8004:8004 --restart always ghcr.io/seonghobae/opencpu-psychometrics:nightly

## Latest Build
- docker run --name opencpu-psychometrics -d -it -p 8004:8004 --restart always ghcr.io/seonghobae/opencpu-psychometrics:latest
- docker run --name opencpu-psychometrics -d -it -p 8004:8004 --restart always seonghobae/opencpu-psychometrics:latest
