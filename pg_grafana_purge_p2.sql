/*

purge older records from the oracle monitoring tables in PostgreSQL

created by Graham Thornton - oraclejedi@gmail.com - gruffdba.wordpress.com

November 2023

*/

delete from ora_osstats where ts::date <= current_date -1;

delete from ora_osstats_delta where ts::date <= current_date -1;

delete from ora_iostats_file where ts::date <= current_date -1;

delete from ora_iostats_file_delta where ts::date <= current_date -1;

