library("shiny")
library("DT")
source("search.R")

my.ui <- fluidPage(
  titlePanel("PwnWord"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput('category',"Select a category:",
                     choices = c("Search" = "", category),
                     selected = category[1:3],
                     multiple = TRUE,
                     options = list(
                       placeholder = 'Type in a category to search.',
                       maxOptions = 5)
      )
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Exposed", dataTableOutput('exposed')),
                  tabPanel("text", textOutput('test'))
      )
    )
  )
)