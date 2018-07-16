FROM postgres

WORKDIR /root

#Install postgres dev and python integration
RUN apt-get update
RUN apt-get -y install git
RUN apt-get -y install postgresql-server-dev-all
RUN apt-get -y install postgresql-common
RUN apt-get -y install postgresql-plpython3-10
RUN apt-get -y install python3-pip
RUN apt-get -y install libgmp3-dev
RUN apt-get -y install libmpfr-dev
RUN apt-get -y install libmpc-dev

#Install python libraries
RUN python3 -m pip install gmpy2
RUN python3 -m pip install click
RUN python3 -m pip install pycrypto
RUN python3 -m pip install numpy
RUN python3 -m pip install nose

#Install phe
RUN git clone https://github.com/n1analytics/python-paillier.git
WORKDIR python-paillier
RUN git fetch --all --tags --prune
RUN git checkout tags/1.4.0
RUN cp -r phe /usr/local/lib/python3.5/dist-packages


