DROP TABLE IF EXISTS raw_bookings;

CREATE TABLE raw_bookings(
    "Date" TEXT,
    "Time" TEXT,
    "Booking ID" TEXT,
    "Booking Status" TEXT,
    "Customer ID" TEXT,
    "Vehicle Type" TEXT,
    "Pickup Location" TEXT,
    "Drop Location" TEXT,
    "Avg VTAT" TEXT,
    "Avg CTAT" TEXT,
    "Cancelled Rides by Customer" TEXT,
    "Reason for cancelling by Customer" TEXT,
    "Cancelled Rides by Driver" TEXT,
    "Driver Cancellation Reason" TEXT,
    "Incomplete Rides" TEXT,
    "Incomplete Rides Reason" TEXT,
    "Booking Value" TEXT,
    "Ride Distance" TEXT,
    "Driver Ratings" TEXT,
    "Customer Rating" TEXT,
    "Payment Method" TEXT
);



-- The raw CSV file (ncr_ride_bookings.csv) was copied directly into PostgreSQL using the \copy command.

psql -U your username -d database_name

-- Then inside psql:

\copy 'Table Name' FROM 'C:\path\to\ncr_ride_bookings.csv' CSV HEADER;


✅ Notes:
The \copy command is used (not COPY) because the CSV file is on the local machine, not the database server.
The CSV HEADER option skips the header row in the file.
The table and CSV must have the same column order.


-- this queries to make sure there is no errors
SELECT
    *
FROM
    raw_bookings
LIMIT 1000;

SELECT
    COUNT(*)
FROM
    raw_bookings