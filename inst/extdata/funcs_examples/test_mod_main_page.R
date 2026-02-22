if(interactive()){
  library(shiny)
  options(shiny.fullstacktrace = TRUE)
  
  app <- shinyApp(ui, server)
}