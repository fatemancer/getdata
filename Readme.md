## Run_analysis.r explanation

1. Unpack the UCI HAR Dataset into your working directory (so that there's such a folder in your working directory)
2. Check if you have 'reshape2' package installed.
2. Source the run.analysis.R file, it will start running.
3. After the script finishes working (caution: it uses some low performance functions, so it might take a while) there will be a "tidy.txt" dataset in your directory with the original data.

What the script exactly does (the comments on the technical details are inside the .R file):
1. Reads all the files from test and train folders (excluding "Inertial Signal" folder)
2. Reads files that contain data about features, activity labels and subjects.
3. Creates additional columns for the test and train data sets, that include: 'data set type', 'subject #', 'activity type'
4. Merges both train and test sets into one big set.
5. Finds the columns that contain the mean and standard deviation measurements, then select only them and the data about subject and activity type, put them into another data set. 
6. Then it reshapes the data so that for each "subject + activity" pair there's a mean of all measurements in each column
7. Finally, it writes down the data in the .txt file.