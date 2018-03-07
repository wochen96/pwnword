library("httr")
library("jsonlite")
library("dplyr")
library("ggplot2")

# Function for finding the json data by taking the query parameter to find the results
PwnSearch <- function(service) {
  base.uri = "https://haveibeenpwned.com/api/v2/"
  response <- GET(paste0(base.uri, service))
  result <- content(response, "text")
  jres <- fromJSON(result)
  return(jres)
}

breaches <- PwnSearch("breaches")
breaches.data <- breaches$DataClasses

breaches <- mutate(breaches, year = substring(breaches$BreachDate, 1, 4))

over.time <- ggplot(breaches, aes(year)) + geom_bar(fill = "#FF6666") +
  labs(x = "Year", y = "Number of Breaches", 
       title = "Amount of Breaches Over the Years") +
  theme(plot.title = element_text(face = "bold"))

"Has internet security increased over time?"

"The website tracks breached dates and by observing the trend we 
can see if internet security over the years have improved or changed 
in any way. We will look at the number of breaches that have happened 
based on the date and form a scatterplot with the data to find a trend 
on if it has decreased, increased or remain the same."

ggplot(breaches, aes(x = year, y = PwnCount)) + geom_point()

#   select(Title, Name, Domain, BreachDate, AddedDate, ModifiedDate, PwnCount, Description,
#          IsVerified, IsFabricated, IsSensitive, IsActive, IsRetired, IsSpamList)

category <- PwnSearch("dataclasses")
category














