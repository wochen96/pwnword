source("ui.R")
library("DT")
library("jsonlite")

my.server <- function(input, output) {
  
  # searches for breach data on user given username/email
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
  
  # filters for selected years
  filtered <- reactive({
    data <- filter(breaches, year >= input$year.choice[1] & 
                     year <= input$year.choice[2])
    over.time <- ggplot(data, aes(year)) + geom_bar(fill = "#FF6666") +
      labs(x = "Year", y = "Number of Breaches", 
           title = "Amount of Breaches Over the Years") +
      theme(plot.title = element_text(face = "bold")) 
    
    return(over.time)
  })
  
  expo.name <- reactive({
    names(breaches.data) <- breaches$Title
    breach.name <- names(breaches.data[grepl(input$category, breaches.data)])
    expo.breach <- breaches %>%
      filter(grepl(breach.name, Title))
  })
  
  # generates a data table of information from the given username/email
  output$user.search <- renderDataTable({
    return(default())
  },
  escape = FALSE)
  
  # generates a visualization on the breaches over the years
  output$security <- renderPlot({
    return(filtered())
  })
  
  # generates a text description of the plot visualization
  output$plot.desc <- renderText({
    paste0("The visualization above displays the breaches of data between ",
          input$year.choice[1], " and ", input$year.choice[2], ".")
  })
  
  output$test <- renderText(
    return(expo.name())
    # cbind(expo.name()),
    # options = list(pageLength = 3, scrollX = TRUE), 
    # rownames = FALSE
  )
}

