-- Dimensional Tables for Star Schema

-- 01) Dimension: dim_date

DROP TABLE IF EXISTS dim_date;
CREATE TABLE dim_date(
    date_sk BIGINT GENERATED AlWAYS AS IDENTITY PRIMARY KEY,
    full_date DATE,
    year INT,
    month INT,
    day INT,
    weekday TEXT,
    quarter INT
);

INSERT INTO dim_date (full_date, year, month, day, weekday, quarter)
SELECT DISTINCT
    booking_date ::DATE AS full_date,
    EXTRACT(YEAR FROM booking_date)::INT AS year,
    EXTRACT(MONTH FROM booking_date)::INT AS month,
    EXTRACT(day FROM booking_date)::INT AS day,
    TRIM(TO_CHAR(booking_date::DATE, 'day')) AS weekday,
    EXTRACT(QUARTER FROM booking_date) AS quarter
FROM
    stg_booking
WHERE
    booking_date IS NOT NULL
ORDER BY
    full_date;

-- 02) Dimension: dim_customer    

DROP TABLE IF EXISTS dim_customer;

CREATE TABLE dim_customer(
    customer_sk INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id TEXT UNIQUE,
    total_rides INT,
    first_booking_date DATE,
    last_booking_date DATE,
    avg_booking_value NUMERIC (12,2),
    avg_customer_rating NUMERIC (5,2)
);

INSERT INTO dim_customer (customer_id, total_rides, first_booking_date, last_booking_date, avg_booking_value, avg_customer_rating)
SELECT
    customer_id,
    COUNT(*)::INT AS total_rides,
    MIN(booking_date)::DATE AS first_booking_date,
    MAX(booking_date)::DATE AS last_booking_date,
    ROUND(AVG(booking_value)::NUMERIC, 2) AS avg_booking_value,
    ROUND(AVG(customer_rating)::NUMERIC, 2) AS avg_customer_rating
FROM
    stg_booking
WHERE
    customer_id IS NOT NULL
GROUP BY
    customer_id
ORDER BY
customer_id;


-- 03) Dimension: dim_location
-- Creation of Dim_location Table using subqueries

DROP TABLE IF EXISTS dim_location;

CREATE TABLE dim_location (
    location_sk INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location_name TEXT UNIQUE,
    pickup_count INT,
    drop_count INT,
    total_appearances INT
);

INSERT INTO dim_location (location_name, pickup_count, drop_count, total_appearances)
SELECT
    location_name,
    SUM(pickup_flag)::INT,
    SUM(drop_flag)::INT,
    (SUM(pickup_flag) + SUM(drop_flag))::INT
FROM (
    SELECT pickup_location AS location_name, 1 AS pickup_flag, 0 AS drop_flag
    FROM stg_booking WHERE pickup_location IS NOT NULL

    UNION ALL

    SELECT drop_location AS location_name, 0 AS pickup_flag, 1 AS drop_flag
    FROM stg_booking WHERE drop_location IS NOT NULL
) x
GROUP BY 
    location_name
ORDER BY
    location_name



-- Creation of Dim_location Table using CTEs

DROP TABLE IF EXISTS dim_location;

CREATE TABLE dim_location (
    location_sk INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location_name TEXT UNIQUE,
    pickup_count INT,
    drop_location INT,
    total_appearances INT
);

INSERT INTO (location_name, pickup_count, drop_count, total_appearances)
WITH all_locations AS (
    SELECT
        pickup_location AS location_name,
        1 AS pickup_flag,
        0 AS drop_flag
    FROM stg_booking
    WHERE pickup_location IS NOT NULL

    UNION ALL

    SELECT
        drop_location AS location_name,
        0 AS pickup_flag,
        1 AS drop_flag
    FROM stg_booking
    WHERE drop_location IS NOT NULL
) 

SELECT
    location_name,
    SUM(pickup_flag)::INT,
    SUM(drop_flag)::INT,
    (SUM(pickup_flag) + SUM(drop_flag))::INT
FROM
    all_locations
GROUP BY
    location_name
ORDER BY
    location_name;


-- 04) Dimension: dim_vehicle

DROP TABLE IF EXISTS dim_vehicle;

CREATE TABLE dim_vehicle (
  vehicle_sk INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  vehicle_type TEXT UNIQUE,
  usage_count INT
);

INSERT INTO dim_vehicle (vehicle_type, usage_count)
SELECT
  COALESCE(vehicle_type, 'Unknown') AS vehicle_type,
  COUNT(*)::INT AS usage_count
FROM stg_booking
GROUP BY COALESCE(vehicle_type, 'Unknown')
ORDER BY vehicle_type;

-- 05) Dimension: dim_payment_method (this one is cleaned and checked many times)

DROP TABLE IF EXISTS dim_payment_method;

CREATE TABLE dim_payment_method(
    payment_sk INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    payment_method TEXT UNIQUE,
    usage_count INT
);

