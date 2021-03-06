library('httr')
library('jsonlite')
library('dplyr')
library('ggplot2')
library('shiny')
library('plotly')
library("DT")
source("search.R")

base.uri <- "https://haveibeenpwned.com/api/v2"
breach.uri <- "/breaches"

response <- GET(paste0(base.uri, breach.uri))
breaches <- fromJSON(content(response, "text"))
breaches <- mutate(breaches, year = substring(breaches$BreachDate, 1, 4))

ui <- shinyUI(
        fluidPage(
          includeCSS("pwnword.css"),
          navbarPage("PwnWord",
                 tabPanel("Overview",
                          div(class="overview",
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
                                on them. In our world today, there is a lot of
                                information that can be accessed by hackers,
                                and it is important for users and
                                cyber-security experts to know what information
                                is being compromised.")
                          ),
                          div(class="data",
                            h3("The Data"),
                            p("We are using data that is open to the public, 
                              which can be found ", 
                              a("here.", href="https://haveibeenpwned.com/"), 
                              "The data has been recorded since 2007 and all 
                              private information, such as passwords, are 
                              kept confidential.", tags$em("Troy Hunt"), 
                              " has created the website as a 
                              resource for people to find out whether they have 
                              been potentially hacked. He coins the word ",
                              tags$em("pwn"), "to indicate the amount of accounts
                              that have been hacked."
                              )
                          ),
                          div(class="analysis",
                            h3("Analysis Questions"),
                            p("These were some of the questions that we were
                              curious about from the data:"),
                            tags$ul(
                              tags$li("Has internet security increased over 
                                      time?"),
                              tags$li("How do different types of 
                                      breaches compare with each other?"),
                              tags$li("Which sites have exposed important 
                                      information (i.e. Credit card info, 
                                      government issued ID, etc)?")
                            )
                          ),
                          
                          div(class="about",
                            h3("About Us"),
                            p("This project was created by Wo Bin Chen, William 
                              Tan, and Jackie Trenh. We are a group of students
                              at the University of Washington, and chose this
                              project idea, because of the relevance of 
                              cyber-security in our world today.")
                          )
                        ),
                 
                 # User interactive panel
                 tabPanel("Have U Been Pwned?",
                          
                          p("This section lets you look at what accounts or
                            emails have been compromised. Inputting an
                            account or email searches the database of ", 
                            a("HIBP", href="https://haveibeenpwned.com/"), "
                            to see if the account is contained in the
                            database."),
                          
                   sidebarLayout(
                     sidebarPanel(
                       textInput('user.email', 'Check if you have an account
                                 that has been compromised in a data breach', 
                                 placeholder = "Enter email/username...")
                     ),
                     mainPanel(
                       dataTableOutput("user.search")
                     )
                   )
                  ),
                 
                 # Time panel
                 tabPanel("Internet Security Over Time",
                          
                          p("This chart displays the amount of breaches that
                            have happened throughout the years. The data begins
                            from 2007 and goes up to 2018."),
                          
                          p("Based on the chart, there appears to be an
                            increase in data breaches over time. This can be
                            attributable to a variety of factors such as the
                            constant growth of the internet resulting in more
                            information being out there available to getting
                            compromised in a data breach and security becoming
                            outdated making them more susceptible to getting
                            breached. The value for the year 2018 is low
                            compared to the previous years due to it only being
                            three months into the year (as of when this
                            was published). People would expect that as time
                            goes on, cyber-security would improve. Although it
                            may be possible, this chart shows that it is
                            possible that hackers have an easier time
                            bypassing cyber-security."),
                          
                          sidebarLayout(
                            sidebarPanel(
                              sliderInput('year.choice', label='Year Range', 
                                          min=as.numeric(min.year),
                                          max=as.numeric(max.year), 
                                          value=c(as.numeric(min.year), 
                                                  as.numeric(max.year))
                                          )
                            ),
                            mainPanel(
                              plotOutput("security"),
                              textOutput('plot.desc')
                            )
                          )
                 ),
                 
                 # Types panel
                 tabPanel("Types", 
                          
                          p("This chart displays the breaches by the 
                            type it is selected. The data can be 
                            filtered by a given year range. PwnCount refers to
                            the amount of accounts in the breach have been
                            potentially compromised."),
                          
                          p(tags$b("Verified"), " refers to whether a breach is
                            confirmed. Some breaches may be unverified, but can
                            still contain real information. As shown in the
                            chart, most of the breaches have been verified. The
                            unverified breaches can be legitimate, since the
                            PwnCount of the verified and unverified seem to
                            be similar."),
                          
                          p(tags$b("Fabricated"), " refers to if the data from
                            the breach is fake. Although, it can be fabricated,
                            some information can be real, such as email
                            addresses. As shown in the chart, most of the
                            breaches are not fabricated. So, people should
                            be wary the fact that information put onto the
                            Internet can be accessed by others."),
                          
                          p(tags$b("Sensitive"), " refers to if the breached
                            website has information that can impact a user's
                            life if they are found to be a member of the site.
                            As shown in the chart, most of the sensitive
                            breaches are adult websites. If others were to
                            find out if someone has an email linked to the
                            websites, they may be judged by them."),
                          
                          p(tags$b("Active"), " refers to if the breach
                            is currently listed in ", a("HIBP.", 
                            href="https://haveibeenpwned.com/"), "All of the
                            breaches should be set to active."
                            ),
                          
                          p(tags$b("Retired"), " refers to information of
                            a breach that has been permanently removed from
                            the website. The only retired breach is from 
                            Vtech."),
                          
                          p(tags$b("Spam List"), " refers to a breach where
                            information is taken just to target people with 
                            spam. The information taken can be names,
                            addresses, and phone numbers. Majority of the
                            breaches are not spam lists."),
                          
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("select.type", "Select a type:",
                                          choices = c("Verified", "Fabricated", 
                                                      "Sensitive", "Active", 
                                                      "Retired", "Spam List")),
                              
                              br(),
                              
                              sliderInput("year", "Select Year",
                                          min = 2007, max = 2018,
                                          value = c(2007, 2018))
                            ),
                            mainPanel(
                              plotlyOutput("type")
                            )
                          )
                        ),
                 
                 # Category panel
                 tabPanel("Categories",
                          p("This table displays the breaches within each
                            category. The data is filtered by selecting a
                            category which then will return the domain
                            information associated to it."),
                          p("While most of the categories will only return
                            around 10 or so domains, the two categories 
                            (\"Password\" and \"Usernames\")  have the highest
                            return of domains. The largest focus of data
                            breaches is obtaining the user and password of
                            people's account."),
                          
                          selectizeInput('category',"Select a category:",
                                         choices = c("Search" = "", category),
                                         selected = category[3],
                                         options = list(
                                           placeholder = 'Type in a category
                                           to search.')
                                         ),
                          
                          dataTableOutput('exposed'))
    )
  )
)

server <- function(input, output) {
  
  # searches for breach data on user given username/email
  default <- reactive({
    data <- select(breaches.d[0, ], Name, Domain, BreachDate, Description)
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
    data <- filter(breaches.d, year >= input$year.choice[1] & 
                     year <= input$year.choice[2])
    over.time <- ggplot(data, aes(year)) + geom_bar(fill = "#FF6666") +
      labs(x = "Year", y = "Number of Breaches", 
           title = "Amount of Breaches Over the Years") +
      theme(plot.title = element_text(face = "bold")) 
    
    return(over.time)
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
  
  # Create plot for 'types'
  output$type <- renderPlotly({
    
    type <- breaches$IsVerified
    
    # Select type of breach
    if (input$select.type == "Verified") {
      type <- breaches$IsVerified
    } else if (input$select.type == "Fabricated") {
      type <- breaches$IsFabricated
    } else if (input$select.type == "Sensitive") {
      type <- breaches$IsSensitive
    } else if (input$select.type == "Active") {
      type <- breaches$IsActive
    } else if (input$select.type == "Retired") {
      type <- breaches$IsRetired
    } else if (input$select.type == "Spam List") {
      type <- breaches$IsSpamList
    }
    
    # Filter data based on years
    type.data <- breaches
    type.data <- filter(type.data, year >= input$year[1] & 
                        year <= input$year[2])
    
    # Plot interactive scatterplot with given selections
    p <- plot_ly(breaches, x = ~year, y= ~PwnCount, type = 'scatter', 
                 color = type, colors = c("red", "green"),
                 hoverinfo = 'text',
                 text = ~paste(tags$b('Website: '), Title,
                               tags$b('<br> Breach Date: '), BreachDate,
                               tags$b('<br> PwnCount: '), PwnCount)) %>%
      layout(
        title = "Breaches by Type",
        xaxis = list(title = "Year", range = c(input$year[1], input$year[2]))
      )
    
    return(p)
  
  })
  
  # finds the breaches that contain the categories
  expo.name <- reactive({
    names(breaches.data) <- breaches.select$`Website Name`
    breach.name <- names(breaches.data[grepl(input$category, breaches.data)])
    expo.breach <- breaches.select %>%
      filter(`Website Name` %in% breach.name)
  })
  
  # create data table for categories
  output$exposed <- renderDataTable(
    return(expo.name())
  )
  
}

shinyApp(ui, server)
