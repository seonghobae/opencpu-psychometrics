FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /app
RUN apt-get update && \
    apt-get install -y unattended-upgrades ntpsec git wget \
    lsb-release software-properties-common gnupg build-essential dirmngr libopenblas-dev && \
    unattended-upgrades && \
    add-apt-repository -y ppa:opencpu/opencpu-2.2 && \
    wget -qO- https://cran.asia/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    add-apt-repository -y "deb https://cran.asia/bin/linux/ubuntu $(lsb_release -cs)-cran40/" && \
    apt-get update && apt-get full-upgrade -y && \
    apt-get install -y r-base r-base-dev opencpu-server rstudio-server && \
    apt-get clean -y && \
    R -e "options(timeout=10000); options(repos = 'https://cran.asia'); options(BioC_mirror = 'https://cr', ask = Fan.asia'); install.packages('BiocManager, dependencies = TRUE, quiet = TRUE); BiocManager::install(ask = F, quiet = TRUE); BiocManager::install(available.packages()[,1], ask = F, dependencies = T, quiet = TRUE)"

CMD ["/bin/bash", "-c", "service ntpsec start && service unattended-upgrades start && R"]
