#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)
library(shinyTime)
library(ggplot2)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Water Intake Tracker"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          dateInput("intake_date", "Select Date: ", value = Sys.Date()),
          
          checkboxInput("use_current_time", "Use current time", value = TRUE),
          conditionalPanel(
            condition = "!input.use_current_time",
            timeInput("intake_time", "Select Time", value = "12.00")
          ),
          
          numericInput(inputId = "water_intake", 
                       label ="Input amount of water ",
                       value = 10),
          selectInput("target_intake", 
                      "select water intake target",
                      choices = c("4 cups" = 50, "5 liters" = 90),
                      selected = 50),
          actionButton("submit", "submit")
        ),
        mainPanel(
          h3("Intake progress"),
          progressBar("progress", value = 0),
          plotOutput("intake_plot"),
          h4("Encouragement"),
          verbatimTextOutput("encouragement")
        )

        )
    )
