library("httr")
library("jsonlite")
library("dplyr")
library("tidyverse")
library("ggplot2")

# Function for finding the json data by taking the query parameter to find the results
PwnSearch <- function(service) {
  base.uri = "https://haveibeenpwned.com/api/v2/"
  response <- GET(paste0(base.uri, service))
  result <- content(response, "text")
  jres <- fromJSON(result)
  return(jres)
}

breach <- PwnSearch("breaches")
breaches.data <- breach$DataClasses

breaches.select <- PwnSearch("breaches") %>%
  select(Title, BreachDate, PwnCount, Description)

colnames(breaches.select) <- c("Website Name", "Date of Breach", "Accounts Exposed", "Description")

breaches.d <- mutate(breach, year = substring(breach$BreachDate, 1, 4))
min.year <- min(breaches.d$year)
max.year <- max(breaches.d$year)

breaches.select$`Date of Breach` <- format(
  as.Date(breaches.select$`Date of Breach`), format = "%b %d %Y")

htmlClear <- function(htmltext) {
  return(gsub("<.*?>", "", htmltext))
}

breaches.select$Description <- htmlClear(breaches.select$Description)

category <- PwnSearch("dataclasses")

