FROM ghcr.io/geocompx/rocker-rpy

RUN R -e "remotes::install_github('itsleeds/tds')"

RUN pip3 install jupyter jupyter-cache

WORKDIR /workspace

COPY . /workspace