create table rep_stock_market 
(
CLOSE_DATE timestamp,
TRANSACTION_ID number not null,
TRADER varchar2(255));
comment on table rep_stock_market is 'model data analitics of stock_market';
create unique index rep_stock_market_pk on rep_stock_market(TRANSACTION_ID);
alter table rep_stock_market add constraint pk_rep_stock_market primary key (TRANSACTION_ID);
 

create table stock_market 
(
CLOSE_DATE timestamp,
TRANSACTION_ID number not null,
STOCK_ID number not null,
SECTOR_ID number not null,
STOCK_NAME varchar2(300),
CLOSE_PRICE number(3,1),
CLOSE_VOLUME number(5)
);


comment on table stock_market is 'model data stock_market';
create unique index stock_market_pk on stock_market(TRANSACTION_ID);
alter table stock_market add constraint pk_stock_market primary key (TRANSACTION_ID);
  
create index stock_market_stock_fk on stock_market(STOCK_ID);
alter table stock_market add constraint fk_stock_market_stoc foreign key (STOCK_ID)
  references rep_stock_market(TRANSACTION_ID);
  
create index stock_market_sector_fk on stock_market(SECTOR_ID);
alter table stock_market add constraint fk_stock_market_sec foreign key (SECTOR_ID)
  references rep_stock_market(TRANSACTION_ID);
  

