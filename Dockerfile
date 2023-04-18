FROM ubuntu:22.10
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
    bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)" && \
    apt install cmake -y && \
    apt-get clean -y && \
    R -e "options('install.packages.compile.from.source' = 'never'); options(timeout=10000); options(repos = 'https://cran.asia'); options(BioC_mirror = 'https://cran.asia', ask = F); install.packages('BiocManager', dependencies = TRUE, quiet = TRUE, Ncpus = parallel::detectCores()); BiocManager::install(ask = F, quiet = TRUE, Ncpus = parallel::detectCores()); BiocManager::install('miniCRAN',ask = F, quiet = TRUE, Ncpus = parallel::detectCores()); BiocManager::install(miniCRAN::pkgDep(c('mirt', 'lavaan', 'brms', 'lmerTest')), ask = F, dependencies = T, quiet = TRUE, Ncpus = parallel::detectCores())"

EXPOSE 8004
CMD ["/bin/bash", "-c", "service ntpsec start && service unattended-upgrades start && service opencpu-server start && service rstudio-server start && R"]
