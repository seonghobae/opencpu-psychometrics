# syntax=docker/dockerfile:1
FROM ghcr.io/seonghobae/opencpu-psychometrics:main
WORKDIR /root/
ENV DEBIAN_FRONTEND noninteractive
RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get -y upgrade
RUN \
  R -e "options(repos = 'https://cran.asia'); install.packages('BiocManager'); BiocManager::install(version = 'devel', ask = F); version_info <- as.data.frame(installed.packages()[,c('Package','Version')]); if(length(grep('1.34', version_info[version_info$Package == 'mirt','Version']))>0){devtools::install_git('https://github.com/philchalmers/mirt.git')}"
EXPOSE 8004
CMD ["apachectl", "-D", "FOREGROUND"]
