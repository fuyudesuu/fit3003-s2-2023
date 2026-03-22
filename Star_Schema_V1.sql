-- create compnay branch dimension
CREATE TABLE company_branch_dim_v1
    AS
        SELECT DISTINCT
            ( company_branch )
        FROM
            staff;

-- create category dimension
CREATE TABLE category_dim_v1
    AS
        SELECT
            *
        FROM
            category;

--create customer type dimension
CREATE TABLE customer_type_dim_v1
    AS
        SELECT
            *
        FROM
            customer_type;

-- create time dimension
CREATE TABLE time_dim_v1
    AS
        SELECT DISTINCT
            to_char(sales_date, 'MonYYYY') AS "TIME_ID",
            to_char(sales_date, 'Month')   AS "MONTH",
            to_char(sales_date, 'YYYY')    AS "YEAR"
        FROM
            sales;

-- manually create season dimension
CREATE TABLE season_dim_v1 (
    season        VARCHAR2(10) NOT NULL,
    season_period VARCHAR2(10)
);

-- insert values into season dimension
INSERT INTO season_dim_v1 VALUES (
    'Summer',
    'Dec-Feb'
);

INSERT INTO season_dim_v1 VALUES (
    'Autumn',
    'Mar-May'
);

INSERT INTO season_dim_v1 VALUES (
    'Winter',
    'Jun-Aug'
);

INSERT INTO season_dim_v1 VALUES (
    'Spring',
    'Sep-Nov'
);

-- manually create price scale dimension
CREATE TABLE price_scale_dim_v1 (
    scale_level VARCHAR2(20),
    scale_desc  VARCHAR2(50)
);

-- insert values into price scale dimension
INSERT INTO price_scale_dim_v1 VALUES (
    'low sales',
    '<$5,000'
);

INSERT INTO price_scale_dim_v1 VALUES (
    'medium sales',
    'between $5,000 and $10,000'
);

INSERT INTO price_scale_dim_v1 VALUES (
    'high sales',
    '>$10,000'
);

-- create a temporary hire fact table
CREATE TABLE hire_temp_fact
    AS
        SELECT
            c.customer_type_id,
            s.company_branch,
            e.category_id,
            to_char(h.start_date, 'MonYYYY') AS time_id,
            SUM(h.quantity)                  AS no_of_equipment_hired,
            SUM(h.total_hire_price)          AS total_hire_revenue,
            COUNT(h.hire_id)                 AS no_of_hires
        FROM
            customer  c,
            staff     s,
            equipment e,
            hire      h
        WHERE
                c.customer_id = h.customer_id
            AND s.staff_id = h.staff_id
            AND e.equipment_id = h.equipment_id
        GROUP BY
            c.customer_type_id,
            s.company_branch,
            e.category_id,
            to_char(h.start_date, 'MonYYYY');

-- Add the season attribute to the temp hire fact table
ALTER TABLE hire_temp_fact ADD (
    season VARCHAR2(10)
);

-- update the season column with the respective seasons for the month
UPDATE hire_temp_fact
SET
    season = 'Summer'
WHERE
    to_char(to_date(time_id, 'MonYYYY'), 'MM') <= 2
    OR to_char(to_date(time_id, 'MonYYYY'), 'MM') = 12;

UPDATE hire_temp_fact
SET
    season = 'Autumn'
WHERE
        to_char(to_date(time_id, 'MonYYYY'), 'MM') <= 5
    AND to_char(to_date(time_id, 'MonYYYY'), 'MM') >= 3;

UPDATE hire_temp_fact
SET
    season = 'Winter'
WHERE
        to_char(to_date(time_id, 'MonYYYY'), 'MM') <= 8
    AND to_char(to_date(time_id, 'MonYYYY'), 'MM') >= 6;

UPDATE hire_temp_fact
SET
    season = 'Spring'
WHERE
        to_char(to_date(time_id, 'MonYYYY'), 'MM') <= 11
    AND to_char(to_date(time_id, 'MonYYYY'), 'MM') >= 9;

-- Finalise the hire fact table
CREATE TABLE monequip_hire_fact_v1
    AS
        SELECT
            *
        FROM
            hire_temp_fact;

-- CREATE THE temp SALES FACT TABLE

CREATE TABLE sales_temp_fact
    AS
        SELECT
            c.customer_type_id,
            st.company_branch,
            e.category_id,
            to_char(s.sales_date, 'MonYYYY') AS time_id,
            SUM(s.quantity)                  AS no_of_equipment_sold,
            SUM(s.total_sales_price)         AS total_sales_revenue,
            COUNT(s.sales_id)                AS no_of_sales
        FROM
            customer  c,
            staff     st,
            equipment e,
            sales     s
        WHERE
                c.customer_id = s.customer_id
            AND st.staff_id = s.staff_id
            AND e.equipment_id = s.equipment_id
        GROUP BY
            c.customer_type_id,
            st.company_branch,
            e.category_id,
            to_char(s.sales_date, 'MonYYYY');

-- Add a season column in the temp sales fact table
ALTER TABLE sales_temp_fact ADD (
    season VARCHAR2(10)
);

-- update the season column with the respective seasons for the month
UPDATE sales_temp_fact
SET
    season = 'Summer'
WHERE
    to_char(to_date(time_id, 'MonYYYY'), 'MM') <= 2
    OR to_char(to_date(time_id, 'MonYYYY'), 'MM') = 12;

UPDATE sales_temp_fact
SET
    season = 'Autumn'
WHERE
        to_char(to_date(time_id, 'MonYYYY'), 'MM') <= 5
    AND to_char(to_date(time_id, 'MonYYYY'), 'MM') >= 3;

UPDATE sales_temp_fact
SET
    season = 'Winter'
WHERE
        to_char(to_date(time_id, 'MonYYYY'), 'MM') <= 8
    AND to_char(to_date(time_id, 'MonYYYY'), 'MM') >= 6;

UPDATE sales_temp_fact
SET
    season = 'Spring'
WHERE
        to_char(to_date(time_id, 'MonYYYY'), 'MM') <= 11
    AND to_char(to_date(time_id, 'MonYYYY'), 'MM') >= 9;

-- add the price scale level attribute to the temp sales fact table
ALTER TABLE sales_temp_fact ADD (
    scale_level VARCHAR2(20)
);

-- update the price scale level columns with the respective price scales
UPDATE sales_temp_fact
SET
    scale_level = 'low sales'
WHERE
    total_sales_revenue < 5000;

UPDATE sales_temp_fact
SET
    scale_level = 'medium sales'
WHERE
        total_sales_revenue >= 5000
    AND total_sales_revenue <= 10000;

UPDATE sales_temp_fact
SET
    scale_level = 'high sales'
WHERE
    total_sales_revenue > 10000;

-- Finalise the sales fact table
CREATE TABLE monequip_sales_fact_v1
    AS
        SELECT
            *
        FROM
            sales_temp_fact;