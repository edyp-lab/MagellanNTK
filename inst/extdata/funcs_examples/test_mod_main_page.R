if(interactive()){
  library(shiny)
  library(bs4Dash)
  library(shinyjs)
  options(shiny.fullstacktrace = TRUE)
  
  app <- shinyApp(ui, server)
}