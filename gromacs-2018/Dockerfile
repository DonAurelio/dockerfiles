FROM nvidia/cuda:10.0-devel-ubuntu18.04

LABEL maintaainer="Aurelio Vivas <aa.vivas@uniandes.edu.co>"

RUN apt-get -y update \
	&& apt-get install -y \
	build-essential \
	openssh-server \
	tar \
	nano \
	sudo \
	git \
	cmake \
	wget

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

USER mpiuser

WORKDIR /home/mpiuser/

RUN wget http://ftp.gromacs.org/pub/gromacs/gromacs-2018.tar.gz \
	 && tar xfz gromacs-2018.tar.gz \
	 && export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib/" \
	 && cd gromacs-2018 \
	 && mkdir build \
	 && cd build \
	 && cmake .. \
		-DGMX_GPU=ON \
		-DGMX_MPI=ON \
		-DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
		-DGMX_BUILD_OWN_FFTW=ON \
		-DCMAKE_CXX_COMPILER=/usr/local/bin/mpic++ \
		-DCMAKE_C_COMPILER=/usr/local/bin/mpicc \
	 && make \
	 && make check \
	 && echo 'mpiuser' | sudo -S make install \
	 && echo 'mpiuser' | sudo -S source /usr/local/gromacs/bin/GMXRC \
	 && echo 'mpiuser' | sudo -S ln -s /usr/local/gromacs/bin/gmx_mpi /usr/bin/gmx_mpi