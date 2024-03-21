FROM rocker/r-ubuntu:22.04

# Add a custom Rprofile.site
ADD Rprofile.site /usr/lib/R/etc/Rprofile.site

# Update and install system dependencies
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
    libudunits2-dev libgdal-dev libgeos-dev \
    libproj-dev pandoc libmagick++-dev \
    libglpk-dev libnode-dev \
    wget git rsync python3 python3-pip \
    && sed -i 's/value="1GiB"/value="8GiB"/1' /etc/ImageMagick-6/policy.xml

# Install Quarto
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.550/quarto-1.4.550-linux-amd64.deb \
    && DEBIAN_FRONTEND=noninteractive apt install ./quarto-*-linux-amd64.deb \
    && rm quarto-*-linux-amd64.deb

# Install R packages
RUN install.r devtools rmarkdown quarto tidyverse gifski ggrepel ggpubr \
 && installGithub.r rundel/checklist rundel/parsermd \
 && installGithub.r Selbosh/ggchernoff

# Copy requirements.txt and install Python packages
COPY requirements.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Cleanup
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
