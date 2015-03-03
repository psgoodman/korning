-- DEFINE YOUR DATABASE SCHEMA HERE
DROP TABLE IF EXISTS sales;


DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
  id         serial PRIMARY KEY NOT NULL,
  name       TEXT
);

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  id         serial PRIMARY KEY NOT NULL,
  name       TEXT
);

DROP TABLE IF EXISTS products;

CREATE TABLE products (
  id         serial PRIMARY KEY NOT NULL,
  name       TEXT
);

DROP TABLE IF EXISTS invoice_frequency;

CREATE TABLE invoice_frequency (
  id         serial PRIMARY KEY NOT NULL,
  type       TEXT
);


CREATE TABLE sales (
  id         serial PRIMARY KEY NOT NULL,
  date       date,
  amount     money,
  units      integer,
  invoice_number  integer,
  invoice_frequency_id  integer REFERENCES invoice_frequency,
  customer_id   integer REFERENCES customers,
  employee_id   integer REFERENCES employees,
  product_id    integer REFERENCES products
);
