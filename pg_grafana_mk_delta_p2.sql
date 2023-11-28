
/*
 postgres SQL to create delta line
 reads last two entries from ORA_IOSTATS
 and inserts the delta into ORA_IOSTATS_DELTA
*/

with mystats as (
select
  DBID,
  TS,
  INST_ID,
  SYS_VAL,
  USR_VAL,
  IOW_VAL,
  IDL_VAL,
  BSY_VAL,
  SOCKETS,
  CORES,
  CPUS,
  LOAD,
  TOTAL_RAM,
  FREE_RAM,
  row_number() over (partition by DBID, INST_ID order by TS desc) as rnk
from ORA_OSSTATS
)
insert into ORA_OSSTATS_DELTA (
select
  a.DBID,
  a.INST_ID,
  a.TS,
  cast( extract(epoch from(a.TS-b.TS)) as integer) "ELAPSED",
  greatest(0,a.SYS_VAL-b.SYS_VAL) "SYS_VAL",
  greatest(0,a.USR_VAL-b.USR_VAL) "USR_VAL",
  greatest(0,a.IOW_VAL-b.IOW_VAL) "IOW_VAL",
  greatest(0,a.IDL_VAL-b.IDL_VAL) "IDL_VAL",
  greatest(0,a.BSY_VAL-b.BSY_VAL) "BSY_VAL",
  a.SOCKETS,
  a.CORES,
  a.CPUS,
  a.LOAD,
  a.TOTAL_RAM,
  a.FREE_RAM
from
  mystats a, mystats b
where 1=1
and a.dbid=b.dbid
and a.inst_id=b.inst_id
and a.rnk=1 and b.rnk=2
);

with mystats as (
select
  DBID,
  TS,
  SMALL_READ_REQS,
  SMALL_WRITE_REQS,
  LARGE_READ_REQS,
  LARGE_WRITE_REQS,
  SMALL_READ_MEGABYTES,
  SMALL_WRITE_MEGABYTES,
  LARGE_READ_MEGABYTES,
  LARGE_WRITE_MEGABYTES,
  row_number() over (partition by DBID order by TS desc) as rnk
from ORA_IOSTATS_FILE
)
insert into ORA_IOSTATS_FILE_DELTA ( 
select
  a.DBID,
  a.TS,
  cast( extract(epoch from(a.TS-b.TS)) as integer) as "ELAPSED",
  greatest(0,(a.small_read_reqs+a.large_read_reqs)-(b.small_read_reqs+b.large_read_reqs)) as "READS",
  greatest(0,(a.small_write_reqs+a.large_write_reqs)-(b.small_write_reqs+b.large_write_reqs)) as "WRITES",
  greatest(0,(a.small_read_megabytes+a.large_read_megabytes)-(b.small_read_megabytes+b.large_read_megabytes)) as "READ_MB",
  greatest(0,(a.small_write_megabytes+a.large_write_megabytes)-(b.small_write_megabytes+b.large_write_megabytes)) as "WRITE_MB"
from
  mystats a, mystats b
where 1=1
and a.dbid=b.dbid
and a.rnk=1 and b.rnk=2
)
;
