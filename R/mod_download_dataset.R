#' @title dl
#'
#' @description  A shiny Module.
#'
#'
#' @param id A `character()` as the id of the Shiny module
#' @param dataIn An instance of the class `MultiAssayExperiment`
#' @param filename internal
#' @param remoteReset A `logical(1)` which acts as a remote command to reset
#' the module to its default values. Default is FALSE.
#' @param is.enabled A `boolean`. This variable is used as a remote command to specify
#' if the corresponding module is enabled (TRUE) or disabled (FALSE). For more
#' details, please refer to the document 'Inside MagellanNTK'?
#'
#' @return NA
#'
#' @name download_dataset
#' @examples
#' if (interactive()){
#' data(lldata, package = "MagellanNTK")
#' shiny::runApp(download_dataset(lldata))
#' }
#' 
#'
NULL


#' @importFrom shiny NS tagList actionLink fluidRow column uiOutput hr reactive
#'
#' @rdname download_dataset
#'
#' @export
#'
download_dataset_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3('Download dataset'),
    uiOutput(ns('nodataset_ui')),
    uiOutput(ns('buttons_ui'))
  )
}

#' @rdname download_dataset
#' @importFrom shiny moduleServer reactiveValues observeEvent NS tagList actionLink fluidRow column uiOutput hr reactive
#'
#' @export
#'
download_dataset_server <- function(
    id,
  dataIn = reactive({NULL}),
  filename = "myDataset",
  remoteReset = reactive({0}),
  is.enabled = reactive({TRUE})) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    rv <- reactiveValues(
      export_file = NULL
    )
    
    output$nodataset_ui <- renderUI({
      req(is.null(rv$data_save))
      p('No dataset available')
    })
    
    output$buttons_ui <- renderUI({
      req(rv$data_save)
      uiOutput(ns("dl_raw"))
    })
    
    observeEvent(req(dataIn()), ignoreNULL = TRUE, ignoreInit = FALSE,{
      rv$data_save <- dataIn()
    })
    

    ## Save as .qf -----
    output$dl_raw <- renderUI({
      do.call(
        paste0("download", 'Button'),
        list(
          ns("downloadData"), "Qf"
        )
      )
    })
    
    output$downloadData <- downloadHandler(
      filename = function() {
        paste(filename, ".qf", sep = "")
      },
      content = function(file) {
        rv$export_file <- tryCatch({
          shiny::withProgress(message = paste0("Builds Rdata file", id), {
            shiny::incProgress(0.5)
            out.qf <- tempfile(fileext = ".qf")
            #saveRDS(rv$data_save, file = out.rdata )
            saveRDS(rv$data_save, file = out.qf )
            out.qf 
          })
        },
          warning = function(w) w,
          error = function(e) e
        )
        file.copy(from = rv$export_file, to = file)
      }
    )
    
  })
}




#' @rdname download_dataset
#'
#' @export
#'
download_dataset <- function(
    dataIn = NULL, 
  filename = "myDataset") {
  ui <- download_dataset_ui("dl")
  
  server <- function(input, output, session) {
    download_dataset_server("dl",
      dataIn = reactive({dataIn}),
      filename = filename
    )
  }
  
  app <- shiny::shinyApp(ui = ui, server = server)
}
