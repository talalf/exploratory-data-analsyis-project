require(dplyr)
require(tidyverse)
require(ggplot2)

# un-comment and download files if not present

# download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data.zip", method = "curl")
# unzip("data.zip")

# read data from files

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# filter to select only Baltimore City data

baltimoredata <- NEI %>% filter(NEI$fips == "24510")

# Sum the PM2.5 levels, from all sources, by year

sum_by_year <- tapply(baltimoredata$Emissions, baltimoredata$year, FUN=sum)

# Make bar chart and export as png

png(filename = "plot2.png",
    width = 480,
    height = 480)

barplot(sum_by_year,
        main = "Total PM2.5 Emissions in Baltimore City, by Year",
        xlab = "Year",
        ylab = "PM2.5 Emission Level")

dev.off()
