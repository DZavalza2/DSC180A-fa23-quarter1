
# SQL Scripts Folder README

## Overview

This folder contains a series of SQL scripts that are designed to set up and manipulate your database. These scripts include creating views, setting up tables to show the SOFA score.

## List of SQL Scripts

- `urine-output-first-day.sql` - Script to create and populate `urine_output_first_day` view.
- `vitals-first-day.sql` - Script to create and populate `vitals_first_day` view.
- `gcs-first-day.sql` - Script to create and populate `gcs_first_day` view.
- `labs-first-day.sql` - Script to create and populate `labs_first_day` view.
- `blood-gas-first-day-arterial.sql` - Script to create and populate `blood_gas_first_day_arterial` view.
- `echo-data.sql` - Script to create and populate `echodata` view.
- `ventilation_durations.sql` - Script to create and populate `ventilation_durations` view.
- `SOFA.sql` - Main script that utilizes the above views.

## Prerequisites

- PostgreSQL database server.
- User with sufficient privileges to execute SQL scripts.
- `psql` command-line tool or a similar PostgreSQL client.

## Running the Scripts

1. Ensure all scripts are in the same directory.
2. Update the `run_sql_files.sh` shell script with your database connection details.
3. Give execute permission to the shell script: `chmod +x run_sql_files.sh`.
4. Run the script: `./run_sql_files.sh`.

## Important Notes

- It's recommended to take a backup of your database before running these scripts, especially in a production environment.
- Modify the database connection details in the shell script according to your environment.
