# syntax=docker/dockerfile:1
FROM seonghobae/opencpu-psychometrics:base
WORKDIR /root/
ENV DEBIAN_FRONTEND noninteractive
RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get -y upgrade && apt-get install -y systemd
RUN \
  R -e "options(timeout=10000); options(repos = 'https://cran.asia'); options(BioC_mirror = 'https://cran.asia'); install.packages('BiocManager'); BiocManager::install(version = BiocManager:::version(), ask = F); BiocManager::install('miniCRAN', ask = F); if(length(grep('1.34', version_info[version_info$Package == 'mirt','Version']))>0){devtools::install_git('https://github.com/philchalmers/mirt.git')}"
EXPOSE 8004
CMD ["apachectl", "-D", "FOREGROUND"]
