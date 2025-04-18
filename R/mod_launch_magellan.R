#' launch_magellan UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' 
#' @examples
#' \dontrun{
#' shiny::runApp(mod_launch_magellan())
#' }
#' 
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_launch_magellan_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(
      # div(style="display:inline-block; vertical-align: middle; padding-right: 20px;",
      #   choose_pipeline_ui(ns("pipe"))
      # ),
      div(
        style="display:inline-block; vertical-align: middle; padding-right: 20px;",
        shinyjs::hidden(div(id=ns('div_demoDataset'),
                            mod_open_demoDataset_ui(ns('rl'))
        )
        )
      ),
      div(style="display:inline-block; vertical-align: middle; padding-right: 20px;",
        shinyjs::hidden(actionButton(ns('load_dataset_btn'), 'Load dataset', class=actionBtnClass))
      )
    )
    #uiOutput(ns('show'))
  )
}
    
#' launch_magellan Server Function
#'
#' @noRd 
mod_launch_magellan_server <- function(id){
  
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    rv <- reactiveValues(
      demoData = NULL,
      pipeline = NULL,
      pipeline.name = NULL,
      dataIn = NULL
    )
    
    rv$demoData <- mod_open_demoDataset_server("rl")
    
    # rv$pipeline.name <- choose_pipeline_server('pipe', 
    #                                                package = 'MSPipelines')
    
    observe({
      shinyjs::toggle('div_demoDataset', condition = !is.null(rv$pipeline.name()) && rv$pipeline.name() != 'None')
      shinyjs::toggle('load_dataset_btn', condition = !is.null(rv$demoData()))
    })
    
    observeEvent(req(rv$pipeline.name() != 'None'), {
      print("Launch Magellan")
      obj <- base::get(rv$pipeline.name())
      rv$pipeline <- do.call(obj$new, list('App'))
      #rv$pipeline <- Protein$new('App')
      rv$dataOut <- rv$pipeline$server(dataIn = reactive({rv$dataIn}))
    })
    
    observeEvent(req(input$load_dataset_btn), ignoreNULL = TRUE, {
      print(names(rv$demoData()))
      rv$dataIn <- rv$demoData()
    })
    
    output$show <- renderUI({
      req(rv$pipeline)
      rv$pipeline$ui()
    })
    
    list(server = reactive({rv$dataOut}),
         ui = reactive({
           req(rv$pipeline)
           rv$pipeline$ui()
           })
         )
    
  })
 
}
    

#' @export
#' @rdname generic_mod_open_dataset
#' 
#' 
mod_launch_magellan <- function(){
  
  ui <- mod_launch_magellan_ui("demo")
  
  server <- function(input, output, session) {
    mod_launch_magellan_server()
  }
  
  app <- shinyApp(ui = ui, server = server)
}
