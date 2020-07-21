# Base image
FROM ubuntu:18.04

# Image propietary
LABEL maintainer="Aurelio Vivas aurelio.vivas@correounivalle.edu.co"

# Disable interctaive installs
ENV DEBIAN_FRONTEND=noninteractive

# postgresql
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# miniconda
ENV PATH="/home/datacube/miniconda3/bin:$PATH"
ENV SLUGIFY_USES_TEXT_UNIDECODE=yes

RUN apt-get -y update \
    && apt-get install -y \
    build-essential \
    python3-dev \
    python3-pip \
    python3-gdal \
    libhdf5-serial-dev \
    libnetcdf-dev \
    libgdal-dev \
    hdf5-tools \
    netcdf-bin \
    gdal-bin \
    postgresql \
    pgadmin3 \
    tar \
    nano \
    sudo \
    git \
    wget \
    && adduser --disabled-password --gecos "" datacube \
    && echo "datacube:datacube" | chpasswd \
    && usermod -aG sudo datacube \
    && chown datacube:datacube /home/datacube \
    && mkdir /datasets_storage /ingested_storage \
    && chown datacube:root /datasets_storage /ingested_storage \
    && sudo echo "datacube ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && sudo -k \
    && su datacube \
    && cd /home/datacube \
    && pip3 install datacube==1.8.2 \
    && pip3 install setuptools==42 'numpy>=1.15' shapely jupyter \
    && mkdir ${HOME}/.jupyter \
    && echo c.NotebookApp.token = \'\' > ${HOME}/.jupyter/jupyter_notebook_config.py

WORKDIR /home/datacube

USER datacube

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm Miniconda3-latest-Linux-x86_64.sh

COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
