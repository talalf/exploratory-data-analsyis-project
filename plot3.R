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

baltimoredata <- NEI %>% filter(NEI$fips == "24510") %>% group_by(year, type)

# Produce plot with ggplot and export to png

png(filename = "plot3.png",
    width = 480,
    height = 480)

ggplot(baltimoredata, aes(fill=type, y=Emissions, x=year)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_x_continuous(breaks = seq(1999, 2008, by = 3)) +
  ggtitle("Baltimore City PM 2.5 changes over time") +
  xlab("Year") +
  labs(fill = "Type")

dev.off()
