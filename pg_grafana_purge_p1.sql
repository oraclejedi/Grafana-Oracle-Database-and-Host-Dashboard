/*

purge older records from the oracle/postgres metric tables

*/

delete from ora_osstats where ts::date <= current_date -1;

delete from ora_osstats_delta where ts::date <= current_date -1;


