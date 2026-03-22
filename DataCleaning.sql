DROP TABLE customer CASCADE CONSTRAINTS;
/* Remove Duplicates*/

/* Check if there are duplicates in Customer table*/
SELECT
    customer_id,
    COUNT(*) AS duplicates
FROM
    monequip.customer
GROUP BY
    customer_id
HAVING
    COUNT(*) > 1;

/* There are duplicates, so remove them*/
CREATE TABLE customer
    AS
        SELECT DISTINCT
            *
        FROM
            monequip.customer;

/* Duplicates check after removing*/
SELECT
    customer_id,
    COUNT(*) AS duplicates
FROM
    customer
GROUP BY
    customer_id
HAVING
    COUNT(*) > 1;

DROP TABLE address CASCADE CONSTRAINTS;

DROP TABLE equipment CASCADE CONSTRAINTS;

DROP TABLE hire CASCADE CONSTRAINTS;

DROP TABLE sales CASCADE CONSTRAINTS;

DROP TABLE staff CASCADE CONSTRAINTS;

DROP TABLE customer_type CASCADE CONSTRAINTS;

DROP TABLE category CASCADE CONSTRAINTS;

CREATE TABLE address
    AS
        SELECT DISTINCT
            *
        FROM
            monequip.address;

CREATE TABLE equipment
    AS
        SELECT DISTINCT
            *
        FROM
            monequip.equipment;

CREATE TABLE hire
    AS
        SELECT DISTINCT
            *
        FROM
            monequip.hire;

CREATE TABLE sales
    AS
        SELECT DISTINCT
            *
        FROM
            monequip.sales;

CREATE TABLE staff
    AS
        SELECT DISTINCT
            *
        FROM
            monequip.staff;

CREATE TABLE customer_type
    AS
        SELECT DISTINCT
            *
        FROM
            monequip.customer_type;

CREATE TABLE category
    AS
        SELECT DISTINCT
            *
        FROM
            monequip.category;

/* End date is before start date*/
SELECT
    *
FROM
    hire
WHERE
    end_date - start_date < 0;

/* Cleaning*/
DELETE FROM hire
WHERE
    end_date - start_date < 0;

/* After cleaning check*/
SELECT
    *
FROM
    hire
WHERE
    end_date - start_date < 0;


/* Correct the total hire price*/
/* Check if there are entries where the total_hire_price is calculated incorrectly*/
SELECT
    hire_id,
    total_hire_price,
    temp
FROM
    (
        SELECT
            hire_id,
            start_date,
            end_date,
            equipment_id,
            quantity,
            unit_hire_price,
            customer_id,
            staff_id,
            total_hire_price,
            CASE
                WHEN end_date - start_date < 1 THEN
                    unit_hire_price * 0.5 * quantity
                ELSE
                    unit_hire_price * quantity * ( end_date - start_date )
            END AS temp
        FROM
            hire
    )
WHERE
    total_hire_price != temp;

/* Update the total_hire_price with the correct totals*/
UPDATE hire
SET
    total_hire_price =
        CASE
            WHEN end_date - start_date = 0 THEN
                unit_hire_price * 0.5 * quantity
            ELSE
                unit_hire_price * quantity * ( end_date - start_date )
        END;

/* Check after cleaning*/
SELECT
    hire_id,
    total_hire_price,
    temp
FROM
    (
        SELECT
            hire_id,
            start_date,
            end_date,
            equipment_id,
            quantity,
            unit_hire_price,
            customer_id,
            staff_id,
            total_hire_price,
            CASE
                WHEN end_date - start_date < 1 THEN
                    unit_hire_price * 0.5 * quantity
                ELSE
                    unit_hire_price * quantity * ( end_date - start_date )
            END AS temp
        FROM
            hire
    )
WHERE
    total_hire_price != temp;


/* Correct Total Sales Prices*/
SELECT
    sales_id,
    total_sales_price,
    quantity * unit_sales_price AS temp2
FROM
    sales
WHERE
    total_sales_price != quantity * unit_sales_price;
/* Discovered that there is a negative Quantity*/
/* Make the negative quantity positive*/
SELECT
    sales_id,
    quantity
FROM
    sales
WHERE
    quantity < 0;

DELETE FROM sales
WHERE
    quantity < 0;
/* Update the total_sales_price with correct calculation of total*/
UPDATE sales
SET
    total_sales_price = quantity * unit_sales_price;

/* Check after cleaning*/
SELECT
    sales_id,
    quantity
FROM
    sales
WHERE
    quantity < 0;

/* Check null values in the tables*/
SELECT
    *
FROM
    category
WHERE
    category_description = 'null';

/* Cleaning null values*/
DELETE FROM category
WHERE
    category_description = 'null';

/* After cleaning check*/
SELECT
    *
FROM
    category
WHERE
    category_description = 'null';

/* check if the dates are after 2023*/
SELECT
    *
FROM
    hire
WHERE
    to_char(start_date, 'YYYY') > 2023
    OR to_char(end_date, 'YYYY') > 2023;

/* Cleaning data*/
DELETE FROM hire
WHERE
    to_char(start_date, 'YYYY') > 2023
    OR to_char(end_date, 'YYYY') > 2023;

/* After cleaning check*/
SELECT
    *
FROM
    hire
WHERE
    to_char(start_date, 'YYYY') > 2023
    OR to_char(end_date, 'YYYY') > 2023;