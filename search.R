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
test <- list.filter(breaches.data, Value = category[1])


breaches <- PwnSearch("breaches")

#   select(Title, Name, Domain, BreachDate, AddedDate, ModifiedDate, PwnCount, Description,
#          IsVerified, IsFabricated, IsSensitive, IsActive, IsRetired, IsSpamList)

category <- PwnSearch("dataclasses")