INSERT INTO dim_payment_method (payment_method, usage_count)
SELECT
    TRIM(payment_method) AS payment_method,
    COUNT(*)::INT AS usage_count
FROM stg_booking
WHERE payment_method IS NOT NULL
  AND TRIM(payment_method) <> ''
  AND LOWER(TRIM(payment_method)) <> 'null'
  AND cancelled_by_customer = 0
  AND cancelled_by_driver = 0
  AND booking_status <> 'No driver found'
GROUP BY TRIM(payment_method)
ORDER BY payment_method;

-- 06) Dimension: dim_cancel_reason

DROP TABLE IF EXISTS dim_cancel_reason;

CREATE TABLE dim_cancel_reason(
    cancel_reason_sk INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cancel_reason TEXT NOT NULL,
    cancel_by TEXT CHECK (cancel_by IN ('Customer', 'Driver')),
    UNIQUE (cancel_reason, cancel_by)
);

INSERT INTO dim_cancel_reason (cancel_reason, cancel_by)
SELECT DISTINCT
    cancel_reason_customer AS cancel_reason,
    'Customer' AS cancel_by
FROM
    stg_booking
WHERE
    cancel_reason_customer IS NOT NULL

UNION ALL

SELECT DISTINCT
    cancel_reason_driver AS cancel_reason,
    'Driver' AS cancel_by
FROM
    stg_booking
WHERE
    cancel_reason_driver IS NOT NULL


-- Fact Table: fact_bookings

DROP TABLE IF EXISTS fact_bookings;

CREATE TABLE fact_bookings(
    trip_sk                   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id                TEXT,
    date_sk                   INT REFERENCES dim_date(date_sk),
    customer_sk               INT REFERENCES dim_customer(customer_sk),
    pickup_location_sk        INT REFERENCES dim_location(location_sk),
    drop_location_sk          INT REFERENCES dim_location(location_sk),
    vehicle_sk                INT REFERENCES dim_vehicle(vehicle_sk),
    payment_sk                INT REFERENCES dim_payment_method(payment_sk),
    customer_cancel_reason_sk INT REFERENCES dim_cancel_reason(cancel_reason_sk),
    driver_cancel_reason_sk   INT REFERENCES dim_cancel_reason(cancel_reason_sk),

    booking_time              TIME,
    booking_status            TEXT,
    avg_vtat                  NUMERIC(8,2),
    avg_ctat                  NUMERIC(8,2),
    cancelled_by_customer     INT,
    cancelled_by_driver       INT,
    incomplete_rides          INT,
    incomplete_reason         TEXT,
    booking_value             NUMERIC(12,2),
    fare_usd                  NUMERIC(12,2),
    ride_distance             NUMERIC(12,2),
    driver_rating             NUMERIC(5,2),
    customer_rating           NUMERIC(5,2)
);

INSERT INTO fact_bookings (
    booking_id, date_sk, customer_sk, pickup_location_sk,
    drop_location_sk, vehicle_sk, payment_sk, customer_cancel_reason_sk, driver_cancel_reason_sk,
    booking_time, booking_status, avg_vtat, avg_ctat,
    cancelled_by_customer, cancelled_by_driver,incomplete_rides, incomplete_reason,
    booking_value, fare_usd, ride_distance, driver_rating, customer_rating
)

SELECT
    s.booking_id,
    d.date_sk,
    c.customer_sk,
    pl.location_sk AS pickup_location_sk,
    dl.location_sk AS drop_location_sk,
    v.vehicle_sk,
    p.payment_sk,
    ccr.cancel_reason_sk AS customer_cancel_reason_sk,
    dcr.cancel_reason_sk AS driver_cancel_reason_sk,

    s.booking_time,           
    s.booking_status,         
    s.avg_vtat,               
    s.avg_ctat,               
    s.cancelled_by_customer,  
    s.cancelled_by_driver,    
    s.incomplete_rides,       
    s.incomplete_reason,      
    s.booking_value,          
    s.fare_usd,               
    s.ride_distance,          
    s.driver_rating,          
    s.customer_rating
FROM
    stg_booking s



LEFT JOIN dim_date d ON s.booking_date = d.full_date
LEFT JOIN dim_customer c ON s.customer_id = c.customer_id
LEFT JOIN dim_location pl ON s.pickup_location = pl.location_name
LEFT JOIN dim_location dl ON s.drop_location = dl.location_name
LEFT JOIN dim_vehicle v ON COALESCE(s.vehicle_type, 'Unknown') = v.vehicle_type
LEFT JOIN dim_payment_method p ON COALESCE(s.payment_method, 'Not mentioned') = p.payment_method  
LEFT JOIN dim_cancel_reason ccr
    ON s.cancel_reason_customer = ccr.cancel_reason
   AND ccr.cancel_by = 'Customer'

LEFT JOIN dim_cancel_reason dcr
    ON s.cancel_reason_driver = dcr.cancel_reason
   AND dcr.cancel_by = 'Driver'
WHERE s.booking_id IS NOT NULL
ORDER BY s.booking_id;

