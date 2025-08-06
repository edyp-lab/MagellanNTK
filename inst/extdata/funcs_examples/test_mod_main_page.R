if(interactive()){
  library(shiny)
  library(shinyjs)
  options(shiny.fullstacktrace = TRUE)
  
  app <- shinyApp(ui, server)
}