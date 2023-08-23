#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {

  data <- reactiveValues(
    intake = data.frame(date = character(), time = character(), intake = numeric() )
  )
  
  observe({
    data$target = as.numeric(input$target_intake)
  })
  
 observeEvent(input$submit, {
   intake_time <- if (input$use_current_time) {
     format(Sys.time(), "%H:%M")
   } else {
     as.character(input$intake_time)
   }
   
   new_row <- data.frame(
     date = as.character(input$intake_date),
     time = intake_time,
     intake = input$water_intake
   )
   
   
   data$intake <- rbind(data$intake, new_row)
   updateProgressBar(session, "progress", value =  sum(data$intake$intake)/data$target * 100)
 })
 
 output$intake_plot <- renderPlot({
   ggplot(data$intake, aes(x = as.POSIXct(date), y = intake)) +
     geom_line() +
     labs(x = "Date and Time", y = "Water Intake (oz)",
          title = "Water Intake Over Time")
 })
 
}
