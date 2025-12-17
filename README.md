Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt build


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

# Snowflake Data Setup Guide

This documentation provides the setup scripts and configuration details for initializing your Snowflake environment.

## 🔗 Snowflake Trial
Sign up for a free account here: [Snowflake Free Trial Registration](https://signup.snowflake.com/)

## ℹ️ Account Identifier Note
Snowflake has updated their Account Identifier format for some regions. You may need to include two components of your Snowflake URL in your connection settings. 
* **Format:** `ORGNAME-ACCOUNTNAME`
* **Your Example ID:** `CMVGRNF-FKA50167`

---

## 🛠️ SQL Setup Script

```sql
-- 1. Create Infrastructure
create warehouse transforming; 
create database raw; 
create database analytics; 

-- 2. Create Schemas
create schema raw.jaffle_shop; 
create schema raw.stripe;

-- 3. Create Customers Table & Load Data
create table raw.jaffle_shop.customers 
( id integer,
  first_name varchar,
  last_name varchar
);

copy into raw.jaffle_shop.customers (id, first_name, last_name)
from 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );

-- 4. Create Orders Table & Load Data
create table raw.jaffle_shop.orders
( id integer,
  user_id integer,
  order_date date,
  status varchar,
  _etl_loaded_at timestamp default current_timestamp
);

copy into raw.jaffle_shop.orders (id, user_id, order_date, status)
from 's3://dbt-tutorial-public/jaffle_shop_orders.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );

-- 5. Create Payments Table & Load Data
create table raw.stripe.payment 
( id integer,
  orderid integer,
  paymentmethod varchar,
  status varchar,
  amount integer,
  created date,
  _batched_at timestamp default current_timestamp
);

copy into raw.stripe.payment (id, orderid, paymentmethod, status, amount, created)
from 's3://dbt-tutorial-public/stripe_payments.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );

grant ownership on schema analytics.dbt_eakansel to role transformer;

-- 6. Verification Queries
select * from raw.jaffle_shop.customers; 
select * from raw.jaffle_shop.orders; 
select * from raw.stripe.payment;