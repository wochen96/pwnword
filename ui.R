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
                placeholder = "Enter email/username..."),
      
      sliderInput('year.choice', label='Year Range', min=as.numeric(min.year),
                  max=as.numeric(max.year), value=c(as.numeric(min.year), 
                                                    as.numeric(max.year)))
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Have U Been Pwned?", dataTableOutput("user.search")),
                  tabPanel("Internet Security Over Time", plotOutput("security"),
                           textOutput('plot.desc')),
                  tabPanel("Exposed", dataTableOutput('exposed')),
                  tabPanel("text", textOutput('test'))
      )
    )
  )
)