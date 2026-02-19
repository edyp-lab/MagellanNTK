#' @title   history_dataset_ui and history_dataset_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param dataIn An instance of the class `QFeatures`.
#'
#' @return A shiny app
#'
#'
#' @name history_dataset
#'
#' @examples
#' if (interactive()){
#' data(lldata)
#' shiny::runApp(history_dataset(lldata))
#' }
#' 
NULL



#'
#'
#' @rdname history_dataset
#'
#' @export
#' @importFrom shiny NS tagList
#'
history_dataset_ui <- function(id) {
  ns <- NS(id)
  div(style = 'height: 600px',
    MagellanNTK::format_DT_ui(ns("history"))
  )
}





# Module Server

#' @rdname history_dataset
#' @export
#'
#' @keywords internal
#'
#' @importFrom tibble as_tibble
#' @importFrom SummarizedExperiment rowData assay colData
#' @importFrom S4Vectors metadata
#' @importFrom MultiAssayExperiment experiments
#' @importFrom QFeatures nNA
#'
history_dataset_server <- function(
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
    
    
    Get_QFeatures_History <- reactive({
      req(rv$dataIn)

      .name <- names(rv$dataIn)[length(rv$dataIn)]
      df <- as.data.frame(GetHistory(rv$dataIn, .name))
      return(df)
    })

    MagellanNTK::format_DT_server("history",
      dataIn = reactive({Get_QFeatures_History()})
    )
    
  })
}



#' @export
#' @rdname history_dataset
#'
history_dataset <- function(obj) {
  ui <- fluidPage(history_dataset_ui("mod_info"))
  
  server <- function(input, output, session) {
    history_dataset_server("mod_info",
      dataIn = reactive({
        obj
      })
    )
  }
  
  app <- shiny::shinyApp(ui, server)
}
