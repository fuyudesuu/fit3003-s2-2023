-- create a customer dimension
CREATE TABLE customer_dim_v2
    AS
        SELECT
            *
        FROM
            customer;

-- create an equipment dimension
CREATE TABLE equipment_dim_v2
    AS
        SELECT
            *
        FROM
            equipment;

-- create a staff dimension
CREATE TABLE staff_dim_v2
    AS
        SELECT
            *
        FROM
            staff;

-- create a hire id with date dimension
CREATE TABLE hire_id_date_dim_v2
    AS
        SELECT
            hire_id,
            start_date
        FROM
            hire;

-- create a sales id with date and price scale dimension
CREATE TABLE sales_id_date_price_v2
    AS
        SELECT
            sales_id,
            sales_date,
            CASE
                WHEN total_sales_price < 5000   THEN
                    'low sales'
                WHEN total_sales_price >= 5000
                     AND total_sales_price <= 10000 THEN
                    'medium sales'
                WHEN total_sales_price >= 10000 THEN
                    'high sales'
            END AS price_scale_level
        FROM
            sales;

-- create the sales fact table for version 2
CREATE TABLE monequip_sales_fact_v2
    AS
        SELECT
            sales_id,
            equipment_id,
            customer_id,
            staff_id,
            SUM(quantity)          AS no_of_equipment_sold,
            COUNT(sales_id)        AS no_of_sales,
            SUM(total_sales_price) AS total_sales_revenue
        FROM
            sales
        GROUP BY
            sales_id,
            equipment_id,
            customer_id,
            staff_id;

-- create the hire fact table for version 2
CREATE TABLE monequip_hire_fact_v2
    AS
        SELECT
            hire_id,
            equipment_id,
            customer_id,
            staff_id,
            SUM(quantity)         AS no_of_equipment_hired,
            COUNT(hire_id)        AS no_of_hires,
            SUM(total_hire_price) AS total_hire_revenue
        FROM
            hire
        GROUP BY
            hire_id,
            equipment_id,
            customer_id,
            staff_id;