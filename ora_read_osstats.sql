
--
-- reads the gv$osstat view and crafts a PostgreSQL insert statement
--

set linesize 255
set pagesize 9999


select 
  'insert into ORA_OSSTATS values('||
  vdb.dbid||','||
  a.inst_id||',now(),'||
  greatest(0,a.value)||','||
  greatest(0,b.value)||','||
  greatest(0,c.value)||','||
  greatest(0,d.value)||','||
  greatest(0,e.value)||','||
  greatest(0,f.value)||','||
  greatest(0,g.value)||','||
  greatest(0,h.value)||','||
  greatest(0,i.value)||','||
  greatest(0,j.value)||','||
  greatest(0,k.value)||');' "-- postgresql insert"
from 
  v$database vdb,
  gv$osstat a,
  gv$osstat b,
  gv$osstat c,
  gv$osstat d,
  gv$osstat e,
  gv$osstat f,
  gv$osstat g,
  gv$osstat h,
  gv$osstat i,
  gv$osstat j,
  gv$osstat k
where 1=1
--
and a.con_id=0
and a.con_id=b.con_id
and a.con_id=c.con_id
and a.con_id=d.con_id
and a.con_id=e.con_id
and a.con_id=f.con_id
and a.con_id=g.con_id
and a.con_id=h.con_id
and a.con_id=i.con_id
and a.con_id=j.con_id
and a.con_id=k.con_id
--
and a.inst_id = b.inst_id
and a.inst_id = c.inst_id
and a.inst_id = d.inst_id
and a.inst_id = e.inst_id
and a.inst_id = f.inst_id
and a.inst_id = g.inst_id
and a.inst_id = h.inst_id
and a.inst_id = i.inst_id
and a.inst_id = j.inst_id
and a.inst_id = k.inst_id
--
and a.stat_name = 'SYS_TIME'
and b.stat_name = 'USER_TIME'
and c.stat_name = 'IOWAIT_TIME'
and d.stat_name = 'IDLE_TIME'
and e.stat_name = 'BUSY_TIME'
and f.stat_name = 'NUM_CPU_SOCKETS'
and g.stat_name = 'NUM_CPU_CORES'
and h.stat_name = 'NUM_CPUS'
and i.stat_name = 'LOAD'
and j.stat_name = 'PHYSICAL_MEMORY_BYTES'
and k.stat_name = 'FREE_MEMORY_BYTES'
--
order by a.inst_id
/


