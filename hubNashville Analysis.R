## install.packages("RSocrata")
## install.packages("gmodels")
## install.packages("tigris")

library(RSocrata)
library(gmodels)
library(tigris)

## Import data using API

df <- read.socrata(
  "https://data.nashville.gov/resource/7qhx-rexh.json",
  app_token = NULL,
  email = NULL,
  stringsAsFactors = FALSE
)

## str(df)
## summary(df)

attach(df)

## Convert seconds into days

second_conversion <- 60 * 60 * 24

## Calculate number of days a case took to close

days_open <- as.numeric((date_time_closed - date_time_opened) / second_conversion)

## Append days open to data frame

df <- cbind(df, days_open)

## Specify categorical variables

status <- factor(status)
case_request <- factor(case_request)
case_subrequest <- factor(case_subrequest)
incident_council_district <- factor(incident_council_district)

## Specify numeric variables

latitude <- as.numeric(latitude)
longitude <- as.numeric(longitude)

## Calculate and print average days open by case and subcase

case_means <- aggregate(df, by = list(Group.case_request = case_request), FUN = mean, na.rm = TRUE)

case_means[c("Group.case_request", "days_open")]

## Append census tract IDs using lat-long

coords <- data.frame(latitude, longitude)

coords$tract_id <- apply(coords, 1, function(row) call_geolocator_latlon(row["latitude"], row["longitude"]))

detach(df)

## Save file

## write.csv(df, file = "C:/Users/adamp/Dropbox/TSU/Research/hubNashville/hubNashville/df.txt")