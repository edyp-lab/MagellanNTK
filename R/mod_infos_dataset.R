#' @title   infos_dataset_ui and infos_dataset_server
#' @description  A shiny Module.
#'
#' @param id A `character()` as the id of the Shiny module
#' @param dataIn An instance of the class `MultiAssayExperiment`.
#'
#' @return A shiny app
#'
#'
#' @name infos_dataset
#'
#' @examples
#' if (interactive()){
#' data(lldata123)
#' shiny::runApp(infos_dataset(lldata123))
#' }
#' 
#' @import MultiAssayExperiment
#' 
NULL



#'
#'
#' @rdname infos_dataset
#'
#' @export
#' @importFrom shiny NS tagList
#'
infos_dataset_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    h3("This is the default module infos_dataset of MagellanNTK. It can be customized."),
    uiOutput(ns("choose_SE_ui")),
    uiOutput(ns("show_SE_ui"))
      )
}





# Module Server

#' @rdname infos_dataset
#' @export
#'
#' @keywords internal
#'
#' @importFrom SummarizedExperiment rowData assay colData
#' @importFrom S4Vectors metadata
#' @importFrom MultiAssayExperiment experiments
#'
infos_dataset_server <- function(
    id,
  dataIn = reactive({NULL}),
  remoteReset = reactive({0}),
  is.enabled = reactive({TRUE})) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    rv <- reactiveValues(
      dataIn = NULL
    )
    
    observeEvent(req(inherits(dataIn(), "MultiAssayExperiment")), {
      rv$dataIn <- dataIn()
    })
    
    output$choose_SE_ui <- renderUI({
      req(rv$dataIn)
      
      radioButtons(ns("selectInputSE"),
        "Select an assay for further information",
        choices = names(MultiAssayExperiment::experiments(rv$dataIn))
      )
    })
    

    output$show_SE_ui <- renderUI({
      req(rv$dataIn)
      req(input$selectInputSE != "None")
      .se <- rv$dataIn[[input$selectInputSE]]
      req(.se)
      
      
      MagellanNTK::format_DT_server("dt2",
        dataIn = reactive({round(SummarizedExperiment::assay(.se)[1:10, ], digits=2)})
      )
      
        tagList(
          p('10 first rows of the assay'),
          MagellanNTK::format_DT_ui(ns("dt2"))
        )
    })
    
  })
}



#' @export
#' @rdname infos_dataset
#'
infos_dataset <- function(obj) {
  ui <- fluidPage(infos_dataset_ui("mod_info"))
  
  server <- function(input, output, session) {
    infos_dataset_server("mod_info",
      dataIn = reactive({obj})
    )
  }
  
  app <- shiny::shinyApp(ui, server)
}
