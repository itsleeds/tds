FROM ghcr.io/geocompx/pythonr

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && apt-get update \
  && apt-get install gh -y

RUN R -e "remotes::install_github('itsleeds/tds')"

# Copy and install Python requirements first to leverage Docker layer cache
COPY requirements.txt /tmp/requirements.txt
RUN python -m pip install --upgrade pip \
  && pip install -r /tmp/requirements.txt

WORKDIR /workspace

# Copy the repository contents
COPY . /workspace
