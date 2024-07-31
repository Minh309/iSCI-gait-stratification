# iSCI-gait-stratification
This is the repository for the study: "Gait pattern stratification in persons with incomplete spinal cord injury: A data-driven approach".

The codes consists of two parts: 

PART 1: Gait stratification with DTW and HAC

This part is run in Matlab (Tested version: 2021b). Please go to folder: Clustering methods and run file main.m to reproduce the results in the paper. You need to install Statistics and Machine Learning Toolbox to run the code. 
Moreover, the clusters' color were automatically defined with Maximally Distinct Color Generator: 

Stephen23 (2024). Maximally Distinct Color Generator (https://www.mathworks.com/matlabcentral/fileexchange/70215-maximally-distinct-color-generator), MATLAB Central File Exchange. Retrieved July 29, 2024.

PART 2: Identification of gait predictors for each cluster with Random Forest Classifier and TreeSHAP 

This part is run with Jupyter Notebook. Please go to folder: Random Forest with TreeSHAP to reproduce the results. You need to install several packages to run the code: pandas, matplotlib, pickle, shap, numpy, statistics, sklearn, collections, imblearn. 


