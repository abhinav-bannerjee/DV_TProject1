require(tidyr)
require(dplyr)
require(ggplot2)


file_path <- "2016 FE Guide for DOE.csv"

df <- read.csv(file_path, stringsAsFactors = FALSE)

# Replace "." (i.e., period) with "_" in the column names.
names(df) <- gsub("\\.+", "_", names(df))
names(df)[7]<- "Numbers_of_Cyl"
names(df)[9]<- "City_FE_Guide"
names(df)[10]<- "Hwy_FE_Guide"
names(df)[11]<- "Comb_FE_Guide"
names(df)[15]<- "Numbers_of_Gear"
names(df)[20] <-"Fuel_Usage_Desc"
names(df)[21]<- "Annual_Fuel_Cost"
names(df)[22]<- "Calculated_Annual_Fuel_Cost"
names(df)[29] <-"Numbers_of_Batteries"
names(df)[31] <-"Total_Voltage_for_Battery"
names(df)[32] <-"Batt_Energy_Cpacity_Amp_hrs"
names(df)[33] <-"Batt_Specific_Energy_Watt"
names(df)[36] <- "Regen_Braking_Wheels_Source"
names(df)[38] <-"Numbers_of_Drive_Motor_Gen"
names(df)[40] <-"Rated_Motor_Gen_Power_kW"
names(df)[42] <-"Fuel_Cell_Vehicle"
names(df)[43] <- "Off_Board_Charge_Capable"
names(df)[44] <-"Camless_Valvetrain"
names(df)[46] <-"Stop_Start_Engine"
names(df)[47] <- "Calculated_Gas_Guzzler_MPG"
names(df)[48] <-"FE_Rating_1_10"
names(df)[49] <-"five_years_savings"
names(df)[50] <-"five_years_spend"
names(df)[53] <-"Comb_CO2_Rounded_Adjusted"
df <-select(df,1:53)
str(df) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.

measures <- c("Model_Year","Eng_Displ","Numbers_of_Cyl","City_FE_Guide","Hwy_FE_Guide","Comb_FE_Guide","Numbers_of_Gear","Max_Ethanol_Gasoline","Annual_Fuel_Cost","Calculated_Annual_Fuel_Cost","EPA_FE_Label_Dataset_ID","Numbers_of_Batteries","Total_Voltage_for_Battery","Batt_Energy_Cpacity_Amp_hrs","Batt_Specific_Energy_Watt","Numbers_of_Drive_Motor_Gen","Rated_Motor_Gen_Power_kW","Calculated_Gas_Guzzler_MPG","FE_Rating_1_10","five_years_savings","five_years_spend","City_CO2_Rounded_Adjusted","Hwy_CO2_Rounded_Adjusted","Comb_CO2_Rounded_Adjusted")
#measures <- NA # Do this if there are no measures.

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}

dimensions <- setdiff(names(df), measures)
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
  }
}

library(lubridate)
# Fix date columns, this needs to be done by hand because | needs to be correct.
#                                                        \_/
df$Order_Date <- gsub(" [0-9]+:.*", "", gsub(" UTC", "", mdy(as.character(df$Order_Date), tz="UTC")))
df$Ship_Date  <- gsub(" [0-9]+:.*", "", gsub(" UTC", "", mdy(as.character(df$Ship_Date),  tz="UTC")))

# The following is an example of dealing with special cases like making state abbreviations be all upper case.
# df["State"] <- data.frame(lapply(df["State"], toupper))

# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""))
  }
}

write.csv(df, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)
