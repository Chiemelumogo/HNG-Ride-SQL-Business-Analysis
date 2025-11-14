
-- Creating Tables
CREATE TABLE riders_raw (
    rider_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    signup_date VARCHAR(100) ,
    city VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE drivers_raw (
    driver_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(100),
    signup_date VARCHAR(100),
    rating NUMERIC(3,2)
);

CREATE TABLE rides_raw (
    ride_id SERIAL PRIMARY KEY,
    rider_id INT REFERENCES riders_raw(rider_id),
    driver_id INT REFERENCES drivers_raw(driver_id),
    request_time VARCHAR(100),
    pickup_time VARCHAR(100),
    dropoff_time VARCHAR(100),
    pickup_city VARCHAR(100),
    dropoff_city VARCHAR(100),
    distance_km NUMERIC(10, 2),
    status VARCHAR(50),
    fare NUMERIC(10, 2)
);

CREATE TABLE payments_raw (
    payment_id SERIAL PRIMARY KEY,
    ride_id INT REFERENCES rides_raw(ride_id),
    amount NUMERIC(10, 2),
    method VARCHAR(50),
    paid_date VARCHAR(100)
);


-- Data Cleaning and Preparations
-- Driver_raw
--Checking for Missing Values
SELECT 
    COUNT(*) FILTER (WHERE driver_id IS NULL) AS missing_driver_id,
    COUNT(*) FILTER (WHERE name IS NULL OR name = '') AS missing_name,
    COUNT(*) FILTER (WHERE city IS NULL OR city = '') AS missing_city,
    COUNT(*) FILTER (WHERE signup_date IS NULL) AS missing_signup_date,
    COUNT(*) FILTER (WHERE rating IS NULL) AS missing_rating
FROM drivers_raw;

-- Checking for Duplicates
SELECT driver_id, COUNT(*) 
FROM drivers_raw
GROUP BY driver_id
HAVING COUNT(*) > 1;

-- Trim
UPDATE drivers_raw
SET 
	name = TRIM(name),
	city = TRIM(city),
	signup_date = TRIM(signup_date);


-- Check for unique city
SELECT DISTINCT city 
	FROM drivers_raw 
	ORDER BY city;

-- Correct unique city
UPDATE drivers_raw
SET city = 'Los Angeles'
Where city = 'L.A';


UPDATE drivers_raw
SET city = 'New York'
Where city = 'N.Y';

UPDATE drivers_raw
SET city = 'San Francisco'
Where city = 'S.F';


-- Validate rating Values
SELECT *
FROM drivers_raw
WHERE rating < 1 OR rating > 5;


--Formatting the sigup_date column
-- Creat new column
ALTER TABLE drivers_raw
ADD COLUMN signup_date_ DATE,
ADD COLUMN signup_time TIME;

--Convent and Populate the new column
UPDATE drivers_raw
SET 
    signup_date_ = TO_TIMESTAMP(signup_date, 'MM/DD/YYYY HH24:MI')::DATE,
    signup_time = TO_TIMESTAMP(signup_date, 'MM/DD/YYYY HH24:MI')::TIME;

-- Drop signup_date column
ALTER TABLE drivers_raw
DROP COLUMN signup_date;

ALTER TABLE drivers_raw
RENAME COLUMN signup_date_ TO signup_date;

ALTER TABLE drivers_raw
ALTER COLUMN rating TYPE NUMERIC(2,1);

-- Filter out and create new table for business focus
CREATE TABLE drivers_cleaned AS
SELECT 
    driver_id,
    name,
    city,
    signup_date,
    signup_time,
    rating
FROM drivers_raw
WHERE signup_date BETWEEN '2021-06-01' AND '2024-12-31';


-- Riders_raw
--Checking for Missing Values
SELECT 
    COUNT(*) FILTER (WHERE rider_id IS NULL) AS missing_rider_id,
    COUNT(*) FILTER (WHERE name IS NULL OR name = '') AS missing_name,
    COUNT(*) FILTER (WHERE city IS NULL OR city = '') AS missing_city,
    COUNT(*) FILTER (WHERE signup_date IS NULL) AS missing_signup_date,
    COUNT(*) FILTER (WHERE email IS NULL) AS missing_email
FROM riders_raw;

-- Checking for Duplicates
SELECT rider_id, COUNT(*) 
FROM riders_raw
GROUP BY rider_id
HAVING COUNT(*) > 1;

-- Trim
UPDATE riders_raw
SET 
	name = TRIM(name),
	city = TRIM(city),
	signup_date = TRIM(signup_date);

-- Check for unique city
SELECT DISTINCT city 
	FROM riders_raw 
	ORDER BY city;

-- Correct unique city
UPDATE riders_raw
SET city = 'Los Angeles'
Where city = 'L.A';


UPDATE riders_raw
SET city = 'New York'
Where city = 'N.Y';

UPDATE riders_raw
SET city = 'San Francisco'
Where city = 'S.F';

--Formatting the sigup_date column
-- Creat new column
ALTER TABLE riders_raw
ADD COLUMN signup_date_ DATE,
ADD COLUMN signup_time TIME;

--Convent and Populate the new column
UPDATE riders_raw
SET 
    signup_date_ = TO_TIMESTAMP(signup_date, 'MM/DD/YYYY HH24:MI')::DATE,
    signup_time = TO_TIMESTAMP(signup_date, 'MM/DD/YYYY HH24:MI')::TIME;

-- Drop signup_date column
ALTER TABLE riders_raw
DROP COLUMN signup_date;

ALTER TABLE riders_raw
RENAME COLUMN signup_date_ TO signup_date;


-- Filter out and create new table for business focus
CREATE TABLE riders_cleaned AS
SELECT 
    rider_id,
    name,
    city,
    signup_date,
    signup_time,
    email
FROM riders_raw
WHERE signup_date BETWEEN '2021-06-01' AND '2024-12-31';



-- Rides_raw

--Checking for Missing Values
SELECT 
    COUNT(*) FILTER (WHERE ride_id IS NULL) AS missing_ride_id,
	COUNT(*) FILTER (WHERE rider_id IS NULL) AS missing_rider_id,
	COUNT(*) FILTER (WHERE driver_id IS NULL) AS missing_driver_id,
    COUNT(*) FILTER (WHERE request_time IS NULL) AS missing_request_time,
	COUNT(*) FILTER (WHERE pickup_time IS NULL) AS missing_pickup_time,
	COUNT(*) FILTER (WHERE dropoff_time IS NULL) AS missing_dropoff_time,
    COUNT(*) FILTER (WHERE pickup_city IS NULL OR pickup_city = '') AS missing_pickup_city,
	COUNT(*) FILTER (WHERE dropoff_city IS NULL OR dropoff_city = '') AS missing_dropoff_city,
    COUNT(*) FILTER (WHERE distance_km IS NULL) AS distance_km,
    COUNT(*) FILTER (WHERE status IS NULL) AS missing_status,
	COUNT(*) FILTER (WHERE fare IS NULL) AS missing_fare
FROM rides_raw;

-- Check duplicates
SELECT ride_id, COUNT(*) 
FROM rides_raw
GROUP BY ride_id
HAVING COUNT(*) > 1;

--Trim
UPDATE rides_raw
SET 
	request_time = TRIM(request_time),
	pickup_time = TRIM(pickup_time),
	dropoff_time = TRIM(dropoff_time),
	pickup_city = TRIM(pickup_city),
	dropoff_city = TRIM(dropoff_city),
	status = TRIM(status);

-- Check for unique city (Pickup_city)
SELECT DISTINCT pickup_city
	FROM rides_raw 
	ORDER BY pickup_city

-- Correct unique city
UPDATE rides_raw
SET pickup_city = 'Los Angeles'
Where pickup_city = 'L.A';

UPDATE rides_raw
SET pickup_city = 'New York'
Where pickup_city = 'N.Y';

-- Check for unique city (dropoff_city)
SELECT DISTINCT dropoff_city
	FROM rides_raw 
	ORDER BY dropoff_city

-- Correct unique city
UPDATE rides_raw
SET dropoff_city = 'San Francisco'
Where dropoff_city = 'S.F';

--Formatting the date column
-- Creat new column
ALTER TABLE rides_raw
ADD COLUMN request_date DATE,
ADD COLUMN request_time_ TIME,
ADD COLUMN pickup_date DATE,
ADD COLUMN pickup_time_ TIME,
ADD COLUMN dropoff_date DATE,
ADD COLUMN dropoff_time_ TIME;

--Convent and Populate the new column
UPDATE rides_raw
SET 
    request_date = TO_TIMESTAMP(request_time, 'MM/DD/YYYY HH24:MI')::DATE,
    request_time_ = TO_TIMESTAMP(request_time, 'MM/DD/YYYY HH24:MI')::TIME,
    pickup_date = TO_TIMESTAMP(pickup_time, 'MM/DD/YYYY HH24:MI')::DATE,
    pickup_time_ = TO_TIMESTAMP(pickup_time, 'MM/DD/YYYY HH24:MI')::TIME,
    dropoff_date = TO_TIMESTAMP(dropoff_time, 'MM/DD/YYYY HH24:MI')::DATE,
    dropoff_time_ = TO_TIMESTAMP(dropoff_time, 'MM/DD/YYYY HH24:MI')::TIME;

-- Drop date column
ALTER TABLE rides_raw
DROP COLUMN request_time,
DROP COLUMN	pickup_time,
DROP COLUMN	dropoff_time;

ALTER TABLE rides_raw
RENAME COLUMN request_time_ TO request_time;

ALTER TABLE rides_raw
RENAME COLUMN pickup_time_ TO pickup_time;

ALTER TABLE rides_raw
RENAME COLUMN dropoff_time_ TO dropoff_time;

-- Filter out and create new table for business focus
CREATE TABLE rides_cleaned AS
SELECT 
    ride_id,
	rider_id,
	driver_id,
    pickup_city,
    dropoff_city,
	distance_km,
	status,
	fare,
    request_date,
	request_time,
	pickup_date,
	pickup_time,
	dropoff_date,
	dropoff_time
FROM rides_raw
WHERE request_date BETWEEN '2021-06-01' AND '2024-12-31';


-- payment_raw
--Checking for Missing Values
SELECT 
    COUNT(*) FILTER (WHERE payment_id IS NULL) AS missing_payment_id,
    COUNT(*) FILTER (WHERE ride_id IS NULL) AS missing_ride_id,
    COUNT(*) FILTER (WHERE amount IS NULL) AS missing_amount,
	COUNT(*) FILTER (WHERE method IS NULL) AS missing_method,
    COUNT(*) FILTER (WHERE paid_date IS NULL) AS missing_paid_date
FROM payments_raw;

-- Checking for Duplicates
SELECT payment_id, COUNT(*) 
FROM payments_raw
GROUP BY payment_id
HAVING COUNT(*) > 1;

-- Trim
UPDATE payments_raw
SET 
	method = TRIM(method),
	paid_date = TRIM(paid_date);

-- Check for unique city
SELECT DISTINCT method 
	FROM payments_raw 
	ORDER BY method;

-- Correct unique city
UPDATE payments_raw
SET method = 'paypal'
Where method = 'pay pal';


--Formatting the paid_date column
-- Creat new column
ALTER TABLE payments_raw
ADD COLUMN paid_date_ DATE,
ADD COLUMN paid_time TIME;

--Convent and Populate the new column
UPDATE payments_raw
SET 
    paid_date_ = TO_TIMESTAMP(paid_date, 'MM/DD/YYYY HH24:MI')::DATE,
    paid_time = TO_TIMESTAMP(paid_date, 'MM/DD/YYYY HH24:MI')::TIME;

-- Drop signup_date column
ALTER TABLE payments_raw
DROP COLUMN paid_date;

ALTER TABLE payments_raw
RENAME COLUMN paid_date_ TO paid_date;


-- Filter out and create new table for business focus
CREATE TABLE payments_cleaned AS
SELECT 
    payment_id,
    ride_id,
    amount,
	method,
    paid_date,
    paid_time
FROM payments_raw
WHERE paid_date BETWEEN '2021-06-01' AND '2024-12-31';

