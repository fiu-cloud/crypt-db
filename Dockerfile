FROM postgres:10.4

#Copy resources
ADD src/main/sql/setup_udfs.sql /root/setup_udfs.sql

#Set working directory
WORKDIR /root

RUN cp setup_udfs.sql /docker-entrypoint-initdb.d

#Install postgres dev and python integration
RUN apt-get update && apt-get install -y \
        git=1:2.11.0-* \
        postgresql-server-dev-all=191.* \
        postgresql-common=191.* \
        postgresql-plpython3-10=10.4-2.* \
        python3-pip=9.0.1-* \
        libgmp3-dev=2:6.1.2+* \
        libmpfr-dev=3.1.5-1 \
        libmpc-dev=1.0.3-1+*

#Install python libraries
RUN python3 -m pip install \
    gmpy2==2.0.8 \
    click==6.7 \
    pycrypto==2.6.1 \
    numpy==1.14.5 \
    nose==1.3.7

#Install phe
RUN git clone https://github.com/n1analytics/python-paillier.git
WORKDIR python-paillier
RUN git fetch --all --tags --prune
RUN git checkout tags/1.4.0
RUN cp -r phe /usr/local/lib/python3.5/dist-packages


