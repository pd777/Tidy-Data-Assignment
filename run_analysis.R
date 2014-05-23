
### setwd("D:/Documents and Settings/w74927/My Documents/Software/Courserra/R/Getting_And_Cleaning_Data/Project/Test")


####   Code for Unzipping and getting files #############################
if (!file.exists("UCI HAR Dataset")) {
  if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
    stop("was expecting HAR Dataset folder or zip file")
  } else {
    unzip("getdata_projectfiles_UCI HAR Dataset.zip")
  }
}
f <- unz("zipFile.zip", "csvFileInZip.csv")

#### Set Directory to UCI HAR Dataset ###################################
setwd("UCI HAR Dataset")

### lookup for activities ################
activitieslist<-c(WALKING=1,WALKING_UPSTAIRS=2,WALKING_DOWNSTAIRS=3,SITTING=4,STANDING=5,LAYING=6)
### Get Variable names ##################
variables<-read.table("features.txt",sep=" ",header=FALSE,stringsAsFactors=FALSE)
variablenames<-variables[,2]
### Clean the variable names ################################
variablenames<-gsub("\\()","",variablenames, ignore.case =FALSE, fixed=FALSE)
variablenames<-gsub(",","",variablenames, ignore.case =FALSE, fixed=FALSE)
variablenames<-gsub("-","",variablenames, ignore.case =FALSE, fixed=FALSE)
variablenames<-gsub("\\(","",variablenames, ignore.case =FALSE, fixed=FALSE)
variablenames<-gsub("\\)","",variablenames, ignore.case =FALSE, fixed=FALSE)

variablenames<-tolower(variablenames)
variablenames<-gsub("bodybody","body",variablenames, ignore.case =FALSE, fixed=FALSE)
variablenames<-gsub("tbody","t",variablenames, ignore.case =FALSE, fixed=FALSE)
variablenames<-gsub("fbody","f",variablenames, ignore.case =FALSE, fixed=FALSE)

#############################################################
### Get subjects and activities for test data
#############################################################
test<-read.table("test/x_test.txt",header=FALSE)
names(test)<-variablenames
subjectstest<-read.table("test/subject_test.txt",header=FALSE)
names(subjectstest)<-"subject"
subjectstest$source<-"test"
activitiestest<-read.table("test/y_test.txt",header=FALSE)
activitiestest$activity<-names(activitieslist)[match(activitiestest$V1,activitieslist)]
names(activitiestest)<-c("activitycode","activity")
means<-test[,grep("mean",names(test),value=TRUE)]
stdev<-test[,grep("std",names(test),value=TRUE)]
testidentifiers<-cbind(subjectstest,activitiestest)
testframe<-cbind(testidentifiers,means,stdev)

#############################################################
### Get Training Data
#############################################################

train<-read.table("train/x_train.txt",header=FALSE)
names(train)<-variablenames
subjectstrain<-read.table("train/subject_train.txt",header=FALSE)
names(subjectstrain)<-"subject"
subjectstrain$source<-"train"
activitiestrain<-read.table("train/y_train.txt",header=FALSE)
activitiestrain$activity<-names(activitieslist)[match(activitiestrain$V1,activitieslist)]
names(activitiestrain)<-c("activitycode","activity")
means<-train[,grep("mean",names(train),value=TRUE)]
stdev<-train[,grep("std",names(train),value=TRUE)]
trainidentifiers<-cbind(subjectstrain,activitiestrain)
trainframe<-cbind(trainidentifiers,means,stdev)
###################################################################
combinedframe<-rbind(testframe,trainframe)
combinedframe$source<-NULL
combinedframe$activitycode<-NULL
###################################################################
x<-aggregate(.~subject+activity, combinedframe, FUN=mean,na.rm=TRUE )
write.table(x,"tidydata.txt",row.names=FALSE,sep="\t")


######################################################################