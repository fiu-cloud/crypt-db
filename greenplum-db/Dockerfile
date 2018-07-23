FROM ubuntu:16.04

RUN echo root:pivotal | chpasswd \
    && apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository ppa:greenplum/db \
    && apt-get update && apt-get install -y greenplum-db-oss vim openssh-server

COPY config/* /tmp/

RUN cat /tmp/sysctl.conf.add >> /etc/sysctl.conf \
    && cat /tmp/limits.conf.add >> /etc/security/limits.conf \
    && rm -f /tmp/*.add \
    && echo "localhost" > /tmp/gpdb-hosts \
    && chmod 777 /tmp/gpinitsystem_singlenode \
    && chmod 555 /tmp/banner.txt \
    && mv /tmp/start_gp.sh /usr/local/bin/start_gp.sh \
    && mv /tmp/stop_gp.sh /usr/local/bin/stop_gp.sh \
    && chmod +x /usr/local/bin/start_gp.sh /usr/local/bin/stop_gp.sh \
    && localedef -i en_US -f UTF-8 en_US.UTF-8


RUN useradd gpadmin -s /bin/bash -U

RUN localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && echo "pivotal\npivotal"|passwd gpadmin \
    && echo "gpadmin        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers \
    && mkdir -p /home/gpadmin /gpdata/master /gpdata/segments \
    && chown -R gpadmin: /gpdata /home/gpadmin /tmp \
    && mv /tmp/bash_profile /home/gpadmin/.bash_profile

EXPOSE 5432 22
VOLUME /gpdata
CMD ["/bin/bash", "-c", "start_gp.sh && /bin/bash"]

#docker run --name my-gp -i -t -p 5432:5432 -d fiucloud/gp /bin/bash
#docker exec -i -t my-gp /bin/bash
