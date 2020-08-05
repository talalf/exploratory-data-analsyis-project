require(dplyr)
require(tidyverse)
require(ggplot2)

# un-comment and download files if not present

# download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data.zip", method = "curl")
# unzip("data.zip")

# read data from files

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# filter SCC codes relating to motor vehicles

vehicleSCC <- grepl("Vehicles", SCC$SCC.Level.Two)

vehicleindex <- SCC[vehicleSCC, ]

# filter to select only Baltimore City data

baltimoredata <- NEI %>% filter(NEI$fips == "24510")

# subset emissions records of vehicles from Baltimore data

baltimore_vehicle_emissions <- merge(baltimoredata, vehicleindex, by = "SCC")

# calculate the total emissions per year for the
# subsetted coal data

sum_by_year <- tapply(baltimore_vehicle_emissions$Emissions,
                      baltimore_vehicle_emissions$year,
                      FUN = sum)

# plot the summed subsetted data

png(filename = "plot5.png",
    width = 480,
    height = 480)

barplot(sum_by_year,
        main = "PM2.5 Emissions from Vehicles in Baltimore, by Year",
        xlab = "Year",
        ylab = "PM2.5 Emission Level")

dev.off()
