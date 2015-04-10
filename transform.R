# This file describes how the data were loaded into R and processed for analysis.

# First, we need to set the environment in [R]

library(plyr)
library(dplyr)
library(reshape2)
library(scales) 


# Second, download the dataset and read into [R].

fileUrl <- "http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
download.file(fileUrl, destfile = "stormdata.csv.bz2")
rawdata <- read.csv("stormdata.csv.bz2", header=TRUE, na.strings="", dec=".")

# Two tables were created for a better analysis of the data. The first table looks 
# for the problems generated in the population health, it gives the total number 
# of fatalities and injuries for each event type for each year for each state:

healthdata <- transmute(rawdata, Year, State = STATE, Event = EVTYPE, 
                        Fatalities = FATALITIES, Injuries = INJURIES)
healthdata <- ddply(healthdata, Year ~ Event ~ State, summarize, 
                    Fatalities=sum(Fatalities), Injuries=sum(Injuries))
healthdata <- filter(healthdata, Fatalities > 0 | Injuries > 0)
