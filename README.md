# Capstone Project for DSC180AB - UCSD Fall 2023

## Overview

This repository hosts the capstone project for the DSC180AB class at the University of California, San Diego (UCSD), Fall 2023. The project's goal is to replicate and extend the analysis conducted in the article "Multimorbidity states associated with higher mortality rates in organ dysfunction and sepsis: a data-driven analysis in critical care" by Zador et al.

## Contributors

- Colin Tran: ctt005@ucsd.edu
- Zhuji (Jerry) Zhang: zhz044@ucsd.edu
- Diego Zavalza: dzavalza@ucsd.edu
- Asif Mahdin: amahdin@ucsd.edu

Mentored by Professor Kyle Shannon: kshannon@ucsd.edu

## Purpose

The capstone project aims to apply data science techniques to critical care data, specifically focusing on multimorbidity states in organ dysfunction and sepsis. By replicating the study from Zador et al., we intend to validate the findings and potentially uncover new insights through the application of Latent Class Analysis (LCA) and other machine learning methods.

## Getting Started

### Accessing the Data

To access the MIMIC-III database:

1. Complete an approved course from CITI Training Courses: https://physionet.org/about/citi-course/ 
2. Upload your passing certificate to [PhysioNet](https://physionet.org/) and apply for access to the database.
3. Once approved, you will gain access to all files in the MIMIC-III database.

### Setting Up the Database

Set up the MIMIC-III database in pgAdmin by following the tutorial provided by the MIT Laboratory for Computational Physiology: [Setting up MIMIC-III in a local Postgres database](https://github.com/MIT-LCP/mimic-code/blob/main/mimic-iii/buildmimic/postgres/README.md).

### Data Preparation

Loading Data into the Local Database

After downloading the data files from the MIMIC-III database, place them in the raw_data folder in this repository.
The raw_data folder is structured to organize the data as downloaded from MIMIC-III. This helps in maintaining consistency and ease of access for further processing.
Ensure that the file structure within raw_data matches what the processing scripts expect. For instance, if the scripts expect certain CSV files, place those files directly in the raw_data folder.
If there are specific naming conventions or directory structures that need to be followed for the raw data files, specify them here.

### Data Processing

The processed_data folder contains scripts for preprocessing the raw data from MIMIC-III.
Run the scripts in the following order to prepare your data for analysis:

### Running the Analysis

### Running the Analysis using Docker
Ensure you have Docker installed on your machine. Follow these steps to set up and run the project using Docker:

1. Build the Docker Image:
- Open a terminal and navigate to the project's root directory.
- Run the following command to build the Docker image: docker build -t capstone .
2. Run the Docker Container:
- Once the image is built, start a container using: docker run -it --name capstone_container capstone
3. Accessing the Container:
- To interact with the container, open a new terminal window and run: docker exec -it capstone_container /bin/bash
4. You can now run scripts and notebooks within the container's environment.
- Remember to replace capstone with your chosen image name if different.


# Exploratory Data Analysis (EDA)
The repository consists of our team's Exploratory Data Anlysis which was performed in the beginning of our project timeline. See the eda_notebooks for more details.

To run the Exploratory Data Analysis (EDA) for this project, we have provided a shell script that automates the process of executing the Jupyter notebooks and handling data files.

1. **Navigate to the EDA Folder**:
Change into the `eda_notebooks` directory:
```sh
cd ucsd-dsc180ab-team1/eda_notebooks
```

2. **Make the Shell Script Executable**:
Before running the script, make sure it is executable by running the following command:
```sh
chmod +x run_analysis.sh
```

3. **Run the Shell Script**:
Execute the shell script by typing:
```sh
./run_analysis.sh
```

This script will activate the Docker environment, run the `01_summary_statistics_with_graphs.ipynb` Jupyter notebook, and handle all the necessary CSV files for the analysis.

After the script completes, you can find the output of the analysis within the same `eda_notebooks` directory.


# Latent Class Analysis:
Latent Class Analysis in this project is used to identify the subgroups used in our analysis. Look at the LCA folder about more details.
### Instructions to run LCA
1. **Navigate to the LCA folder:**
cd ucsd-dsc180ab-team1/eda_notebooks
2. **Run the LCA**:
    ```sh
    cd ucsd-dsc180ab-team1/LCA
    ```
   Make sure the script is executable:

    ```sh
    chmod +x setup_and_run_lca.sh
    ```
    
    The script will run the analysis and save the results.
   
    ```sh
    ./setup_and_run_lca.sh
    ```
# Analysis Notebooks
The repository consists of the main analyses we performed in our study which consisted of K-Means and a Network Analysis. Look into the analysis_notebooks folder for more details.
### Instructions Analysis Notebooks
1. **Navigate to the Analysis Notebooks Directory**:

    Change your current working directory to `analysis_notebooks`:

    ```sh
    cd ucsd-dsc180ab-team1/analysis_notebooks
    ```

2. **Make the Script Executable**:

    Before running the script, ensure it has the necessary permissions:

    ```sh
    chmod +x run_notebooks.sh
    ```

3. **Execute the Shell Script**:

    Run the shell script which will execute the Jupyter notebooks:

    ```sh
    ./run_notebooks.sh
    ```

    The script will start Jupyter, run all notebooks, and save the output.

### Output

The executed notebooks will be saved with their outputs in this directory, allowing for review and analysis.






