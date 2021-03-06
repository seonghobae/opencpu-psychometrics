# syntax=docker/dockerfile:1
FROM seonghobae/opencpu-psychometrics:latest
WORKDIR /root/
ENV DEBIAN_FRONTEND noninteractive
RUN \
  apt-get update && \
  apt-get -y full-upgrade && apt-get install -y systemd unattended-upgrades ntpsec && systemctl enable ntpsec && systemctl enable unattended-upgrades 
RUN \
  R -e "options(timeout=10000); options(repos = 'https://cran.asia'); options(BioC_mirror = 'https://cran.asia'); update.packages(ask = F)"
EXPOSE 8004
CMD ["apachectl", "-D", "FOREGROUND"]
