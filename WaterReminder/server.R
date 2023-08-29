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

  congrats_shown <- reactiveVal(FALSE)
  
  data <- reactiveValues(
    intake = data.frame(date = character(), time = character(), intake = numeric()),
    last_date = Sys.Date(),
    daily_progress = 0
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
   
   if (as.Date(data$intake[nrow(data$intake), "date"]) != data$last_date) {
     data$last_date <- as.Date(data$intake[nrow(data$intake), "date"])
     data$daily_progress <- 0
   }
   
   data$daily_progress <- data$daily_progress + input$water_intake
   
   updateProgressBar(session, "progress", value =  data$daily_progress/data$target * 100)
   
   if (!congrats_shown() & data$daily_progress >= data$target) {
     congrats_shown(TRUE)
     showModal(
       modalDialog(
         HTML("<h4>Congratulations! You've reached your daily water intake target.</h4>
              <img src='clapping.gif' alt='Clapping Gif' class = 'gif_image'>"),
         actionButton("share_button", "Share Achievement on Social Media"),
         easyClose = TRUE
       ))
   }
   
   write.csv(data$intake, "water_intake_data.csv", row.names = FALSE)
 })
 
 #draw a graph
 graph_visible <- reactiveVal(FALSE)
 observeEvent(input$toggle_graph, {
   graph_visible(!graph_visible())
 })
 

 output$intake_plot <- renderPlot({
   if(graph_visible() && nrow(data$intake) != 0){
   agg_data <- aggregate(intake ~ date, data$intake, sum)
   ggplot(agg_data, aes(x = as.POSIXct(date), y = intake)) +
     geom_line() +
     labs(x = "Date and Time", y = "Water Intake (ml)",
          title = "Water Intake Over Time")
   } 
     
   
 })
 
}
