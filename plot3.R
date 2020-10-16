#Set the working directory to the source script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Remove previous objects
rm(list= ls())

#Load the requited packages
library(tidyverse)
library(ggplot2)

#Create a directory for the data, if it does not already exist
if(!file.exists("./data")){dir.create("./data")}

#Download the data set from the course's website
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile="./data/data.zip")

#Unzip the data set
unzip(zipfile="./data/data.zip",exdir="./data")

#Read the data
energy <- read_delim('./data/household_power_consumption.txt', 
                     delim = ";",
                     na = "?")

#Check the data
energy

#Make a copy of the data
energy2 <- energy

#Convert dates to proper date format
energy2$Date <- as.Date(energy2$Date, format = "%d/%m/%Y")

#Check the data
energy2

#Subset only the days to be analyzed
energy3 <- energy2 %>%
    subset(Date >= "2007-02-01" & Date <= "2007-02-02") %>%
    mutate(DateTime = paste(Date, Time)) %>%
    mutate(DateTime = as.POSIXct(DateTime)) %>%
    mutate(Global_active_power = as.numeric(Global_active_power))

#Check the data
energy3

#Get weekdays in English
Sys.setlocale("LC_TIME", "en_US")

#Make Plot 3 and export it as a PNG image
png("plot3.png", height = 480, width = 480, units = "px")
with(energy3, plot(Sub_metering_1 ~ DateTime, type = "l", 
                   ylab = "Energy sub metering", xlab = ""))
with(energy3, lines(Sub_metering_2 ~ DateTime, col = "Red"))
with(energy3, lines(Sub_metering_3 ~ DateTime, col = "Blue"))
legend("topright", lty = 1, col = c("black", "red", "blue"), 
legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()
