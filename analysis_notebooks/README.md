# Analysis Notebooks 

## Brief Introduction
The repository consists of the main analyses we performed in our study which consisted of K-Means and a Network Analysis. 

The repository is organized and used in the following:<br>
- [Means_class.py](https://github.com/kshannon-ucsd/ucsd-dsc180ab-team1/blob/main/analysis_notebooks/K_Means_class.py) - This python file allows you to input the results from your LCA and find three main clusters in your MMIC III data. The first will contain all the dieases which have a higher prevalance in younger age groups than in older  age groups. Another will contains all the diseases which have a generally lower prevalence throughout all age groups (typically between 0% - 3%). The third will contain diseases that are more prevalent with age. 

- [network_analysis.py](https://github.com/kshannon-ucsd/ucsd-dsc180ab-team1/blob/main/analysis_notebooks/network_analysis.py) - This python file allows you to input your results from your LCA and output a network graph. The newtork graph uses Relative Risk in order to calculate the prevalence given two different dieases. In the result, the node size is based on the number of patients with that specific disease in that age group. The edge width represents the relative risk, thicker edges means a higher relative risk.

