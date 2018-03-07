library('httr')
library('jsonlite')
library('dplyr')
library('ggplot2')
library('shiny')

base.uri <- "https://haveibeenpwned.com/api/v2"
breach.uri <- "/breaches"

response <- GET(paste0(base.uri, breach.uri))
breaches <- fromJSON(content(response, "text"))
breaches <- mutate(breaches, year = substring(breaches$BreachDate, 1, 4))

ui <- navbarPage("PwnWord",
                 tabPanel("Overview",
                          h1("Overview"),
                          p("This report is about websites having accounts of 
                            people that have been compromised. We would like to
                            inform users of the Internet which websites have
                            been breached, in order to avoid people from 
                            putting sensitive information on the Internet. The
                            information that have been found on accounts are
                            usually passwords and emails. And this information
                            is sometimes released to the public for everyone to
                            know. We will primarily be observing the amount of
                            breaches throughout the years, the types of 
                            breaches and how they compare with each other, and 
                            which breached websites have important information 
                            on them."),
                          h3("The Data"),
                          p("We are using data that is open to the public, 
                            which can be found ", 
                            a("here.", href="https://haveibeenpwned.com/"), 
                            "The data has been recorded since 2007 and all 
                            private information, such as passwords, are 
                            disclosed.", em("Troy Hunt"), 
                            " has created the website as a 
                            resource for people to find out whether they have 
                            been potentially hacked. He coins the word ",
                            em("pwn"), "to indicate the amount of accounts that
                            have been hacked."
                            ),
                          h3("Analysis Questions"),
                          p("These were some of the questions that we were
                            curious about from the data:"),
                          tags$ul(
                            tags$li("Has internet security increased over 
                                    time?"),
                            tags$li("How do verified breaches and unverified 
                                    breaches compare with each other?"),
                            tags$li("Which sites have exposed important 
                                    information (i.e. Credit card info, 
                                    government issued ID, etc)?")
                          ),
                          h3("About Us"),
                          p("This project was created by Wo Bin Chen, William 
                            Tan, and Jackie Trenh. We are a group of students
                            at the University of Washington, and chose this
                            project idea, because of the relevance of 
                            cyber-security in our world today.")
                          
                          ),
                 tabPanel("Over the Years"),
                 tabPanel("Types",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("select.type", "Select a type:",
                                          choices = c("Verified", "Fabricated", 
                                                      "Sensitive", "Active", 
                                                      "Retired", "Spamlist")),
                              
                              br(),
                              
                              sliderInput("year", "Select Year",
                                          min = 2007, max = 2018,
                                          value = c(2007, 2018))
                            ),
                            mainPanel(
                              plotOutput("type")
                            )
                          )
                          ),
                 tabPanel("Categories")
)

server <- function(input, output) {
  
  output$type <- renderPlot({
    
    type <- breaches$IsVerified
    
    # Select type of breach
    if(input$select.type == "Verified") {
      type <- breaches$IsVerified
    } else if (input$select.type == "Fabricated") {
      type <- breaches$IsFabricated
    } else if (input$select.type == "Sensitive") {
      type <- breaches$IsSensitive
    } else if (input$select.type == "Active") {
      type <- breaches$IsActive
    } else if (input$select.type == "Retired") {
      type <- breaches$IsRetired
    } else if (input$select.type == "Spamlist") {
      type <- breaches$IsSpamList
    }
    
    # Filter data based on years
    type.data <- breaches
    type.data <- filter(type.data, year >= input$year[1] & 
                        year <= input$year[2])
    
    # Plot point table with given selections
    g <- ggplot(data = breaches) +
      geom_point(mapping = aes(x = year, y = PwnCount, color = type)) +
      scale_x_discrete(limits = input$year[1]:input$year[2]) +
      scale_y_continuous(limits = c(0, max(type.data$PwnCount)), 
                         labels = scales::comma) +
      xlab("Year") +
      guides(color = guide_legend(title = input$select.type))
    
    return(g)
  
  })
  
}

shinyApp(ui, server)