FROM ubuntu:16.04

RUN echo root:pivotal | chpasswd \
    && apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository ppa:greenplum/db \
    && apt-get update && apt-get install -y greenplum-db-oss

COPY config/* /tmp/


RUN cat /tmp/sysctl.conf.add >> /etc/sysctl.conf \
    && cat /tmp/limits.conf.add >> /etc/security/limits.conf \
    && rm -f /tmp/*.add \
    && echo "localhost" > /tmp/gpdb-hosts \
    && chmod 777 /tmp/gpinitsystem_singlenode \
    && hostname > ~/orig_hostname \
    && mv /tmp/run.sh /usr/local/bin/run.sh \
    && chmod +x /usr/local/bin/run.sh

RUN localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && groupadd gpadmin \
    && useradd gpadmin -g gpadmin \
    && echo "pivotal\npivotal"|passwd gpadmin\
    && echo "gpadmin        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers \
    && mkdir -p /home/gpadmin /gpdata/master /gpdata/segments \
    && chown -R gpadmin: /gpdata /home/gpadmin \
    #&& chmod -R gpadmin /opt/gpdb \
    && mv /tmp/bash_profile /home/gpadmin/.bash_profile

RUN service ssh start \
    && su gpadmin -l -c "source /opt/gpdb/greenplum_path.sh;gpssh-exkeys -f /tmp/gpdb-hosts" \
    && su gpadmin -l -c "source /opt/gpdb/greenplum_path.sh;gpinitsystem -a -c  /tmp/gpinitsystem_singlenode -h /tmp/gpdb-hosts; exit 0 " \
    && su gpadmin -l -c "export MASTER_DATA_DIRECTORY=/gpdata/master/gpseg-1;source /opt/gpdb/greenplum_path.sh;psql -d template1 -c \"alter user gpadmin password 'pivotal'\"; createdb gpadmin;  exit 0"

EXPOSE 5432 22

     VOLUME /gpdata
     # Set the default command to run when starting the container
     CMD echo "127.0.0.1 $(cat ~/orig_hostname)" >> /etc/hosts \
             && service ssh start \
     #       && sysctl -p \
             && su gpadmin -l -c "/usr/local/bin/run.sh" \
             && /bin/bash