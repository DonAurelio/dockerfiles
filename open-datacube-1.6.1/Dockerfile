# Base image
FROM opendatacube/datacube-core:1.6.1

# Image propietary
LABEL maintainer="Aurelio Vivas aurelio.vivas@correounivalle.edu.co"

RUN apt-get -y update \
	&& apt-get install -y \
	build-essential \
	tar \
	nano \
	sudo \
	git \
	wget

# Create cube user
RUN adduser --disabled-password --gecos "" cube \
	&& echo "cube:cube" | chpasswd \
	&& usermod -aG sudo cube \
	&& chown cube:cube /home/cube

# Creating datacube storage and source storage directory
RUN mkdir /dc_storage /source_storage
RUN chown cube:root /dc_storage /source_storage

# Change to cube user
USER cube

ENV PATH "$HOME/anaconda/bin:$PATH"

# Install miniconda
WORKDIR /home/cube/

# Run commands as cube user
# shapely: requied for the metadata generation script
# jupyter: for jupyter notebooks
RUN pip3 install shapely \
	&& pip3 install jupyter
