
setwd("C:/Users/mmay/Desktop/Coursera/Data Scientist Toolbox - John Hopkins/3) Getting and Cleaning Data")
library(dplyr)

# 3.4 Programming assignment
# submitted by MMay

#Review Criteria
   # 1. The submitted data set is tidy
   # 2. The Githup repo contains the required scripts
   # 3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
   # 4. The README that explains the analysis files is clear and understandable
 

urlDataInfo <- "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
urlDataSet <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./data")){dir.create("./data")}
download.file(urlDataSet,destfile="data/rawdata")
unzip("data/rawdata",exdir="./data" )
# list.files("./data")
# list.files("./data/UCI HAR Dataset",recursive=TRUE)

all_files <- list.files("./data/UCI HAR Dataset",recursive=TRUE, full.names=TRUE)
all_files

# get activity description
activityLabels <- read.table(all_files[1])
activityLabels

# get activity description
featureLabels <- read.table(all_files[2])
dim(featureLabels)
columnlabels <- featureLabels[,2]
# grep("mean+\\(|std+\\(",columnlabels,value=TRUE)   #select only data that has the mean or standard deviation
desiredColumns <- grepl("mean+\\(|std+\\(",columnlabels) 

columnlabels <- gsub("\\()","",columnlabels)
columnlabels <- gsub("-","",columnlabels)


###### get TEST data ######################################
test_data <- read.table(all_files[15])          #loads the data set
names(test_data) <- columnlabels                #names the columns of the data set
# test_data[1:4,1:5]

test_labels <- read.table(all_files[16])        #loads the activity label data set
    names(test_labels)="label"
test_subject <- read.table(all_files[14])       #loads the subjects that took part in the training data set
    names(test_subject)="subject"
    # table(test_subject)
test_data2 <- test_data[,desiredColumns]
    # dim(test_data2)
    # test_data2[1:4,1:10]
test_data3 <- cbind(dataset="TEST", test_subject,test_labels,test_data2)      #adds the activity labels to the test_data set
    # test_data3[1:4,1:5]

# get TRAINING data
train_data <- read.table(all_files[27])          #loads the data set
names(train_data) <- columnlabels                #names the columns of the data set
# train_data[1:4,1:5]

train_labels <- read.table(all_files[28])        #loads the activity label data set
names(train_labels)="label"
train_subject <- read.table(all_files[26])       #loads the subjects that took part in the training data set
names(train_subject)="subject"
# table(train_subject)
train_data2 <- train_data[,desiredColumns]
# dim(train_data2)
# train_data2[1:4,1:10]
train_data3 <- cbind(dataset="TRAIN", train_subject,train_labels,train_data2)      #adds the activity labels to the train_data set
# train_data3[1:4,1:5]


# Combine the two datasets 
alldata <- rbind(train_data3, test_data3)
        # alldata [1:5,1:6]
        # dim(alldata)

#replace the label by its descriptive value

alldata2 <- merge(activityLabels,alldata,by.x=1,by.y="label")

finaldata1 <- select(alldata2,3,4,activity=2,5:70)

 finaldata1[1:5,1:6]

 
 
# get summary per Subject 
 finaldata1 <- tbl_df(finaldata1)

 names(finaldata1[,c(4,69)])
 
finaldata2 <- finaldata1 %>% 
group_by(subject, activity,dataset) %>% 
summarize_at(4:69,mean) 

# dim(finaldata2)
# finaldata2[1:5,1:6]

write.table(finaldata2,"./data/finalResults")

