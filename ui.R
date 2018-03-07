library("shiny")
library("DT")
source("search.R")

my.ui <- fluidPage(
  includeCSS("pwnword.css"),
  titlePanel("PwnWord"),
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Exposed",
                         selectizeInput('category',"Select a category:",
                                        choices = c("Search" = "", category),
                                        selected = category[3],
                                        options = list(
                                          placeholder = 'Type in a category to search.')),
                         dataTableOutput('exposed'))
    )
  )
)
