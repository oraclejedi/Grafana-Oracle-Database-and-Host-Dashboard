
--
-- reads the gv$iostat_file view and crafts a PostgreSQL insert statement
--

select
  'insert into ORA_IOSTATS_FILE values('||
  vdb.dbid||',now(),'||
--  to_char(sysdate,'YYYYMMDDHH24MISS')||','||
  sum(iof.small_read_reqs)||','||
  sum(iof.small_write_reqs)||','||
  sum(iof.large_read_reqs)||','||
  sum(iof.large_write_reqs)||','||
  sum(iof.small_read_megabytes)||','||
  sum(iof.small_write_megabytes)||','||
  sum(iof.large_read_megabytes)||','||
  sum(iof.large_write_megabytes)||');' "-- postgresql insert"
from
  v$database vdb,
  gv$iostat_file iof
where 1=1
and iof.con_id=0
group by vdb.dbid
/

