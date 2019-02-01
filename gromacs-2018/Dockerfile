FROM nvidia/cuda:10.0-devel-ubuntu18.04

LABEL maintaainer="Aurelio Vivas <aa.vivas@uniandes.edu.co>"

# Install OpenMPI 3.1.2
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

# Install gromacs 2018
RUN apt-get -y update \
	&& apt-get install -y \
	cmake \
	wget

WORKDIR /tmp/gromacs

RUN wget http://ftp.gromacs.org/pub/gromacs/gromacs-2018.tar.gz \
	&& tar xfz gromacs-2018.tar.gz \
	&& cd gromacs-2018 \
	&& mkdir build \
	&& cd build \
	&& cmake .. \
		-DGMX_GPU=ON \
		-DGMX_MPI=ON \
		-DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
		-DGMX_BUILD_OWN_FFTW=ON \
		-DCMAKE_CXX_COMPILER=mpic++ \
		-DCMAKE_C_COMPILER=mpicc \
	&& make \
	&& make check \
	&& sudo make install \
	&& source /usr/local/gromacs/bin/GMXRC \
	&& sudo ln -s /usr/local/gromacs/bin/gmx_mpi /usr/bin/gmx_mpi