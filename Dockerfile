FROM ghcr.io/geocompx/rocker-rpy

RUN R -e "remotes::install_github('itsleeds/tds')"
# Copy and install Python requirements first to leverage Docker layer cache
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --upgrade pip \
	&& pip3 install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /workspace

# Copy the repository contents
COPY . /workspace