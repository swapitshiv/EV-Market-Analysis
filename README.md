# India EV Market Analytics Dashboard

An end-to-end analytics project analyzing 3.59 million EV sales in India between 2018 and 2023. Data modeled in PostgreSQL using a star schema and visualized via Metabase.

<img width="1920" height="1475" alt="localhost_20260825_181044" src="https://github.com/user-attachments/assets/05671ac4-2d40-4b7d-bd37-0feeb2304cdb" />


## Overview

This project analyzes the transition toward Electric Vehicles (EVs) across Indian states, focusing on category growth rates, geographical sales volume, and seasonality trends.

### Key Insights
- Total EV volume reached 3.59M units with a 5-year CAGR of 73.9% (2019–2023).
- 2-Wheelers overtook 3-Wheelers in 2021 to become the dominant category, currently making up 50.3% of all EV sales.
- Uttar Pradesh leads total registrations with 732K units, followed by Maharashtra (400K+).
- Gujarat and Odisha are the fastest-growing markets, recording CAGRs of 211% and 149% respectively.
- Sales peak annually between November and January during the festive period.

## Data Model

Data is organized into a Star Schema in PostgreSQL:

- fact_ev_sales (sales_id, date_id, state_id, vehicle_id, ev_sales_quantity)
- dim_date (date_id, year, month_name, quarter)
- dim_state (state_id, state, region)
- dim_vehicle (vehicle_id, vehicle_category)

## Core Analysis & SQL

The SQL queries in this project focus on:
- 5-Year CAGR calculation comparing baseline 2019 to 2023.
- Window functions (LAG, OVER) to track Year-over-Year growth percentage.
- Aggregations by vehicle category to capture the 2W vs 3W transition.
- Monthly grouping to identify annual demand peaks.

## Project Structure

- assets/ : Dashboard screenshots and media
- sql/01_schema.sql : Table definitions and schema setup
- sql/02_queries.sql : Analytics queries used for dashboard cards
- README.md : Project documentation

## Setup

1. Create tables using `sql/01_schema.sql` in PostgreSQL.
2. Load the dataset into fact and dimension tables.
3. Connect Metabase to PostgreSQL and run queries from `sql/02_queries.sql`.
"# EV-Market-Analysis" 
