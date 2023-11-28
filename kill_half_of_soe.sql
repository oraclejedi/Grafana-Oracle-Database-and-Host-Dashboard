--
-- generates Linux commands to kill half of active SOE connections to this instance
--
-- created by Graham Thornton - oraclejedi@gmail.com - gruffdba.wordpress.com
--
-- November 2023
--

set pagesize 999
set linesize 255

with my_summary as (
select
  vs.sid,
  vs.username,
  vs.module,
  vp.spid
from v$session vs, v$process vp
where vs.type != 'BACKGROUND'
and vs.paddr = vp.addr
and vs.username = 'SOE'
and vs.module not like 'sqlplus%')
select 'kill -9 '||my_summary.spid "-- Linux command"
from my_summary
where rownum < ( select count(*)/2 from my_summary )
;

