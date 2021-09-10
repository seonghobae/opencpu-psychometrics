# syntax=docker/dockerfile:1
FROM seonghobae/opencpu-psychometrics:latest
WORKDIR /root/
ENV DEBIAN_FRONTEND noninteractive
RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get -y upgrade 
RUN \
  R -e "options(repos = 'https://cran.asia'); install.packages('BiocManager'); BiocManager::install(version = 'devel', ask = F)"
EXPOSE 8004
CMD ["apachectl", "-D", "FOREGROUND"]
