library('httr')
library('jsonlite')
library('dplyr')
library('ggplot2')
library('shiny')

base.uri <- "https://haveibeenpwned.com/api/v2"
breach.uri <- "/breaches"

response <- GET(paste0(base.uri, breach.uri))
result <- fromJSON(content(response, "text"))
result <- mutate(result, year = substring(result$BreachDate, 1, 4))

verified <- filter(result, IsVerified == TRUE)
nrow(verified)
not.verified <- filter(result, IsVerified == FALSE)
nrow(not.verified)

g <- ggplot(data = result) +
  geom_point(mapping = aes(x = year, y = PwnCount, color = IsVerified)) +
  scale_y_continuous(limits = c(0, 800000000), labels = scales::comma)

g
