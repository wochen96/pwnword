source("ui.R")
library("DT")
library("jsonlite")

my.server <- function(input, output) {
  
  default <- reactive({
    data <- select(breaches[0, ], Name, Domain, BreachDate, Description)
    base.uri = "https://haveibeenpwned.com/api/v2/"
    if (input$user.email == "") {
      return(data)
    }
    response <- GET(paste0(base.uri, "breachedaccount/", input$user.email))
    if (response$status_code != 200) {
      return(data)
    }
    result <- content(response, "text")
    jres <- fromJSON(result)
    data <- select(jres, Name, Domain, BreachDate, Description)
    return(data)
  })
  
  expo.name <- reactive({
    names(breaches.data) <- breaches$Title
    breach.name <- names(breaches.data[grepl(input$category, breaches.data)])
    expo.breach <- breaches %>%
      filter(grepl(breach.name, Title))
  })
  
  output$user.search <- renderDataTable({
    return(default())
  },
  escape = FALSE)
  
  output$security <- renderPlot({
    return(over.time)
  })
  
  output$test <- renderText(
    return(expo.name())
    # cbind(expo.name()),
    # options = list(pageLength = 3, scrollX = TRUE), 
    # rownames = FALSE
  )
}

