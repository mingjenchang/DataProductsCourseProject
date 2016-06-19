# Preload required packages
library(shiny) 
library(ggplot2)
library(rCharts)
library(dplyr)

# Load data
FINF <- read.csv("Data/FINF.csv")
# Clean up data 
AllData <- subset(FINF, !(Family_Type %in% ("Not applicable")))
AllData <- subset(AllData, Income_Range_Yearly > 0)

# Shiny server 
shinyServer(
function(input, output) {    
        
# Populating income by state
    output$populateState <- renderPlot({
            StateData <- subset(AllData, State == input$State)
            StateIncome <- arrange(StateData, Family_Type, Income_Range_Yearly)
            StateName <- StateData[1,2]
            gTitle <- paste("2011 Census Family Income by Family Composition \n ", StateName)
            
            if (input$Income == "Yearly Income")
                p <- ggplot(StateIncome,aes(Income_Yearly,Count, color = Family_Type)) 
            if (input$Income == "Weekly Income")
                p <- ggplot(StateIncome,aes(Income_Weekly,Count, color = Family_Type)) 
            p <- p  + geom_line(aes(group = Family_Type)) + 
                    theme(axis.text.x = element_text(angle = 45, size = 8)) +
                    xlab(input$Income) + ylab("Number of Families") +
                    ggtitle(gTitle)
            print(p)
    })

# Render data table
        dataTable <- reactive({
                sortData <- arrange(AllData, Family_Type, Income_Range_Yearly)
                subset(sortData, State == input$State, select = c("State_Name","Family_Type","Income_Weekly","Income_Yearly","Count"))
        })

        output$table <- renderDataTable(
                {dataTable()}, options = list(bFilter = FALSE, iDisplayLength = 10))

})


