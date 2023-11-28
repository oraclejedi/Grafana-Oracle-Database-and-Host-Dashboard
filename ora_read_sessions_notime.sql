
--
-- reads the gv$session view and craft a PostgreSQL insert statement
--

select
  'insert into ORA_SESSIONS_NOTIME values('||
  vdb.dbid||','||
  gvs.inst_id||','||
  count(*)||') on conflict ( dbid,inst_id ) do update set users='||count(*)||';' "-- postgresql insert"
from
  gv$session gvs,
  v$database vdb
where username = 'SOE'
group by vdb.dbid, gvs.inst_id
union all
select
  'insert into ORA_SESSIONS_NOTIME values('||
  vdb.dbid||','||
  vt.thread#||',0) on conflict ( dbid,inst_id ) do update set users=0;' "-- postgresql insert"
from
  v$thread vt,
  v$database vdb
where not exists ( select 1 from gv$session gvs where gvs.username = 'SOE' and gvs.inst_id = vt.thread# )
group by vdb.dbid, vt.thread#
/

