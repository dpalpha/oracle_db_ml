
drop table XTERN_DECISION_JP;
create table XTERN_DECISION_JP as
select a.outlook, b.temperature, c.humidity, d.wind, e.play_ball
from  
(select DBMS_RANDOM.STRING('A', 10) outlook from all_objects where rownum < 30 ) a
,(select DBMS_RANDOM.STRING('A', 2) temperature from all_objects where rownum < 120 ) b
,(select DBMS_RANDOM.STRING('A', 3) humidity from all_objects where rownum < 200 ) c
,(select DBMS_RANDOM.STRING('A', 4) wind from all_objects where rownum <= 30 ) d 
,(select DBMS_RANDOM.STRING('A', 2) play_ball from all_objects where rownum <= 2 ) e
where rownum < 3000 
order by 1,2,3; 



declare
v_table varchar2(30):='XTERN_DECISION_JP';
v_classifier varchar2(30):='PLAY_BALL';
v_numrows number(10,4);
v_entropy number(10,4);
v_centropy number(10,4);
v_gain number(10,4):=0;
v_gainm number(10,4):=0;
v_rootnode varchar2(30):='';
v_rootvalue varchar2(30):='';
v_createview varchar2(4000):='create or replace view temp_vw_jp as select ';
v_predicate varchar2(4000);

begin
execute immediate 'select count(*) from '||v_table||' ' into v_numrows;
execute immediate
'select round((-1)*(sum((val)*(log(2,(val))))),4) '||
' from ( '||
' select '||v_classifier||',count(*)/'||v_numrows||' val '||
'from '||v_table||' group by '||v_classifier||')' into v_entropy;
dbms_output.put_line('Entropy '||v_entropy);
for c1 in (select column_name col from all_tab_columns where 1=1
and table_name=v_table and column_name not in (
SELECT regexp_substr(v_classifier ,'[^,]+', 1, level)
FROM dual CONNECT BY regexp_substr(v_classifier ,'[^,]+', 1, level) IS NOT NULL
) order by column_id) loop
execute immediate 'with t1 as (select '||c1.col||' cl1 ,count(*) val from '||v_table||
' group by '||c1.col||'), t2 as (select '||c1.col||' cl1,'||v_classifier||
' cl2,count(*) val from '||v_table||' group by '||c1.cOl||','||v_classifier||
'), t3 as (select t1.cl1,t1.val val1 ,t2.cl2,t2.val val2 from t1,t2 where t1.cl1 = t2.cl1 ),
t4 as (select cl1,(t3.val1/'||v_numrows||')*(sum((-1)*(val2/val1)*(log(2,(val2/val1))))) sum_val
from t3 group by cl1,t3.val1,'||v_numrows||')
select '||v_entropy||' - round(sum(sum_val),4) from t4' into v_gain;
if( v_gain > v_gainm) then
v_gainm:=v_gain;
v_rootnode:=c1.col;
end if;
end loop;
dbms_output.put_line('Root Node '||v_rootnode||' '||v_gainm);
execute immediate v_createview||v_rootnode||' as cl1, '||v_classifier||' as cl2 from '||v_table;
for c2 in ( select col.cl1,col.val total_count,clsfr.cl2,clsfr.val classifier_count from
(select cl1,count(*) val from temp_vw_jp group by cl1) col,
(select cl1,cl2,count(*) val from temp_vw_jp group by cl1,cl2) clsfr
where col.cl1 = clsfr.cl1 ) loop
if (c2.total_count = c2.classifier_count) then
dbms_output.put_line(v_rootnode||' -> '||c2.cl1||'('||c2.total_count||') -> '||v_classifier||' -> '||
c2.cl2||'('||c2.classifier_count||')');
v_rootvalue:=c2.cl1;
v_predicate:=' and '||v_rootnode||' not in ('''||v_rootvalue||''')';
else
null;
end if;
end loop;


for c3 in (select column_name from dba_tab_columns where table_name=v_table
and column_name not in (v_rootnode,v_classifier) order by 1) loop
v_centropy:=0;
execute immediate v_createview||v_rootnode||' cl1,'||c3.column_name||' cl2,'||v_classifier||
' cl3 from '||v_table||' where 1=1 '||v_predicate;
v_gain:=0;
for c31 in (select distinct cl1 from temp_vw_jp order by 1) loop
execute immediate 'with t1 as (select count(*) val from temp_vw_jp where cl1='''||c31.cl1||'''),
t2 as (select cl3,count(*) val from temp_vw_jp where cl1='''||c31.cl1||''' group by cl3)
select sum((t2.val/t1.val)*((-1)*(log(2,(t2.val/t1.val))))) from t1,t2' into v_centropy;
dbms_output.put_line(c31.cl1||' '||v_centropy);

for c32 in (
with t1 as (select count(*) val from temp_vw_jp where cl1=c31.cl1),
t2 as (select cl1,cl2,count(*) val from temp_vw_jp where cl1=c31.cl1 group by cl1,cl2),
t3 as (select cl1,cl2,cl3,count(*) val from temp_vw_jp where cl1=c31.cl1 group by cl1,cl2,cl3),
t4 as (select sum((-1)*(t3.val/t1.val)*(log(2,(t3.val/t2.val)))) val from t1,t2,t3 where t2.cl1=t3.cl1
and t2.cl2=t3.cl2) select t2.cl1,t2.cl2,t3.cl3,t2.val val2,t3.val val3,t4.val val4
from t2,t3,t4 where t2.cl1=t3.cl1 and t2.cl2=t3.cl2) loop
if (c32.val2 = c32.val3) then
dbms_output.put_line(v_rootnode||' -> '||c32.cl1||' '||c3.column_name||
' -> '||c32.cl2||'('||c32.val2||') '||v_classifier||' -> '||c32.cl3||' ('||c32.val3||')');
v_predicate:=v_predicate||' and '||v_rootnode||' not in ('''||c32.cl1||''')';
execute immediate v_createview||v_rootnode||' cl1,'||c3.column_name||' cl2,'||v_classifier||
' cl3 from '||v_table||' where 1=1 '||v_predicate;
end if;
end loop;
end loop;
end loop;
end;
/
