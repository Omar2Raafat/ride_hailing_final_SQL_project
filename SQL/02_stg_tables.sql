DROP TABLE IF EXISTS stg_booking;

-- Create staging table by transforming raw_bookings
CREATE TABLE stg_booking AS
SELECT
    -- Convert date text → proper DATE
    TO_DATE("Date", 'YYYY-MM-DD') AS booking_date,

    -- Convert "12:29:38 PM" → TIME
    TO_TIMESTAMP("Time", 'HH24:MI:SS')::TIME AS booking_time,

    -- Booking ID stays as text (unique identifier)
    "Booking ID" AS booking_id,

    -- Keep booking status as text
    "Booking Status" AS booking_status,

    -- Customer ID as text for now (will later be a foreign key in dim_customer)
    "Customer ID" AS Customer_id,

    -- Vehicle type (bike, car, auto, etc.)
    "Vehicle Type" AS vehicle_type,

    -- Pickup & drop locations as text (later → dim_location)
    "Pickup Location" AS pickup_location,
    "Drop Location" AS drop_location,

    -- Numbers: use NULLIF to handle empty strings ("") → convert to NULL
    NULLIF(NULLIF("Avg VTAT", 'null'), '')::NUMERIC AS avg_vtat,
    NULLIF(NULLIF("Avg CTAT", 'null'), '')::NUMERIC AS avg_ctat,

    -- Cancelled by customer flag
    CASE
        WHEN "Cancelled Rides by Customer" = '1' THEN 1
        ELSE NULL
    END AS cancelled_by_customer,

    -- Only store reason if the ride was cancelled by customer
    CASE
        WHEN "Cancelled Rides by Customer" = '1'
        THEN NULLIF(NULLIF("Reason for cancelling by Customer", 'null'), '')
        ELSE NULL
    END AS cancel_reason_customer,

    -- Cancelled by driver flag
    CASE
        WHEN "Cancelled Rides by Driver" = '1' THEN 1
        ELSE NULL
    END AS cancelled_by_driver,

    -- Only store reason if the ride was cancelled by driver
    CASE
        WHEN "Cancelled Rides by Driver" = '1'
        THEN NULLIF(NULLIF("Driver Cancellation Reason", 'null'), '')
        ELSE NULL
    END AS cancel_reason_driver,

    -- Incomplete rides flag
    CASE 
        WHEN "Incomplete Rides" = '1' THEN 1 
        ELSE NULL
    END AS incomplete_rides,

    -- Only store reason if the ride was Incomplete
    CASE
        WHEN "Incomplete Rides" = '1'
        THEN NULLIF(NULLIF("Incomplete Rides Reason", 'null'), '')
        ELSE NULL
    END AS incomplete_reason,

    -- Booking value and ride distance
    NULLIF(NULLIF("Booking Value", 'null'), '')::NUMERIC AS booking_value,
    NULLIF(NULLIF("Ride Distance", 'null'), '')::NUMERIC AS ride_distance,

    -- Payment method (text) and ratings (numeric)
    NULLIF(NULLIF("Driver Ratings", 'null'), '')::NUMERIC AS driver_rating,
    NULLIF(NULLIF("Customer Rating", 'null'), '')::NUMERIC AS customer_rating,

    CASE
    WHEN "Booking Status" = 'Completed' 
         OR "Booking Status" = 'Incomplete'
    THEN
        CASE
            WHEN "Payment Method" IS NULL OR TRIM("Payment Method")='' THEN 'Not Mentioned'
            ELSE "Payment Method"
        END

    WHEN "Booking Status" LIKE '%Cancel%' THEN NULL
    END AS payment_method
    

FROM raw_bookings;

 
-- Added fare_usd column to store ride value converted from INR to USD.
-- This makes analysis easier and consistent when comparing costs internationally,
-- since the original booking_value is in Indian Rupees.
ALTER TABLE stg_booking
ADD COLUMN fare_usd NUMERIC (12,2);

UPDATE stg_booking
SET fare_usd = stg_booking.booking_value * 0.012;

-- Conversion rate used: 1 INR ≈ 0.012 USD (approximate).
-- Keeping both INR (booking_value) and USD (fare_usd) for flexibility.


-- Run this query to make sure everything is working
SELECT
    *
FROM    
    stg_booking
LIMIT 100;