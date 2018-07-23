#!/usr/bin/env bash
service ssh start
su gpadmin -l -c "echo \"host all all 0.0.0.0/0 md5\" >> /gpdata/master/gpseg-1/pg_hba.conf"
su gpadmin -l -c "gpstart -a"