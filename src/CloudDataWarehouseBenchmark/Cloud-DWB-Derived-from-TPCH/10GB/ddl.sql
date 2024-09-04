create table customer (
  c_custkey int8 not null ,
  c_name varchar(25) not null,
  c_address varchar(40) not null,
  c_nationkey int4 not null,
  c_phone char(15) not null,
  c_acctbal numeric(12,2) not null,
  c_mktsegment char(10) not null,
  c_comment varchar(117) not null,
  Primary Key(C_CUSTKEY)
) distkey(c_custkey) sortkey(c_custkey);

create table lineitem (
  l_orderkey int8 not null ,
  l_partkey int8 not null,
  l_suppkey int4 not null,
  l_linenumber int4 not null,
  l_quantity numeric(12,2) not null,
  l_extendedprice numeric(12,2) not null,
  l_discount numeric(12,2) not null,
  l_tax numeric(12,2) not null,
  l_returnflag char(1) not null,
  l_linestatus char(1) not null,
  l_shipdate date not null ,
  l_commitdate date not null,
  l_receiptdate date not null,
  l_shipinstruct char(25) not null,
  l_shipmode char(10) not null,
  l_comment varchar(44) not null,
  Primary Key(L_ORDERKEY, L_LINENUMBER)
) distkey(l_orderkey) sortkey(l_shipdate,l_orderkey)  ;

create table nation (
  n_nationkey int4 not null,
  n_name char(25) not null ,
  n_regionkey int4 not null,
  n_comment varchar(152) not null,
  Primary Key(N_NATIONKEY)                                
) distkey(n_nationkey) sortkey(n_nationkey) ;

create table orders (
  o_orderkey int8 not null,
  o_custkey int8 not null,
  o_orderstatus char(1) not null,
  o_totalprice numeric(12,2) not null,
  o_orderdate date not null,
  o_orderpriority char(15) not null,
  o_clerk char(15) not null,
  o_shippriority int4 not null,
  o_comment varchar(79) not null,
  Primary Key(O_ORDERKEY)
) distkey(o_orderkey) sortkey(o_orderdate, o_orderkey) ;

create table part (
  p_partkey int8 not null ,
  p_name varchar(55) not null,
  p_mfgr char(25) not null,
  p_brand char(10) not null,
  p_type varchar(25) not null,
  p_size int4 not null,
  p_container char(10) not null,
  p_retailprice numeric(12,2) not null,
  p_comment varchar(23) not null,
  PRIMARY KEY (P_PARTKEY)
) distkey(p_partkey) sortkey(p_partkey);

create table partsupp (
  ps_partkey int8 not null,
  ps_suppkey int4 not null,
  ps_availqty int4 not null,
  ps_supplycost numeric(12,2) not null,
  ps_comment varchar(199) not null,
  Primary Key(PS_PARTKEY, PS_SUPPKEY)
) distkey(ps_partkey) sortkey(ps_partkey);

create table region (
  r_regionkey int4 not null,
  r_name char(25) not null ,
  r_comment varchar(152) not null,
  Primary Key(R_REGIONKEY)                             
) distkey(r_regionkey) sortkey(r_regionkey);

create table supplier (
  s_suppkey int4 not null,
  s_name char(25) not null,
  s_address varchar(40) not null,
  s_nationkey int4 not null,
  s_phone char(15) not null,
  s_acctbal numeric(12,2) not null,
  s_comment varchar(101) not null,
  Primary Key(S_SUPPKEY)
) distkey(s_suppkey) sortkey(s_suppkey)
;

/*
Text files needed to load test data under s3://redshift-downloads/TPC-H/10GB are publicly available. Any valid credentials can be used to access the files.

To load the sample data, you must provide authentication for your cluster to access Amazon S3 on your behalf.

You can provide authentication by referencing an IAM role that you have created. You can set an IAM_Role as the default for your cluster or you can directly provide the ARN of an IAM_Role.  
For more information https://docs.aws.amazon.com/redshift/latest/mgmt/authorizing-redshift-service.html

The COPY commands include a placeholder for IAM_Role, in this code IAM_Role clause is set to use the default IAM_Role. If your cluster does not have a IAM_Role set as default then please follow the instructions provided here:

https://docs.aws.amazon.com/redshift/latest/mgmt/default-iam-role.html

For more information check samples in https://docs.aws.amazon.com/redshift/latest/gsg/rs-gsg-create-sample-db.html

**Note** another option to provide IAM_Role is to provide IAM_Role ARN in IAM_Role clause. For example
copy region from's3://redshift-downloads/TPC-H/10GB/region/' IAM_Role 'Replace text inside the quotes with Redshift cluster IAM_Role ARN' gzip delimiter '|';
*/

copy region from 's3://redshift-downloads/TPC-H/2.18/10GB/region.tbl' iam_role default delimiter '|' region 'us-east-1';
copy nation from 's3://redshift-downloads/TPC-H/2.18/10GB/nation.tbl' iam_role default delimiter '|' region 'us-east-1';
copy lineitem from 's3://redshift-downloads/TPC-H/2.18/10GB/lineitem.tbl' iam_role default delimiter '|' region 'us-east-1';
copy orders from 's3://redshift-downloads/TPC-H/2.18/10GB/orders.tbl' iam_role default delimiter '|' region 'us-east-1';
copy part from 's3://redshift-downloads/TPC-H/2.18/10GB/part.tbl' iam_role default delimiter '|' region 'us-east-1';
copy supplier from 's3://redshift-downloads/TPC-H/2.18/10GB/supplier.tbl' iam_role default delimiter '|' region 'us-east-1';
copy partsupp from 's3://redshift-downloads/TPC-H/2.18/10GB/partsupp.tbl' iam_role default delimiter '|' region 'us-east-1';
copy customer from 's3://redshift-downloads/TPC-H/2.18/10GB/customer.tbl' iam_role default delimiter '|' region 'us-east-1';

select count(*) from customer;  -- 1500000
select count(*) from lineitem;  -- 59986052
select count(*) from nation;  -- 25
select count(*) from orders;  -- 15000000
select count(*) from part;  -- 2000000
select count(*) from partsupp;  -- 8000000
select count(*) from region;  -- 5
select count(*) from supplier;  -- 100000
