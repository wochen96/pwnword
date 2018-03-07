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
                       maxOptions = 5)),
      textInput('user.email', 'Check if you have an account that
                has been compromised in a data breach', 
                placeholder = "Enter email/username...")
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Have I Been Pwned?", dataTableOutput("user.search")),
                  tabPanel("Internet Security Over Time", plotOutput("security")),
                  tabPanel("Exposed", dataTableOutput('exposed')),
                  tabPanel("text", textOutput('test'))
      )
    )
  )
)