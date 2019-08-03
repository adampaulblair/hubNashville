## install.packages("RSocrata")
## install.packages("gmodels")

library("RSocrata")
library("gmodels")

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

detach(df)

## Save file