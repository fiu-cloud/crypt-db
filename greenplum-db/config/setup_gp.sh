#!/usr/bin/env bash
service ssh start
su gpadmin -l -c "gpssh-exkeys -f /tmp/gpdb-hosts"
su gpadmin -l -c "gpinitsystem -a -c  /tmp/gpinitsystem_singlenode -h /tmp/gpdb-hosts; exit 0"
su gpadmin -l -c "psql -d template1 -c \"alter user gpadmin password 'pivotal'\"; createdb gpadmin; exit 0"
su gpadmin -l -c "gpstop -a"
su gpadmin -l -c "echo \"host all all 0.0.0.0/0 md5\" >> /gpdata/master/gpseg-1/pg_hba.conf"
su gpadmin -l -c "gpstart -a"