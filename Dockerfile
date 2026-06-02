FROM ghcr.io/geocompx/pythonr
# Trigger tds image rebuild

# Copy and install Python requirements first to leverage Docker layer cache
COPY requirements.txt /tmp/requirements.txt
RUN python -m pip install --upgrade pip \
  && pip install -r /tmp/requirements.txt

WORKDIR /workspace

# Copy the repository contents
COPY . /workspace

# Install the checked-out package with the repo's pak-based installer so image
# builds stay aligned with the source being built and the upstream base image.
RUN Rscript scripts/install.R
