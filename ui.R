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
      
      # a textInput that lets the user enter in their username/email
      # to search for whether they have an account that has been 
      # compromised in a data breach
      textInput('user.email', 'Check if you have an account that
                has been compromised in a data breach', 
                placeholder = "Enter email/username..."),
      
      # a sliderInput labeled 'Year Range' that lets the user pick the range
      # in years for breaches in data
      sliderInput('year.choice', label='Year Range', min=as.numeric(min.year),
                  max=as.numeric(max.year), value=c(as.numeric(min.year), 
                                                    as.numeric(max.year)))
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Have U Been Pwned?", dataTableOutput("user.search")),
                  
                  tabPanel("Internet Security Over Time", 
                           plotOutput("security"),
                           p("The visualization above displays the breaches 
                             of data over the selected years. According to 
                             the data received from ", a("haveibeenpwned.com,", 
                             href="https://haveibeenpwned.com/"), " there 
                             appears to be an increase in data breaches over
                             time. This can be attributable to a variety of 
                             factors such as the constant growth of the 
                             internet resulting in more information being out
                             there available to getting compromised in a data 
                             breach and security becoming outdated making them 
                             more susceptible to getting breached. The value 
                             for the year 2018 is low compared to the previous
                             years due to it only being three months into 
                             the year (as of when this was published).")),
                  
                  tabPanel("Exposed", dataTableOutput('exposed')),
                  
                  tabPanel("text", textOutput('test'))
      )
    )
  )
)