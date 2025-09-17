FROM ghcr.io/geocompx/pythonr

RUN R -e "remotes::install_github('itsleeds/tds')"

# Copy and install Python requirements first to leverage Docker layer cache
COPY requirements.txt /tmp/requirements.txt
RUN python -m pip install --upgrade pip \
  && pip install -r /tmp/requirements.txt

WORKDIR /workspace

# Copy the repository contents
COPY . /workspace
