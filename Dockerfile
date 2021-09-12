# syntax=docker/dockerfile:1
FROM seonghobae/opencpu-psychometrics:latest
WORKDIR /root/
ENV DEBIAN_FRONTEND noninteractive
RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get -y upgrade && \
  apt-get -y install libv8-dev libcairo2-dev libomp-dev libmpfr-dev
RUN \
  R -e "options(repos = 'https://cran.asia'); install.packages('BiocManager'); BiocManager::install(version = 'devel', ask = F); version_info <- as.data.frame(installed.packages()[,c('Package','Version')]); if(length(grep('1.34', version_info[version_info$Package == 'mirt','Version']))>0){devtools::install_git('https://github.com/philchalmers/mirt.git')}; BiocManager::install('ctv', ask = F); ctv::install.views(c('Psychometrics', 'SocialSciences'))"
EXPOSE 8004
CMD ["apachectl", "-D", "FOREGROUND"]
