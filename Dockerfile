FROM ghcr.io/geocompx/pythonr
# Trigger tds image rebuild on ultra-slim geocompx/pythonr (Python 3.14 + R 4.6.2 + Debian 13 trixie)

ENV PKG_SYSREQS=false

# Copy and install Python requirements first to leverage Docker layer cache.
# Install pystats19 with --no-deps so its legacy numpy<2.0 constraint does not
# downgrade NumPy 2.x (which pyarrow >= 20 requires at runtime).
COPY requirements.txt /tmp/requirements.txt
RUN grep -v '^pystats19' /tmp/requirements.txt > /tmp/requirements-core.txt && \
    if command -v uv >/dev/null 2>&1; then \
      uv pip install --system --no-cache -r /tmp/requirements-core.txt && \
      uv pip install --system --no-cache --no-deps pystats19; \
    else \
      python -m pip install --upgrade pip && \
      pip install --no-cache-dir -r /tmp/requirements-core.txt && \
      pip install --no-cache-dir --no-deps pystats19; \
    fi && \
    rm -f /tmp/requirements.txt /tmp/requirements-core.txt

WORKDIR /workspace

# Copy the repository contents
COPY . /workspace

# Install the checked-out package with the repo's pak-based installer so image
# builds stay aligned with the source being built and the upstream base image.
RUN Rscript scripts/install.R && \
    (strip --strip-unneeded /opt/R/current/lib/R/library/*/libs/*.so 2>/dev/null || true) && \
    rm -rf /opt/R/current/lib/R/library/*/doc /tmp/* /root/.cache/R/pkgcache /var/lib/apt/lists/*
