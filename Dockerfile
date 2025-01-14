# Use the base image
FROM ghcr.io/geocompx/rocker-rpy

# # Install R packages
# RUN R -e "install.packages(c('tidyverse', 'sf', 'quarto', 'stats19', 'nycflights13', 'remotes', 'spDataLarge', 'DT', 'calendar', 'reticulate', 'stplanr', 'tmap', 'spData'), repos='http://cran.rstudio.com/')"

# Install Python packages
RUN pip3 install jupyter jupyter-cache

# # Install Visual Studio Code
# RUN apt-get update && apt-get install -y wget gpg \
#     && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
#     && install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/ \
#     && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main [signed-by=/usr/share/keyrings/microsoft.gpg]" > /etc/apt/sources.list.d/vscode.list' \
#     && apt-get update && apt-get install -y code \
#     && rm -f microsoft.gpg

# # Set up VS Code extensions
# RUN code --install-extension reditorsupport.r \
#     && code --install-extension GitHub.copilot-chat \
#     && code --install-extension quarto.quarto \
#     && code --install-extension ms-python.python \
#     && code --install-extension ms-toolsai.jupyter

# Set the working directory
WORKDIR /workspace

# Copy the repository files
COPY . /workspace