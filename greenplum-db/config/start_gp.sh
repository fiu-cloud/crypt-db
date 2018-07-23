#!/usr/bin/env bash
log_file ="gp_start.log"
lock_file=".gp_initialised"

if [ ! -f "$log_file" ];
then
    touch $log_file
    chmod 755 $log_file
fi

service ssh start
cat /tmp/banner.txt >> start_gp.log 2>&1
if [ -f "$lock_file" ];
then
    date >> start_gp.log 2>&1
    echo "gpdb has already been initialised" >> start_gp.log 2>&1
    su gpadmin -l -c "gpstart -a" >> start_gp.log 2>&1
    echo "Finished start"  >> start_gp.log 2>&1
else
    date >> start_gp.log 2>&1
    echo "initialising gpdb..." >> start_gp.log 2>&1
    su gpadmin -l -c "gpssh-exkeys -f /tmp/gpdb-hosts" >> start_gp.log 2>&1
    su gpadmin -l -c "gpinitsystem -a -c  /tmp/gpinitsystem_singlenode -h /tmp/gpdb-hosts; exit 0" >> start_gp.log 2>&1
    su gpadmin -l -c "psql -d template1 -c \"alter user gpadmin password 'pivotal'\"; createdb gpadmin; exit 0" >> start_gp.log 2>&1
    su gpadmin -l -c "gpstop -a" >> start_gp.log 2>&1
    su gpadmin -l -c "echo \"host all all 0.0.0.0/0 md5\" >> /gpdata/master/gpseg-1/pg_hba.conf" >> start_gp.log 2>&1
    su gpadmin -l -c "gpstart -a" >> start_gp.log 2>&1
    touch $lock_file >> start_gp.log 2>&1
    chmod 555 $lock_file >> start_gp.log 2>&1
    echo "Finished initialisation"  >> start_gp.log 2>&1
fi




