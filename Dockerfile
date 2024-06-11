FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update -y && apt-get install aptitude wget software-properties-common ntpsec git unattended-upgrades lsb-release software-properties-common gnupg build-essential -y
RUN add-apt-repository -y ppa:opencpu/opencpu-2.2
RUN add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN rm /var/lib/apt/lists/* -fr
RUN aptitude update -y && aptitude install -y libproj-dev libpoppler-glib-dev ca-certificates-java libmagick++-dev libgfortran-~N-dev libgcc-~N-dev libglpk-dev libfftw3-dev libfftw3-mpi-dev libxslt1-dev libopenblas-dev libopenblas64-dev libarchive-dev libpoppler-cpp-dev libffmpeg-~N-dev libfontconfig1-dev libcurl4-openssl-dev r-base r-base-dev opencpu-server rstudio-server cmake default-jdk-headless default-jre-headless libharfbuzz-dev libfribidi-dev libcairo2-dev ntpsec git lsb-release software-properties-common gnupg build-essential dirmngr libopenblas-dev libpoppler-cpp0v5 libgsl-dev

RUN R -e "options('install.packages.compile.from.source' = 'never'); options(timeout=100000); options(repos = 'https://cloud.r-project.org'); install.packages('BiocManager', dependencies = TRUE, quiet = TRUE, Ncpus = parallel::detectCores()); BiocManager::install(ask = F, quiet = TRUE, Ncpus = parallel::detectCores()); BiocManager::install('miniCRAN',ask = F, quiet = TRUE, Ncpus = parallel::detectCores()); BiocManager::install(miniCRAN::pkgDep(c('mirt', 'lavaan', 'stm', 'future.apply', 'openxlsx', 'writexl', 'readxl', 'ctv', 'LMest')), ask = F, dependencies = T, quiet = TRUE, Ncpus = parallel::detectCores()); ctv::install.views(c('Psychometrics', 'MixedModels'), ask = F, dependencies = T, quiet = TRUE, Ncpus = parallel::detectCores())"

EXPOSE 8004
CMD ["/bin/bash", "-c", "service ntpsec start && service unattended-upgrades start && service opencpu-server start && service rstudio-server start && service rstudio-server start && R"]
