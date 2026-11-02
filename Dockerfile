FROM ghcr.io/geocompx/pythonr
# Trigger tds image rebuild (R 4.6.2 + Debian 13 trixie + vscode-R v3+ support)

# Copy and install Python requirements first to leverage Docker layer cache
COPY requirements.txt /tmp/requirements.txt
RUN if command -v uv >/dev/null 2>&1; then \
      uv pip install --system --no-cache -r /tmp/requirements.txt; \
    else \
      python -m pip install --upgrade pip && pip install --no-cache-dir -r /tmp/requirements.txt; \
    fi

WORKDIR /workspace

# Copy the repository contents
COPY . /workspace

# Install the checked-out package with the repo's pak-based installer so image
# builds stay aligned with the source being built and the upstream base image.
RUN Rscript scripts/install.R
