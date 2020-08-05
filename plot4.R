require(dplyr)
require(tidyverse)
require(ggplot2)

# un-comment and download files if not present

# download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data.zip", method = "curl")
# unzip("data.zip")

# read data from files

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# select relevant SCC codes relating to coal

coal <- grepl("coal", SCC$Short.Name,
              ignore.case = TRUE)

coalsubset <- SCC[coal,]

# merge dataframes

NEISSCC <- merge(NEI, coalsubset, by = "SCC")

# calculate the total emissions per year for the
# subsetted coal data

sum_by_year <- tapply(NEISSCC$Emissions,
                      NEISSCC$year,
                      FUN = sum)

# plot the summed subsetted data

png(filename = "plot4.png",
    width = 480,
    height = 480)

barplot(sum_by_year,
        main = "Total PM2.5 Emissions from Coal Sources, by Year",
        xlab = "Year",
        ylab = "PM2.5 Emission Level")

dev.off()
