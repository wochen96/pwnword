library("httr")
library("jsonlite")
library("dplyr")

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
  select(Title, BreachDate, AddedDate, ModifiedDate, PwnCount, Description)

category <- PwnSearch("dataclasses")

names(breaches.data) <- breaches$Title 
breach.name <- names(breaches.data[grepl(category[1], breaches.data)])
expo.breach <- breaches %>%
  filter(Title %in% breach.name)
expo.breach