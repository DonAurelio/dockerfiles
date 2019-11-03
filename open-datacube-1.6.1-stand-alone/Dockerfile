# Base image
FROM opendatacube/datacube-core:1.6.1

# Image propietary
LABEL maintainer="Aurelio Vivas aurelio.vivas@correounivalle.edu.co"

# Disable interctaive installs
ENV DEBIAN_FRONTEND=noninteractive

# Postgres will use as default time zone UTC
RUN apt-get -y update \
	&& apt-get install -y \
	build-essential \
	postgresql \
	tar \
	nano \
	sudo \
	git \
	wget

# Create cube user
RUN adduser --disabled-password --gecos "" datacube \
	&& echo "datacube:datacube" | chpasswd \
	&& usermod -aG sudo datacube \
	&& chown datacube:datacube /home/datacube \
	&& mkdir /dc_storage /source_storage \
	&& chown datacube:root /dc_storage /source_storage

COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /home/datacube

USER datacube

ENTRYPOINT ["entrypoint.sh"]
