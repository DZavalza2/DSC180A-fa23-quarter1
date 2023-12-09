#!/bin/bash

# Define database connection parameters
DB_NAME="your_database_name"
DB_USER="your_username"
DB_HOST="your_host"
DB_PORT="your_port" # Default PostgreSQL port is 5432

# Directory where all SQL files are located
SQL_DIR="/path/to/your/sql/files"

# Change to the directory where SQL files are located
cd "$SQL_DIR"

# List of SQL files to be executed in the specified order
SQL_FILES=(
    "urine-output-first-day.sql"
    "vitals-first-day.sql"
    "gcs-first-day.sql"
    "labs-first-day.sql"
    "blood-gas-first-day-arterial.sql"
    "echo-data.sql"
    "ventilation_durations.sql"
    "SOFA.sql" # Including SOFA.sql in the list
)

# Run each SQL file
for sql_file in "${SQL_FILES[@]}"; do
    echo "Running $sql_file..."
    psql -d "$DB_NAME" -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -f "$sql_file"
done

echo "All scripts executed successfully."
