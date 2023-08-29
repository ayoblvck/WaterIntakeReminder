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
    includeCSS("www/style.css"),
    # Application title
    titlePanel("Water Intake Tracker"),
    p("Welcome to my water intake tracking app", class = "head_message"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          p("Select your target water intake and input the amount of water taken at a time (in milliliters)"),
          dateInput("intake_date", "Select Date: ", value = Sys.Date()),
          
          checkboxInput("use_current_time", "Use current time", value = TRUE),
          conditionalPanel(
            condition = "!input.use_current_time",
            timeInput("intake_time", "Select Time", value = "12.00")
          ),
          selectInput("target_intake", 
                      "select water intake target in cups",
                      choices = c("3 cups" = 709.765, "4 cups" = 946.353, "5 cups" = 1182.94, "6 cups" = 1419.53, "7 cups" = 1656.12, "8 cups" = 1892.71, "9 cups" = 2129.29, "10 cups" = 2365.88),
                      selected = 1182.94),
          numericInput(inputId = "water_intake", 
                       label ="Input water taken in milliliters (1 cup = 236)",
                       value = 236),
          actionButton("submit", "submit")
          
        ),
        mainPanel(
          h3("Intake progress"),
          progressBar("progress", value = 0),
          actionButton("toggle_graph", "Toggle Graph"),
          conditionalPanel(
          condition = "input.toggle_graph > 0",
          plotOutput("intake_plot")
        ),
        conditionalPanel(
          condition = "input.toggle_graph==0",
          p("Click the toggle graph button to view a summary graph of your water intake"))

        )
    )
    
)