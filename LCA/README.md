# Latent Class Analysis (LCA)

## Brief Introduction
The repository consists of a couple of SQL and R scripts which build process and run LCA. 


The repository is organized and used in the following: <br>
- [adjusted_age.sql](https://github.com/kshannon-ucsd/ucsd-dsc180ab-team1/blob/main/LCA/adjusted_age.sql) - This SQL script preprocesses the MMIC III data to further analyze ICU stays. It computes the length of stay in the ICU and the age of the patients, and filters out patients under teh age of 16. Furthermore, we are only looking at a patients first ICU stay in the case of this SQL script 

- [lca.R](https://github.com/kshannon-ucsd/ucsd-dsc180ab-team1/blob/main/LCA/lca.R) - This R script preforms Laten Class Analysis (LCA) on the preprocessed data returned after using the adjusted_age.sql script. It connects to the database, retrieves patient data joined with age group information and elective admission type, and then process the data to fit an LCA model. Users can adjust the 'nclass' parameter in the poLCA function to change the number of subgroups generated however, for our study we stuck with six subgroups. 

- [SOFA](https://github.com/kshannon-ucsd/ucsd-dsc180ab-team1/tree/main/LCA/SOFA) - This folder contains a series of SQL scripts for creating views, setting up tables to show the SOFA score.

- [setup_and_run_lca.sh](https://github.com/kshannon-ucsd/ucsd-dsc180ab-team1/blob/main/LCA/setup_and_run_lca.sh) - This shell script is created to help set up a database table in PostgreSQL and perform LCA in R. 