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

# extract data from breaches and seperate categories to another 
breaches <- PwnSearch("breaches")
breaches.data <- breaches$DataClasses


breaches.select <- PwnSearch("breaches") %>%
  select(Title, BreachDate, PwnCount, Description)

colnames(breaches.select) <- c("Website Name", "Date of Breach", "Accounts Exposed", "Description")

breaches.select$`Date of Breach` <- format(
  as.Date(breaches.select$`Date of Breach`), format = "%b %d %Y")

htmlClear <- function(htmltext) {
  return(gsub("<.*?>", "", htmltext))
}

quoteClear <- function(quotetext) {
  return(gsub("&quot;", "\"", quotetext))
}

breaches.select$Description <- htmlClear(breaches.select$Description)
breaches.select$Description <- quoteClear(breaches.select$Description)

category <- PwnSearch("dataclasses")