-- desc stock_market;
/* firts insert to this table */
insert into rep_stock_market
select f.CLOSE_DATE, aa.TRANSACTION_ID, e.TRADER
from  
(select TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J'),TO_CHAR(DATE '9999-12-31','J'))),'J') CLOSE_DATE from all_objects where rownum <= 150 ) f 
,(select rownum TRANSACTION_ID from all_objects where rownum < 2000 ) aa
,(select DBMS_RANDOM.STRING('A', 3) TRADER from all_objects where rownum <= 30 ) e 
where rownum < 2000 
order by 1,2,3; 
  

/* second inserting to this table */
insert into stock_market
select f.CLOSE_DATE, aa.TRANSACTION_ID, a.STOCK_ID, b.SECTOR_ID, e.STOCK_NAME, d.CLOSE_PRICE, j.VOLUME
from  

create table TRANSACTIONS_RAW (
      TRANSACTION_ID            number not null
    , STOCK_NAME    varchar2 (32)
    , CLOSE_DATE            number not null
    , CLOSE_PRICE        number not null
    , VOLUME       number not null)
pctfree 0 parallel 4 nologging;


create or replace function TRUNC_UT (p_UT number, p_StripeTypeId number)
return number deterministic is
begin
    return
    case p_StripeTypeId
    when 1  then trunc (p_UT / 1) * 1
    when 2  then trunc (p_UT / 10) * 10
    when 3  then trunc (p_UT / 60) * 60
    when 4  then trunc (p_UT / 600) * 600
    when 5  then trunc (p_UT / 3600) * 3600
    when 6  then trunc (p_UT / ( 4 * 3600)) * ( 4 * 3600)
    when 7  then trunc (p_UT / (24 * 3600)) * (24 * 3600)
    when 8  then trunc ((trunc (date '1970-01-01' + p_UT / 86400, 'Month') - date '1970-01-01') * 86400)
    when 9  then trunc ((trunc (date '1970-01-01' + p_UT / 86400, 'year')  - date '1970-01-01') * 86400)
    when 10 then 0
    when 11 then 0
    end;
end;

create or replace function UT2DATESTR (p_UT number) return varchar2 deterministic is
begin
    return to_char (date '1970-01-01' + p_UT / 86400, 'YYYY.MM.DD HH24:MI:SS');
end;



select
       1                                                    as STRIPE_ID
     , STOCK_NAME
     , TRUNC_UT(TO_NUMBER(to_char(CLOSE_DATE,'yyyymmddhh24missff9')), 1)                                     as UT
     , avg (CLOSE_PRICE) keep (dense_rank first order by CLOSE_DATE, STOCK_ID) as AOPEN
     , max (CLOSE_PRICE)                                         as AHIGH
     , min (CLOSE_PRICE)                                         as ALOW
     , avg (CLOSE_PRICE) keep (dense_rank last  order by CLOSE_DATE, STOCK_ID) as ACLOSE
     , sum (CLOSE_VOLUME)                                        as AVOLUME
     , sum (CLOSE_PRICE * CLOSE_VOLUME)                               as AAMOUNT
     , count (*)                                            as ACOUNT
from stock_market
group by STOCK_NAME, TRUNC_UT(TO_NUMBER(to_char(CLOSE_DATE, 'yyyymmddhh24missff9')), 1);


create table rep_stock_market 
(
CLOSE_DATE timestamp,
TRANSACTION_ID number not null,
TRADER varchar2(255));
comment on table rep_stock_market is 'model data analitics of stock_market';
create unique index rep_stock_market_pk on rep_stock_market(TRANSACTION_ID);
alter table rep_stock_market add constraint pk_rep_stock_market primary key (TRANSACTION_ID);
 

create table stock_market 
(
CLOSE_DATE timestamp,
TRANSACTION_ID number not null,
STOCK_ID number not null,
SECTOR_ID number not null,
STOCK_NAME varchar2(300),
CLOSE_PRICE number(3,1),
CLOSE_VOLUME number(5)
);


comment on table stock_market is 'model data stock_market';
create unique index stock_market_pk on stock_market(TRANSACTION_ID);
alter table stock_market add constraint pk_stock_market primary key (TRANSACTION_ID);
  
create index stock_market_stock_fk on stock_market(STOCK_ID);
alter table stock_market add constraint fk_stock_market_stoc foreign key (STOCK_ID)
  references rep_stock_market(TRANSACTION_ID);
  
create index stock_market_sector_fk on stock_market(SECTOR_ID);
alter table stock_market add constraint fk_stock_market_sec foreign key (SECTOR_ID)
  references rep_stock_market(TRANSACTION_ID);
  

-- desc stock_market;
/* firts insert to this table */
insert into rep_stock_market
select f.CLOSE_DATE, aa.TRANSACTION_ID, e.TRADER
from  
(select TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J'),TO_CHAR(DATE '9999-12-31','J'))),'J') CLOSE_DATE from all_objects where rownum <= 15 ) f 
,(select rownum TRANSACTION_ID from all_objects where rownum < 3000 ) aa
,(select DBMS_RANDOM.STRING('A', 3) TRADER from all_objects where rownum <= 30 ) e 
where rownum < 3000 
order by 1,2,3; 
  

/* second inserting to this table */
insert into stock_market
select f.CLOSE_DATE, aa.TRANSACTION_ID, a.STOCK_ID, b.SECTOR_ID, e.STOCK_NAME, d.CLOSE_PRICE, j.VOLUME
from  
(select TO_DATE(SYSDATE, 'DD/MM/YY HH24:MI:SS') + 
       dbms_random.value(0, TO_DATE(SYSDATE, 'DD/MM/YY HH24:MI:SS') - 
       TO_DATE(SYSDATE, 'DD/MM/YY HH24:MI:SS')+1) CLOSE_DATE from all_objects where rownum <= 4000 ) f 
,(select rownum TRANSACTION_ID from all_objects where rownum <= 4000 ) aa
,(select rownum STOCK_ID from all_objects where rownum < 30 ) a 
,(select rownum SECTOR_ID from all_objects where rownum <= 4 ) b 
,(select DBMS_RANDOM.STRING('A', 4) STOCK_NAME from all_objects where rownum <= 300 ) e 
,(select cast(DBMS_RANDOM.VALUE(0, 3) as number(3,2)) CLOSE_PRICE from all_objects where rownum <= 4000 ) d 
,(select cast(DBMS_RANDOM.VALUE(20,100) as number(5)) VOLUME from all_objects where rownum <= 4000 ) j
where rownum <= 4000 
order by 1,2,3;

create table TRANSACTIONS_RAW (
      TRANSACTION_ID            number not null
    , STOCK_NAME    varchar2 (32)
    , CLOSE_DATE            number not null
    , CLOSE_PRICE        number not null
    , VOLUME       number not null)
pctfree 0 parallel 4 nologging;


create or replace function TRUNC_UT (p_UT number, p_StripeTypeId number)
return number deterministic is
begin
    return
    case p_StripeTypeId
    when 1  then trunc (p_UT / 1) * 1
    when 2  then trunc (p_UT / 10) * 10
    when 3  then trunc (p_UT / 60) * 60
    when 4  then trunc (p_UT / 600) * 600
    when 5  then trunc (p_UT / 3600) * 3600
    when 6  then trunc (p_UT / ( 4 * 3600)) * ( 4 * 3600)
    when 7  then trunc (p_UT / (24 * 3600)) * (24 * 3600)
    when 8  then trunc ((trunc (date '1970-01-01' + p_UT / 86400, 'Month') - date '1970-01-01') * 86400)
    when 9  then trunc ((trunc (date '1970-01-01' + p_UT / 86400, 'year')  - date '1970-01-01') * 86400)
    when 10 then 0
    when 11 then 0
    end;
end;

create or replace function UT2DATESTR (p_UT number) return varchar2 deterministic is
begin
    return to_char (date '1970-01-01' + p_UT / 86400, 'YYYY.MM.DD HH24:MI:SS');
end;



select
       1                                                    as STRIPE_ID
     , STOCK_NAME
     , TRUNC_UT(TO_NUMBER(to_char(CLOSE_DATE,'yyyymmddhh24missff9')), 1)                                     as UT
     , avg (CLOSE_PRICE) keep (dense_rank first order by CLOSE_DATE, STOCK_ID) as AOPEN
     , max (CLOSE_PRICE)                                         as AHIGH
     , min (CLOSE_PRICE)                                         as ALOW
     , avg (CLOSE_PRICE) keep (dense_rank last  order by CLOSE_DATE, STOCK_ID) as ACLOSE
     , sum (CLOSE_VOLUME)                                        as AVOLUME
     , sum (CLOSE_PRICE * CLOSE_VOLUME)                               as AAMOUNT
     , count (*)                                            as ACOUNT
from stock_market
group by STOCK_NAME, TRUNC_UT(TO_NUMBER(to_char(CLOSE_DATE, 'yyyymmddhh24missff9')), 1);


select * from stock_market
