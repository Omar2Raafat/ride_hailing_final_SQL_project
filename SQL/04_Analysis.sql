-- 🟢 LEVEL 1 — BASIC ANALYSIS

-- 1️⃣ How many total rides were completed?

SELECT
    COUNT(*) AS total_completed_rides
FROM
    fact_bookings
WHERE
    booking_status = 'Completed';

-- 2️⃣ Total revenue (INR & USD)

SELECT
    ROUND(SUM(booking_value), 2) AS total_revenue_inr,
    ROUND(SUM(fare_usd), 2) AS total_revenue_usd
FROM
    fact_bookings
WHERE
    booking_status = 'Completed';

-- 3️⃣ Average ride distance and fare

SELECT
    ROUND(AVG(ride_distance), 2) AS avg_distance,
    ROUND(AVG(booking_value), 2) AS avg_fare
FROM
    fact_bookings
WHERE
    booking_status = 'Completed';
--=================================================================================
-- 🟡 LEVEL 2 — USING DIMENSIONS
-- 4️⃣ Rides by day of week (📅 dim_date) in this query A ride = a booking attempt
SELECT
    d.weekday,
    COUNT(*) AS total_rides
FROM
    fact_bookings fb
JOIN dim_date d ON fb.date_sk = d.date_sk
GROUP BY
    d.weekday
ORDER BY
    total_rides DESC;



-- 5️⃣ Monthly revenue trend (📅 dim_date)
SELECT
    dd.month,
    ROUND(SUM(f.booking_value), 0) AS monthly_revenue_inr,
    ROUND(SUM(f.fare_usd), 2) AS monthly_revenue_usd
FROM
    fact_bookings f
JOIN dim_date dd ON f.date_sk = dd.date_sk
WHERE
    booking_status = 'Completed'
GROUP BY
    dd.month
ORDER BY
    dd.month


-- 6️⃣ Most used vehicle types (🚗 dim_vehicle)
SELECT
    v.vehicle_type,
    COUNT(*) AS total_rides
FROM fact_bookings f
JOIN dim_vehicle v ON f.vehicle_sk = v.vehicle_sk
GROUP BY v.vehicle_type
ORDER BY total_rides DESC;

-- 7️⃣ Revenue by vehicle type
SELECT
    v.vehicle_type,
    ROUND(SUM(f.booking_value), 0) AS revenue_inr,
    ROUND(SUM(f.fare_usd), 2) AS revenue_usd
FROM fact_bookings f
JOIN dim_vehicle v ON f.vehicle_sk = v.vehicle_sk
WHERE f.booking_status = 'Completed'
GROUP BY v.vehicle_type
ORDER BY revenue DESC;
--=================================================================================
--🟠 LEVEL 3 — CANCELLATION & BEHAVIOR ANALYSIS (Strong Section)
--8️⃣ Cancellation rate (customer vs driver)

WITH totals AS (
    SELECT
        COUNT(*) AS total_count
    FROM
        fact_bookings
)

SELECT
    'Cancelled_by_Customer' AS outcome,
    COUNT(*) AS count,
    CONCAT(
            ROUND(100 * COUNT(*) / (SELECT total_count FROM totals), 2), '%'
    ) AS percentage
FROM
    fact_bookings
WHERE
    cancelled_by_customer = 1

UNION ALL

SELECT
    'Cancelled_by_Driver',
    COUNT(*) AS count,
    CONCAT(
            ROUND(100 * COUNT(*) / (SELECT total_count FROM totals), 2), '%'
    ) AS percentage
FROM
    fact_bookings
WHERE
    cancelled_by_driver = 1 ;

-- 9️⃣ Booking Outcomes Distribution (with Percentages)
WITH totals AS (
    SELECT COUNT(*) AS total_bookings
    FROM fact_bookings
)

SELECT
    'Completed' AS outcome,
    COUNT(*) AS count,
    CONCAT(
        ROUND(100.0 * COUNT(*) / (SELECT total_bookings FROM totals), 2),
        '%'
    ) AS percentage
