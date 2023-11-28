/* 

create monitoring tables in PostgreSQL to hold Oracle performance metrics

created by Graham Thornton - oraclejedi@gmail.com - gruffdba.wordpress.com

November 2023

*/


create table if not exists ORA_SESSIONS_NOTIME(
  dbid varchar(50) not null,
  inst_id varchar(50) not null,
  users int not null
);

alter table ORA_SESSIONS_NOTIME add primary key ( dbid, inst_id );

create table if not exists ORA_OSSTATS(
  dbid varchar(50) not null,  
  inst_id varchar(50) not null,
  ts timestamptz not null,
  sys_val real not null,
  usr_val real not null,
  iow_val real not null,
  idl_val real not null,
  bsy_val real not null,
  sockets int not null,
  cores int not null,
  cpus int not null,
  load real not null,
  total_ram bigint not null,
  free_ram bigint not null
);

create table if not exists ORA_OSSTATS_DELTA(
  dbid varchar(50) not null,  
  inst_id varchar(50) not null,
  ts timestamptz not null,
  elapsed real not null,
  sys_val real not null,
  usr_val real not null,
  iow_val real not null,
  idl_val real not null,
  bsy_val real not null,
  sockets int not null,
  cores int not null,
  cpus int not null,
  load real not null,
  total_ram bigint not null,
  free_ram bigint not null
);

create table if not exists ORA_IOSTATS_FILE(
  dbid varchar(50) not null,  
  ts timestamptz not null,
  small_read_reqs bigint not null,
  small_write_reqs bigint not null,
  large_read_reqs bigint not null,
  large_write_reqs bigint not null,
  small_read_megabytes bigint not null,
  small_write_megabytes bigint not null,
  large_read_megabytes bigint not null,
  large_write_megabytes bigint not null
);

create table if not exists ORA_IOSTATS_FILE_DELTA(
  dbid varchar(50) not null,
  ts timestamptz not null,
  elapsed real not null,
  reads bigint not null,
  writes bigint not null,
  read_mb bigint not null,
  write_mb bigint not null
);

