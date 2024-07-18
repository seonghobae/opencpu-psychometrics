FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update -y && apt-get install aptitude wget software-properties-common ntpsec git unattended-upgrades lsb-release dirmngr gnupg build-essential -y
RUN add-apt-repository -y ppa:opencpu/opencpu-2.2
RUN add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN rm /var/lib/apt/lists/* -fr
RUN aptitude update -y
# Configuration failed libraries should to be add
RUN aptitude install -y libgfortran-~N-dev libgcc-~N-dev libffmpeg-~N-dev opencpu-server libproj-dev libpoppler-glib-dev ca-certificates-java libmagick++-dev libglpk-dev libfftw3-dev libfftw3-mpi-dev libxslt1-dev libarchive-dev libpoppler-cpp-dev libfontconfig1-dev libcurl4-openssl-dev cmake default-jdk-headless libharfbuzz-dev libfribidi-dev libcairo2-dev libopenblas-dev libpoppler-cpp0v5 libgsl-dev libmariadb-dev libpq-dev libssl-dev libmysqlclient-dev libsodium-dev unixodbc-dev libudunits2-dev libmpfr-dev libgdal-dev curl locales '~n^fonts-nanum' libfontconfig libfreetype6 xfonts-cyrillic xfonts-scalable fonts-liberation fonts-ipafont-gothic fonts-wqy-zenhei fonts-tlwg-loma-otf

RUN localedef -f UTF-8 -i ko_KR ko_KR.UTF-8

# add rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
RUN echo 'source $HOME/.cargo/env' >> $HOME/.bashrc

RUN R -e "options('install.packages.compile.from.source' = 'never'); options(timeout=100000); options(repos = 'https://cloud.r-project.org'); install.packages('BiocManager', dependencies = TRUE, quiet = TRUE, Ncpus = parallel::detectCores()); BiocManager::install(ask = F, quiet = TRUE, Ncpus = parallel::detectCores()); BiocManager::install('miniCRAN',ask = F, quiet = TRUE, Ncpus = parallel::detectCores()); BiocManager::install(miniCRAN::pkgDep(c('psych','sqldf','pbapply', 'mirt', 'plyr', 'GDINA', 'edina', 'ggplot2', 'lpSolveAPI', 'lavaan', 'stm', 'future.apply', 'openxlsx', 'writexl', 'readxl', 'ctv', 'LMest', 'httr', 'stringr', 'jsonlite, 'progressr')), ask = F, dependencies = T, quiet = TRUE, Ncpus = parallel::detectCores()); ctv::install.views(c('Psychometrics', 'MixedModels'), ask = F, dependencies = T, quiet = TRUE, Ncpus = parallel::detectCores())"

EXPOSE 8004
CMD ["/bin/bash", "-c", "service ntpsec start && service unattended-upgrades start && service opencpu-server start && service rstudio-server start && service rstudio-server start && R"]
