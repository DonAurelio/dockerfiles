# Base image
FROM ubuntu:20.04

# Image propietary
LABEL maintainer="Aurelio Vivas aurelio.vivas@correounivalle.edu.co"

# Disable interctaive installs
ENV DEBIAN_FRONTEND=noninteractive

# postgresql
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV SLUGIFY_USES_TEXT_UNIDECODE=yes

RUN apt-get -y update \
    &&  apt-get install -y \
        build-essential \
        python3-dev \
        python3-pip \
        python3-venv \
        python3-gdal \
        libyaml-dev \
        libpq-dev \
        libproj-dev \
        proj-bin \
        libgdal-dev \
        libgeos-dev \
        libgeos++-dev \
        libudunits2-dev \
        libnetcdf-dev \
        libhdf4-alt-dev \
        libhdf5-serial-dev \
        gfortran \
        postgresql-doc \
        libhdf5-doc \
        netcdf-doc \
        libgdal-doc \
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
    && sudo apt remove python3-numpy \
    && adduser --uid 1024 --disabled-password --gecos "" datacube \
    && echo "datacube:datacube" | chpasswd \
    && usermod -aG sudo datacube \
    && chown datacube:datacube /home/datacube \
    && mkdir /download_storage /indexed_storage /analysis_storage \
    && chown datacube:root /download_storage /indexed_storage /analysis_storage \
    && sudo echo "datacube ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && sudo -k \
    && su datacube \
    && cd /home/datacube \
    && pip3 install setuptools \
    && pip3 install wheel 'setuptools_scm[toml]' cython \
    && pip3 install 'pyproj==2.*' 'datacube[all]' --no-binary=rasterio,pyproj,shapely,fiona,psycopg2,netCDF4,h5py \
    && pip3 install jupyterlab

WORKDIR /home/datacube

USER datacube

COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
