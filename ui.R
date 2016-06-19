
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(ggplot2)
library(rCharts)

shinyUI(
    navbarPage("Australian Family Income Explorer",
        tabPanel("Plot",
                sidebarPanel(
                        selectInput("Income", "Choose Income Type:", 
                                    choices = list("Weekly" = "Weekly Income","Yearly" = "Yearly Income"), 
                                    selected = 2),
                        radioButtons(
                                "State",
                                "Choose Australia State:",
                                c("New South Wales"="NSW", "Victoria"="VIC", "Queensland"="QLD", "South Australia"="SA", "Western Australia"="WA", "Australian Capital Territory"="ACT", "Tasmania"="TAS", "Northern Territory"="NT"))
                ),
  
                mainPanel(
                    tabsetPanel(
                        
                        # Data by state
                        tabPanel(p(icon("map-marker"), "By state"),                              
                                 plotOutput("populateState")
                        ),
                                               
                        # Data 
                        tabPanel(p(icon("table"), "Data"),
                            dataTableOutput(outputId="table")
                            #downloadButton('downloadData', 'Download')
                        )
                    )
                )
            
        ),
        
        tabPanel("Help",
            mainPanel(
                includeMarkdown("help.md")
            )
        )
    )
)
