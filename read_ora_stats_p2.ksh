#!/bin/sh

#
# simple looping shell script to read performance data form Oracle and insert it into tables in PostgreSQL
# this is used so that the free version of Grafana can read the data and create a dashboard
#

# connect string to Oracle
export CSORA=soe/soe@mydb

# connect string to PostgreSQL
export CSPG="-h 192.168.0.1 -d mydb -U postgres"

# oracle scripts to run - these will generate PostgreSQL insert statements
#export script_list="ora_read_osstats"
#export script_list="ora_read_osstats ora_read_sessions_notime"
#export script_list="ora_read_osstats ora_read_sessions_notime ora_read_instance_down"
export script_list="ora_read_osstats ora_read_sessions_notime ora_read_iostats_file ora_read_instance_down"

# PostgreSQL scripts to generate deltas and clean up
export PG1=pg_grafana_mk_delta_p2
export PG2=pg_grafana_purge_p2

let ec=0



#
# connect to oracle and read the iostats
#

ReadOracle( ) {

echo executing $3.$4 against Oracle

sqlplus -s /nolog <<EOF1

whenever oserror exit -1;
whenever sqlerror exit sql.sqlcode;

connect $1

alter session set nls_date_language=american;

set echo off
set heading off
set feedback off
set pagesize 50000
set linesize 999
set trimspool on

spool $2.$4

@$3.$4

spool off
EOF1

let rv=$?

# if ok then reset error count
if [[ 0 -eq $rv ]]; then let ec=0; fi

return $rv
}

#
# write data to Postgres
#

WritePostgres( ) {

echo executing $2.$3 against Postgres

psql $1 -a -f $2.$3<<EOF2
\q
EOF2

}

#
# main loop
#

echo "lock file for read_ora_stats.ksh" > orapg.lck
echo "remove this file to shut down process" >> orapg.lck
echo "process $$" >> orapg.lck

while [[ -f orapg.lck ]]
do

  echo "--------------"
  echo "start of loop "

  for script in ${script_list}
  do
    export output=`echo ${script}.out`

    echo "executing $script to generate output $output"

    ReadOracle $CSORA $output $script "sql"

    WritePostgres "$CSPG" $output "sql"

  done

  # generate the delta in postgres
  WritePostgres "$CSPG" $PG1 "sql"

  # purge older stats in postgres
  WritePostgres "$CSPG" $PG2 "sql"

  sleep 5

done

echo "script complete"

exit 0;


