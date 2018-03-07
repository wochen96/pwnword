source("ui.R")

my.server <- function(input, output) {
  
  expo.name <- reactive({
    names(breaches.data) <- breaches.select$`Website Name`
    breach.name <- names(breaches.data[grepl(input$category, breaches.data)])
    expo.breach <- breaches.select %>%
      filter(`Website Name` %in% breach.name)
  })
  
  output$exposed <- renderDataTable(
    return(expo.name())
  )
}