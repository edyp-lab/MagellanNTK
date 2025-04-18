#' @title mod_open_demo_dataset_ui and mod_open_demo_dataset_server
#' 
#' @description  A shiny Module.
#' 
#' @param id xxx
#' @param obj An instance of class xxx
#' @param ... Additional parameters
#' 
#' @name view_dataset
#'
#' 
#' @examples
#' \dontrun{
#' data(lldata)
#' shiny::runApp(view_dataset(lldata))
#' }
#' 
#' 
NULL




#' @export 
#' @rdname view_dataset
#' @importFrom shiny NS tagList h3
#' 
view_dataset_ui <- function(id){
  ns <- NS(id)
  tagList(
    h3(style="color: blue;", 'Dataset viewer (default)'),
    uiOutput(ns('chooseAssay_UI')),
    plotOutput(ns('plot'))
  )
}


#' @rdname view_dataset
#'  
#' @export
#' @importFrom shiny moduleServer reactiveValues reactive
#' 
view_dataset_server <- function(id,
  dataIn= NULL, 
  ...){
  
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    rv.openDemo <- reactiveValues(
      dataRead = NULL,
      dataOut = NULL
    )
    
    
    output$chooseAssay_UI <- renderUI({
      req(dataIn())
      selectInput(ns('assay'), 'Choose',
        choices = names(dataIn()),
        width = '100px')
    })
    
    output$plot <- renderPlot({
      req(input$assay)
      plot(dataIn()[[input$assay]])
    })
    reactive({rv.openDemo$dataOut})
  })
  
}



#' @export
#' @rdname view_dataset
#' @importFrom shiny shinyApp reactiveValues reactive
#' 
view_dataset <- function(obj, ...){

ui <- view_dataset_ui("demo")


server <- function(input, output, session) {
  rv <- reactiveValues(
    obj = NULL
  )
  
  rv$obj <- view_dataset_server("demo",
    dataIn = reactive({obj}),
    ...
    )
  
}

app <- shinyApp(ui = ui, server = server)
}
