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

# extract data from breaches and seperate the list of DataClasses
breach <- PwnSearch("breaches")
breaches.data <- breach$DataClasses

# takes the elements of breanches related to the data table
breaches.select <- PwnSearch("breaches") %>%
  select(Title, BreachDate, PwnCount, Description)

# change column names
colnames(breaches.select) <- c("Website Name", "Date of Breach", "Accounts Exposed", "Description")

# find range of breach dates
breaches.d <- mutate(breach, year = substring(breach$BreachDate, 1, 4))
min.year <- min(breaches.d$year)
max.year <- max(breaches.d$year)

# change format of the dates on breach
breaches.select$`Date of Breach` <- format(
  as.Date(breaches.select$`Date of Breach`), format = "%b %d %Y")

# remove html elements
htmlClear <- function(htmltext) {
  return(gsub("<.*?>", "", htmltext))
}

# removes &quot; and replace with quotation marks
quoteClear <- function(quotetext){
  return(gsub("&quot;", "\"", quotetext))
}

# apply removal of html elements and quotes
breaches.select$Description <- htmlClear(breaches.select$Description)
breaches.select$Description <- quoteClear(breaches.select$Description)

# categories for the breach data
category <- PwnSearch("dataclasses")

