show catalogs;
show schemas from northwind ;
show schemas from hive ;
show schemas from iceberg ;

-- CASE 1: Query the titanic.parquet dataset and store in iceberg

create schema if not exists hive.titanic WITH (location='s3a://titanic/');

drop table if exists hive.titanic.titanic_parquet;

create table if not exists hive.titanic.titanic_parquet (
	PassengerId INT,
	Survived INT,
	Pclass INT,
	Name VARCHAR,
	Sex VARCHAR,
	Age DOUBLE,
	SibSp INT,
	Parch INT,
	Ticket VARCHAR,
	Fare DOUBLE,
	Cabin VARCHAR,
	Embarked VARCHAR
)
WITH (
  external_location = 's3a://titanic/',
  format = 'PARQUET'
);

select * from hive.titanic.titanic_parquet;

drop table if exists iceberg.titanic.titanic_iceberg;

create table iceberg.titanic.titanic_iceberg (
	PassengerId INT,
	Survived INT,
	Pclass INT,
	Name VARCHAR,
	Sex VARCHAR,
	Age DOUBLE,
	SibSp INT,
	Parch INT,
	Ticket VARCHAR,
	Fare DOUBLE,
	Cabin VARCHAR,
	Embarked VARCHAR
)
WITH (
  format = 'PARQUET',
  location = 's3a://titanic/ice'
);

insert into iceberg.titanic.titanic_iceberg select * from hive.titanic.titanic_parquet;
select * from iceberg.titanic.titanic_iceberg;

-- CASE 2: Get orders from northwind and store as iceberg partitioned by month, country


select 
	o.orderid,
	shipcountry,
	orderdate,
	customerid,
	productid,
	quantity
from mariadb.northwind."orders" o
join mariadb.northwind."order details" d on o.orderid = d.orderid
where shipcountry = 'Argentina'
limit 10;


drop schema if exists iceberg.northwind;
CREATE schema if not exists iceberg.northwind WITH (location='s3a://northwind/');

drop table if exists iceberg.northwind.customer_orders;
CREATE TABLE if not exists iceberg.northwind.customer_orders (
    orderid BIGINT,
    shipcountry varchar,
    orderdate DATE,
    customerid varchar,
    productid INT,
    quantity INT)
WITH (partitioning = ARRAY['shipcountry','month(orderdate)'])

insert into iceberg.northwind.customer_orders
	select 
		o.orderid,
		shipcountry,
		orderdate,
		customerid,
		productid,
		quantity
	from mariadb.northwind."orders" o
	join mariadb.northwind."order details" d on o.orderid = d.orderid;

select * from iceberg.northwind.customer_orders
where shipcountry = 'Argentina'
;


-- CASE 3: Query seamlessly across mariadb and storage

create schema if not exists hive.northwind WITH (location='s3a://northwind/');
drop table if exists hive.northwind.company_emails ;
create table hive.northwind.company_emails (
	comanyname VARCHAR,
	email VARCHAR
	)
WITH (FORMAT = 'CSV',
    skip_header_line_count = 1,
    EXTERNAL_LOCATION = 's3a://northwind/company_emails/')
;

with latest as (
select 
	*,
	row_number() over (partition by customerid order by orderdate desc) rn
	from 
mariadb.northwind.orders o
)
select 
	c.companyname, 
	orderdate,
	e.email,
	listagg(productname,', ') WITHIN GROUP (ORDER by d.quantity ) as products,
	sum(d.unitprice*d.quantity) amount
from latest l
join mariadb.northwind."order details" d on l.orderid = d.orderid
join mariadb.northwind.products p on d.productid = p.productid 
join mariadb.northwind.customers c on l.customerid = c.customerid 
join hive.northwind.company_emails e on c.companyname = e.comanyname 
where rn = 1
group by 1,2,3
order by 5 desc
;

