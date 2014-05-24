Tidy-Data-Assignment
====================

Assignment to Create Tidy Data Set from Samsung Galaxy

This document contains the overview and instructions for constructing the tidy data set

## Overview of the Data Merging, Cleaning and Aggregation  

### Source Data Tables
The program run_analysis.R assumes that the user will have a foder titled "UCI HAR Dataset"
in their current working directory.  If that directory is not present but the zip file 
"getdata_projectfiles_UCI HAR Dataset.zip" is in the current working directory, the program will 
unzip this file and create the subdirectories test and train.  

The data chosen for analysis comes from the following files,

#### From the UCI HAR folder
* features.txt  - this contains the full list of variable names in the test and train set from which the means
will be calculated.    

#### From the test subdirectory
subject_text.txt - this contains the subject IDs
* X_test.txt - this contains the full set of summarised test subject observations, assumed to be in the same order
* Y_text.txt - this contains the activity codes (1-6) for each test subject, also asumed to be in the same order
#### From the train  subdirectory
* subject_text.txt - this contains the subject IDs
* X_train .txt - this contains the full set of summarised train  subject observations, assumed to be in the same order
* Y_text.txt - this contains the activity codes (1-6) for each train  subject, also asumed to be in the same.

Because the more detailed information in the inertial signals folder is summarised in the test and train files, 
this data is not incorporated into the construction of the tidy data set.

### Renaming of Variables

The very lengthy variable names have been shortened based on the following principles,
* Removal of brackets (), - from names
* conversion of variable names from upper to lower case
* removal of inconsistencies in naming conventions - "bodybody" replaced with "body"
* removal of unnecessary use of "body" term in variable - these can all assumed to be body measures unless explicitly referencing gravity measure.

The overall convention of the naming then covers the following
* first character f-fourier or t-time based measure or a-angle
* followed by type of measure (acceleration, gravity, jerk, gyro)
* followed by term mag where a magnitude is specified
* then the type of measure (mean, std)
* finally x,y,z specification for co-ordinates, where applicable

These still result in quite length data item names, so it is important to read the codebook.md
The re-structureing of the variable names was done through use of gsub for text replacement.

### Extraction of Variables

For this analysis, only those vaiables containing 'mean' or 'std' in their are selected. 
This includes means for angles, which should be treated with some caution.  
GREP was used on the data to extract the means and standard deviations. 

### Creation of the data frame

This involved the following steps

* Read the initial test and train main data sets
* Read the subjects and activities files for both test and train
* rename variables and extract required means and Stdev from both test and train
* create variables for subject ID and identification of test vs train
* replace the activity codes with a full activity name in the activities frame
* merge the identifiers with the activities and the main data for both test and train
* combine the test and train sets through appending (rbind) of the test and train sets
* trim variables not required (activity code)

### Aggregation and Creation of Means

This was done using aggregate() by subject and activity for the combined frame.
The approach calculates means of both the means and stdevs.
In both cases the aggregate means of means and means of stdev should be interpreted
with some caution, particulatly the means of stdevs which may be an unreliable estimator
of variation across the data.  Means of means may also be unreliable if the underlying data itself
has large variances.

The final output file will be created as tab delimited in the UCI HAR folder.

























