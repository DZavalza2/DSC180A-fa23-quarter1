#!/bin/bash
# Script to set up a database table in PostgreSQL and perform LCA in R

# PostgreSQL parameters - customize these
DB_USER="your_username"
DB_NAME="your_database"
DB_HOST="localhost" 
DB_PORT="5432"     
DB_PASSWORD=""     

# Path to your SQL script
SQL_SCRIPT_PATH="path/to/your/adjusted_age.sql"

# Path to your R script
R_SCRIPT_PATH="path/to/your/lca.R"

# Check if PostgreSQL is running
if ! pg_isready -q -h $DB_HOST -p $DB_PORT; then
    echo "Error: PostgreSQL server is not running. Please start it before running this script."
    exit 1
fi

# Export database password as an environment variable
export PGPASSWORD=$DB_PASSWORD

# Execute SQL file to create and populate the table
echo "Setting up the database..."
psql -U $DB_USER -d $DB_NAME -h $DB_HOST -p $DB_PORT -f $SQL_SCRIPT_PATH

if [ $? -eq 0 ]; then
    echo "Database setup complete."
else
    echo "Database setup failed."
    exit 1
fi

# Execute the R script for LCA
echo "Running LCA analysis in R..."
Rscript $R_SCRIPT_PATH

if [ $? -eq 0 ]; then
    echo "LCA analysis completed successfully."
else
    echo "LCA analysis failed."
    exit 1
fi

# Cleanup: Unset the database password environment variable
unset PGPASSWORD

echo "Script execution finished."
