source("ui.R")
library("DT")

my.server <- function(input, output) {
  
  expo.name <- reactive({
    names(breaches.data) <- breaches$Title
    breach.name <- names(breaches.data[grepl(input$category, breaches.data)])
    expo.breach <- breaches %>%
      filter(grepl(breach.name, Title))
  })
  
  output$test <- renderText(
    return(expo.name())
    # cbind(expo.name()),
    # options = list(pageLength = 3, scrollX = TRUE), 
    # rownames = FALSE
  )
}

