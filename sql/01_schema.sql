-- Star Schema DDL for EV Sales Data Warehouse

CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    year INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter VARCHAR(5)
);

CREATE TABLE dim_state (
    state_id INT PRIMARY KEY,
    state VARCHAR(100) NOT NULL,
    region VARCHAR(50)
);

CREATE TABLE dim_vehicle (
    vehicle_id INT PRIMARY KEY,
    vehicle_category VARCHAR(50) NOT NULL
);

CREATE TABLE fact_ev_sales (
    sales_id SERIAL PRIMARY KEY,
    date_id INT REFERENCES dim_date(date_id),
    state_id INT REFERENCES dim_state(state_id),
    vehicle_id INT REFERENCES dim_vehicle(vehicle_id),
    ev_sales_quantity INT NOT NULL
);
