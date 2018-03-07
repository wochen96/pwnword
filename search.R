library("httr")
library("jsonlite")
library("dplyr")
library("tidyverse")

# Function for finding the json data by taking the query parameter to find the results
PwnSearch <- function(service) {
  base.uri = "https://haveibeenpwned.com/api/v2/"
  response <- GET(paste0(base.uri, service),)
  result <- content(response, "text")
  jres <- fromJSON(result)
  return(jres)
}

breaches <- PwnSearch("breaches")
breaches.data <- breaches$DataClasses

breaches <- PwnSearch("breaches") %>%
  select(Title, ModifiedDate, PwnCount, Description)

htmlClear <- function(htmltext) {
  return(gsub("<.*?>", "", htmltext))
}

breaches$Description <- htmlClear(breaches$Description)

category <- PwnSearch("dataclasses")
