FROM ubuntu:18.04

LABEL maintaainer="Aurelio Vivas <aa.vivas@uniandes.edu.co>"

RUN apt-get -y update \
	&& apt-get install -y \
	build-essential \
	openssh-server \
	tar \
	nano \
	sudo \
	git

RUN adduser --disabled-password --gecos "" mpiuser \
	&& echo "mpiuser:mpiuser" | chpasswd \
	&& usermod -aG sudo mpiuser 

WORKDIR /tmp/mpi
RUN wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz \
	&& tar xfz openmpi-3.1.2.tar.gz \
	&& cd openmpi-3.1.2 \
	&& ./configure --prefix=/usr/local \
	&& make \
	&& make install \
	&& su -c "mkdir -p /home/mpiuser/.ssh/" mpiuser \
	&& echo 'StrictHostKeyChecking=no' >> /home/mpiuser/.ssh/config \
	&& echo export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib/" >> /home/mpiuser/.bashrc
