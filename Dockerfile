FROM robinlovelace/geocompr

RUN apt-get update --fix-missing
RUN apt-get install -y wget \
	bzip2 \
	ca-certificates \
	build-essential \
	curl \
	git-core \
	pkg-config \
	python3-dev \
	python3-pip \
	python3-setuptools \
	python3-virtualenv \
	unzip \
	software-properties-common \
	llvm

RUN apt install -y gdal-bin python-gdal python3-gdal

## Install packages to Python3
RUN pip3 install --upgrade pip
RUN pip3 install numpy scipy pandas geopandas psycopg2 sqlalchemy networkx osmnx 

## Setup File System
RUN mkdir ds
ENV HOME=/ds
ENV SHELL=/bin/bash
VOLUME /ds
WORKDIR /ds