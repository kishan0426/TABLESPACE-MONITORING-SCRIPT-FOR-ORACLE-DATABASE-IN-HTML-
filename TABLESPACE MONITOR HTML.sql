SET MARKUP HTML ON SPOOL ON ENTMAP OFF -
head '<title> DAILY HEALTH CHECK </title> -
<style type="text/css"> -
table {background: #FFFFE0; font-size: 99%;} -
  th { background-color: DarkBlue; color:White} -
  td { padding: 0px; } -
</style>' -
body 'text=black bgcolor=FAFAD2 align=left' -
table 'align=center width=99% border=3 bordercolor=black bgcolor=grey'
spool /tmp/tb_check.html


col TOTAL_SPACE format 999999
col TABLESPACE_NAME format a20
col TOTAL_FREE_SPACE format 999999
col UTIL_PCT format 999999
select x.TABLESPACE_NAME,round((x.bytes/1073741824),2) as TOTAL_SPACE_GB,
round(x.bytes/1073741824,2) - round(sum(y.bytes/1073741824),2) as TOTAL_FREE_SPACE_GB,
case when to_number(round((round(sum(y.bytes/1073741824),2)/round(x.bytes/1073741824,2))*100,2)) > 50 then '<font color=red>' || to_char(round((round(sum(y.bytes/1073741824),2)/round(x.bytes/1073741824,2))*100,2)) || '</font>'
when to_number(round((round(sum(y.bytes/1073741824),2)/round(x.bytes/1073741824,2))*100,2)) < 50 then '<font color=green>' || to_char(round((round(sum(y.bytes/1073741824),2)/round(x.bytes/1073741824,2))*100,2)) || '</font>'
else to_char(round((round(sum(y.bytes/1073741824),2)/round(x.bytes/1073741824,2))*100,2))
end UTIL_PCT
from dba_data_files x
inner join dba_free_space y on x.TABLESPACE_NAME = y.TABLESPACE_NAME
group by x.TABLESPACE_NAME,x.bytes/1073741824;
spool off
set markup html off