FROM fact_bookings
WHERE booking_status = 'Completed'

UNION ALL

SELECT
    'Cancelled by Customer',
    COUNT(*),
    CONCAT(
        ROUND(100.0 * COUNT(*) / (SELECT total_bookings FROM totals), 2),
        '%'
    )
FROM fact_bookings
WHERE cancelled_by_customer = 1

UNION ALL

SELECT
    'Cancelled by Driver',
    COUNT(*),
    CONCAT(
        ROUND(100.0 * COUNT(*) / (SELECT total_bookings FROM totals), 2),
        '%'
    )
FROM fact_bookings
WHERE cancelled_by_driver = 1

UNION ALL

SELECT
    'Incomplete Rides',
    COUNT(*),
    CONCAT(
        ROUND(100.0 * COUNT(*) / (SELECT total_bookings FROM totals), 2),
        '%'
    )
FROM fact_bookings
WHERE incomplete_rides = 1

UNION ALL

SELECT
    'Driver Not Found',
    COUNT(*),
    CONCAT(
        ROUND(100.0 * COUNT(*) / (SELECT total_bookings FROM totals), 2),
        '%'
    )
FROM fact_bookings
WHERE booking_status = 'No Driver Found';

-- 🔟 Top customer cancellation reasons (❌ dim_cancel_reason)
SELECT
    cr.cancel_reason,
    COUNT(*) AS total_cancellations
FROM fact_bookings f
JOIN dim_cancel_reason cr
    ON f.customer_cancel_reason_sk = cr.cancel_reason_sk
GROUP BY cr.cancel_reason
ORDER BY total_cancellations DESC;

--1️⃣1️⃣ Top driver cancellation reasons (❌ dim_cancel_reason)
SELECT
    cr.cancel_reason,
    COUNT(*) AS total_cancellations
FROM fact_bookings f
JOIN dim_cancel_reason cr
    ON f.driver_cancel_reason_sk = cr.cancel_reason_sk
GROUP BY cr.cancel_reason
ORDER BY total_cancellations DESC;
--=================================================================================
--🔵 LEVEL 4 — LOCATION & CUSTOMER INSIGHTS (Moderate)
--1️⃣2️⃣ Most popular pickup locations (📍 dim_location)
SELECT
    l.location_name,
    COUNT(*) AS total_pickups
FROM fact_bookings f
JOIN dim_location l ON f.pickup_location_sk = l.location_sk
GROUP BY l.location_name
ORDER BY total_pickups DESC
LIMIT 10;

--1️⃣3️⃣ Most profitable pickup locations
SELECT
    l.location_name,
    ROUND(SUM(f.booking_value), 0) AS revenue
FROM fact_bookings f
JOIN dim_location l ON f.pickup_location_sk = l.location_sk
WHERE f.booking_status = 'Completed'
GROUP BY l.location_name
ORDER BY revenue DESC
LIMIT 10;

--1️⃣4️⃣ Repeat customers (👤 dim_customer)
SELECT
    customer_id,
    COUNT(*) AS total_rides
FROM fact_bookings f
JOIN dim_customer c ON f.customer_sk = c.customer_sk
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY total_rides DESC;
--=================================================================================
--🟣 LEVEL 5 — PAYMENT ANALYSIS (Optional but Nice)
--1️⃣5️⃣ Payment method usage (💳 dim_payment_method)
SELECT
    p.payment_method,
    COUNT(*) AS total_rides
FROM fact_bookings f
JOIN dim_payment_method p ON f.payment_sk = p.payment_sk
GROUP BY p.payment_method
ORDER BY total_rides DESC;

--1️⃣6️⃣ Revenue by payment method
SELECT
    p.payment_method,
    SUM(f.booking_value) AS revenue
FROM fact_bookings f
JOIN dim_payment_method p ON f.payment_sk = p.payment_sk
WHERE f.booking_status = 'Completed'
GROUP BY p.payment_method
ORDER BY revenue DESC;


