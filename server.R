source("ui.R")

my.server <- function(input, output) {
  
  expo.name <- reactive({
    names(breaches.data) <- breaches$Title
    breach.name <- names(breaches.data[grepl(input$category, breaches.data)])
    expo.breach <- breaches %>%
      filter(Title %in% breach.name)
  })
  
  output$exposed <- renderDataTable(
    return(expo.name())
  )
}

