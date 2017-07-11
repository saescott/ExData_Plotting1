##Set working directory to ~\edaprojectfiles if not already done
currentwd <- getwd()
setwd(currentwd)
newwd<-"edaprojectfiles"
if(grepl(newwd,currentwd)){
  setwd(file.path(currentwd))
} else {
  dir.create(file.path(currentwd, newwd))
  setwd(file.path(currentwd, newwd))
}


## Clean environment
rm(list = ls(all = TRUE))

## Load required packages
library(data.table)
library(dplyr)

##  Download zip file if not already done
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
hpczip<-"household_power_consumption.zip"
hpcfile<-"household_power_consumption.txt"
##
if (!file.exists(hpcfile)) {
  download.file(url, hpczip)
  unzip(hpczip, overwrite = T)
}

## Read file into table
hpc <- read.table(hpcfile, header=T, sep=";", na.strings="?")

## Extract desired date range
hpc1<-hpc[hpc$Date %in% c("1/2/2007","2/2/2007"),]

## Add "date.time" "POSIXct" "POSIXt" variable
date.time<-strptime(paste(hpc1$Date, hpc1$Time, sep=" "),"%d/%m/%Y %H:%M:%S")
hpc2 <- cbind(date.time, hpc1)

## Plot 4 Line Charts
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
plot(hpc2$Global_active_power~hpc2$date.time, type="l", 
     ylab="Global Active Power", xlab="")
plot(hpc2$Voltage~hpc2$date.time, type="l", 
     ylab="Voltage", xlab="datetime")
plot(hpc2$Sub_metering_1~hpc2$date.time, type="l", ylab="Energy sub metering", xlab="")
lines(hpc2$Sub_metering_2~hpc2$date.time,col="red")
lines(hpc2$Sub_metering_3~hpc2$date.time,col="blue")
## Apply Legend
legend("topright", col=c("black", "red", "blue"), lwd=c(1,1,1), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(hpc2$Global_reactive_power~hpc2$date.time, type="l", 
     ylab="Global_reactive_power",xlab="datetime")

## Create .png file 
dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()
