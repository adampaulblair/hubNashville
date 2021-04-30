# install.packages("RSocrata")
# install.packages("gmodels")
# install.packages("tigris")
# install.packages("censusr")
# install.packages("tidyverse")
# install.packages("lubridate")

library(RSocrata)
library(gmodels)
library(tigris)
library(censusr)
library(tidyverse)
library(here)
library(lubridate)


# Data Import ----

hub_data <- as_tibble(
  read.socrata(
  "https://data.nashville.gov/resource/7qhx-rexh.json",
  app_token = NULL,
  email = NULL,
  stringsAsFactors = FALSE
  )
)


## str(hub_data)
## summary(hub_data)

attach(hub_data)


seconds <- 60 * 60 * 24 # calculate seconds in a day

hub_data %>% 
  mutate(days_open = (date_time_closed - date_time_opened) / seconds)


ymd_hms(hub_data$date_time_opened)




days_open <- as.numeric((date_time_closed - date_time_opened) / seconds) # calculate days case was open


## Append days open to data frame

hub_data <- cbind(hub_data, days_open)


## Specify categorical variables

status <- factor(status)
case_request <- factor(case_request)
case_subrequest <- factor(case_subrequest)
incident_council_district <- factor(incident_council_district)

## Specify numeric variables

latitude <- as.numeric(latitude)
longitude <- as.numeric(longitude)


## Calculate and print average days open by case and subcase

case_means <- aggregate(hub_data, by = list(Group.case_request = case_request), FUN = mean, na.rm = TRUE)

case_means[c("Group.case_request", "days_open")]


## Append census tract IDs using lat-long

coords <- data.frame(latitude, longitude)


# hub_data$tract_id <- apply(coords, 1, function(row) call_geolocator_latlon(row["latitude"], row["longitude"]))

# hub_data$tract_id <- append_geoid(lat = latitude, lon = longitude, 'tract')

# this code worked:

# test_coords <- data.frame(lat = 36.13617, lon = -86.83346)
# test_coords
# lat       lon
# 1 36.13617 -86.83346
# test_append <- append_geoid(test_coords, 'tract')
# test_append
# lat       lon           geoid
# 1 36.13617 -86.83346 470370167002037


detach(hub_data)

## Save file

## write.csv(hub_data, file = "C:/Users/adamp/Dropbox/TSU/Research/hubNashville/hubNashville/hub_data.txt")