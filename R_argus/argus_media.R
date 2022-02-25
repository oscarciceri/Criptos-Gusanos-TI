
#   ************************************************ PART 1 ************************************************

#1) Create a new table containing the index price for 
# each deal date that is included in the raw data.
#The rules for creating an index price are:
#a)	Only include a deal if the delivery period is within 180 days of the deal date.	
#b)	Index prices are calculated as a Volume Weighted Average Price (VWAP) of all the relevant deals.	
#c)	There are two indices to calculate:	
  #i.)	COAL2: Coal deals that are delivered to Northwest Europe (delivery location in ARA, AMS, ROT, ANT).
  #ii.)	COAL4: Coal deals that are delivered from South Africa.


# **** UPLOAD THE DATA ****
library(readxl)
library(tidyverse)

#Search the file
#file.choose()

pwd <- "C:\\Users\\oscar\\Documents\\Git\\Rprojects\\data_xlsx\\Argus Media - Excel Junior Data Analyst Technical Test.xlsx"

#See the leaf excel
excel_sheets(pwd)

#Read Excel
# First Case
raw_data <- read_excel(pwd,  sheet = "Data")
class(raw_data)

# **** CLEAN DATA *****

#Delivery period is within 180 days of the deal date
data <- raw_data %>% 
  filter(DELIVERY_MONTH != 'DEC',  DELIVERY_MONTH!= 'NOV') 

#Delivery location in ARA, AMS, ROT, ANT
data_COAL2  <- data %>% 
  filter(DELIVERY_LOCATION == "ARA" | DELIVERY_LOCATION == "AMS" | DELIVERY_LOCATION == "ROT" | DELIVERY_LOCATION == "ANT") 

#Delivered from South Africa
data_COAL4  <- data %>% 
  filter(SOURCE_LOCATION == "South Africa")

# **** CALCULATE VWAP *****

#Calculate Volume Weighted Average Price (VWAP)
COAL2 <- data_COAL2 %>% 
  group_by(DEAL_DATE) %>% 
  summarise(VWAP=sum(PRICE*VOLUME)/sum(VOLUME))

COAL4 <- data_COAL4 %>% 
  group_by(DEAL_DATE) %>% 
  summarise(VWAP=sum(PRICE*VOLUME)/sum(VOLUME))

# **** EXPORT THE DATA FROM DF TO .XLXS *****
library("writexl")
write_xlsx(COAL2,"C:\\Users\\oscar\\Documents\\Git\\Rprojects\\data_xlsx\\part1_COAL2.xlsx")
write_xlsx(COAL2,"C:\\Users\\oscar\\Documents\\Git\\Rprojects\\data_xlsx\\part1_COAL4.xlsx")

#   ************************************************ PART 2 ************************************************
# Add a macro that will export the contents of the "Data" sheet to a CSV file at a path specified by the user.
# The data should be sorted by COMMODITY SOURCE LOCATION in the following order: South Africa, Australia, Columbia



# *** Sort the data ***
indexs <- order(raw_data$SOURCE_LOCATION, decreasing = TRUE)
indexs

ordered_data <- raw_data[indexs, ]
ordered_data

final_ordered_data <- ordered_data %>%
  arrange(match(SOURCE_LOCATION, c("South Africa", "Australia", "Columbia")), desc(SOURCE_LOCATION))

# **** EXPORT THE DATA FROM DF TO .XLXS *****
write.csv(final_ordered_data,"C:\\Users\\oscar\\Documents\\Git\\Rprojects\\data_csv\\part2.csv", row.names = FALSE)

