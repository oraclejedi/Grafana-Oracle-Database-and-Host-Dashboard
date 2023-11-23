#!/bin/sh

# connect string to Oracle
export CSORA=soe/soe@mydb

# connect string to PostgrSQL
export CSPG="-h 192.168.0.1 -d mydb -U postgres"

# oracle scripts to run - these will generate PostgreSQL insert statements
export ORA1=ora_read_osstats
export ORA2=ora_read_sessions_notime

# names of the generated output files from the scripts above.
export SP1=pg_insert_os.tmp
export SP2=pg_insert_sessions_notime.tmp

# PostgreSQL scripts to generate deltas and clean up
export PG1=pg_grafana_mk_delta_p1
export PG2=pg_grafana_purge_p1

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

  echo "start of loop "

  # read oracle os stats
  ReadOracle $CSORA $SP1 $ORA1 "sql"

  # read soe sessions
  ReadOracle $CSORA $SP2 $ORA2 "sql"

  # write os stats to ora_osstats in postgres
  WritePostgres "$CSPG" $SP1 "sql"

  # write session data to ora_sessions
  WritePostgres "$CSPG" $SP2 "sql"

  # generate the delta in postgres
  WritePostgres "$CSPG" $PG1 "sql"

  # purge older stats in postgres
  WritePostgres "$CSPG" $PG2 "sql"

  sleep 5

done

echo "script complete"

exit 0;

