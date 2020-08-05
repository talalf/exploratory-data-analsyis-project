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

# merge emissions records with SCC codes of vehicles

vehicle_emissions <- merge(NEI, vehicleindex, by = "SCC")

# filter to select only Baltimore City and LA County data

select_emissions <- vehicle_emissions %>% 
  filter(vehicle_emissions$fips == "24510" | vehicle_emissions$fips == "06037")

# plot emissions data labeled by city

png(filename = "plot6.png",
    width = 480,
    height = 480)

ggplot(select_emissions, aes(fill=fips, y=Emissions, x=year)) + 
  geom_bar(position="dodge", stat="identity") +
  scale_x_continuous(breaks = seq(1999, 2008, by = 3)) +
  ggtitle("LA County vs Baltimore City Vehicle Emissions - Changes Over Time") +
  xlab("Year") +
  ylab("PM 2.5 Emissions") +
  labs(fill = "County code") +
  scale_fill_discrete(name = "County", labels = c("LA County", "Baltimore"))

dev.off()
