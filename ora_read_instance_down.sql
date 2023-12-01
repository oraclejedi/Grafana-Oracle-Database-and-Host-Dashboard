
--
-- reads the gv$osstat view and crafts a Postgres insert statement
-- inserts all zeroes into ORA_OSSTATS when a RAC instance is not in an OPEN state
--

select
  'insert into ORA_OSSTATS values('||
  vdb.dbid||','||vt.thread#||',now(),0,0,0,0,0,0,0,0,0,0,0);' "-- postgres insert"
from
  v$database vdb,
  v$thread vt
where 1=1
and vt.status != 'OPEN'
;

