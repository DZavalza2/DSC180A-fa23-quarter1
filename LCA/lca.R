# This R script performs Latent Class Analysis (LCA) on patient data 
#from the MIMIC-III database. It connects to the database,
# retrieves patient data joined with age group information and elective 
#admission type, and then processes the data to fit an LCA model.
# Users can adjust the 'nclass' parameter in the poLCA function to 
#change the number of subgroups generated.


# Define connection parameters
library(RPostgreSQL)
library(poLCA)

drv <- dbDriver("PostgreSQL")
conn <- dbConnect(drv, dbname="mimic3", host="localhost", user="colintran")

# Query to extract only the required columns
query <- "SELECT
    e.*, -- Select all columns from the Elixhauser table
    a.age, -- Select the age column from the Adjusted_age table
    et.admission_type -- Select the one-hot encoded admission_type column from the elective_type table
FROM
    (SELECT * FROM Elixhauser WHERE subject_id IN (SELECT subject_id FROM Adjusted_age)) e
JOIN
    elective_type et ON e.subject_id = et.subject_id
JOIN
    Adjusted_age a ON e.subject_id = a.subject_id;"

merged_data <- dbGetQuery(conn, query)

# Exclude first 2 columns: subject_id and hadm_id
columns_to_process <- 3:ncol(merged_data)

# Find variables with only one level
for(var in names(merged_data)[columns_to_process]) {
  if(length(unique(merged_data[[var]])) == 1) {
    cat("Variable", var, "has only one level and will be removed.\n")
    columns_to_process <- columns_to_process[columns_to_process != which(names(merged_data) == var)]
  }
}

# Convert the selected columns to numeric and then to factor
merged_data[, columns_to_process] <- lapply(merged_data[, columns_to_process], function(x) as.factor(as.numeric(as.character(x))))

# Verify that the selected columns are now factors
sapply(merged_data[, columns_to_process], class)  # Should return 'factor' for all selected columns


# Create the formula by including only the variable names from the selected columns
variable_names <- names(merged_data)[columns_to_process]
lca_formula <- as.formula(paste("cbind(", paste(variable_names, collapse = ", "), ") ~ 1"))

# Fit the LCA model with the selected variables
lca_fit <- poLCA(lca_formula, data = merged_data[, c(1, 2, columns_to_process)], nclass = 6)

# Print the results
print(lca_fit)

# close connection
dbDisconnect(conn)

# Extract the most likely class for each observation
merged_data$subgroup <- apply(lca_fit$posterior, 1, which.max)

# Calculate counts for each subgroup
subgroup_counts <- table(merged_data$subgroup)

# Create a data frame for counts and percentages
subgroup_summary <- data.frame(Subgroup = names(subgroup_counts),
  Count = as.numeric(subgroup_counts),
  Percentage = as.numeric(subgroup_counts) / sum(subgroup_counts) * 100)

# Output the subgroup summary to a CSV file
write.csv(subgroup_summary, "subgroup_summary.csv", row.names = FALSE)

# Export each subgroup to a separate CSV
for(i in 1:6) {
  subgroup_data <- merged_data[merged_data$subgroup == i, ]
  write.csv(subgroup_data, sprintf("subgroup_%d.csv", i), row.names = FALSE)
}



