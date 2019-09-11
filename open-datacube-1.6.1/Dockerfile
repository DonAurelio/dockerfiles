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

# Copy the project into the container current workdir
COPY .datacube.conf /home/cube/.datacube.conf
RUN chown cube:cube /home/cube/.datacube.conf

# Creating datacube storage and source storage directory
RUN mkdir /dc_storage /source_storage
RUN chown cube:root /dc_storage /source_storage

# Change to cube user
USER cube

ENV PATH "$HOME/anaconda/bin:$PATH"

# Install miniconda
WORKDIR /home/cube/

# Run commands as cube user
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
	&& bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda \
	&& export PATH="$HOME/anaconda/bin:$PATH" \
	&& conda config --add channels conda-forge \
	&& conda init bash \
	# shapely is required for the metadata generation script
	&& conda create --name cubeenv conda=4.6.14 datacube==1.6.1 shapely
