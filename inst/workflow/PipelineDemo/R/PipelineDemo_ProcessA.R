#' @title Shiny example process module.
#'
#' @description
#' This module contains the configuration information for the corresponding pipeline.
#' It is called by the nav_pipeline module of the package MagellanNTK
#' 
#' The name of the server and ui functions are formatted with keywords separated by '_', as follows:
#' * first string `mod`: indicates that it is a Shiny module
#' * `pipeline name` is the name of the pipeline to which the process belongs
#' * `process name` is the name of the process itself
#' 
#' This convention is important because MagellanNTK call the different
#' server and ui functions by building dynamically their name.
#' 
#' In this example, `PipelineDemo_ProcessA_ui()` and `PipelineDemo_ProcessA_server()` define
#' the code for the process `ProcessProtein` which is part of the pipeline called `PipelineDemo`.
#' 
#' @example inst/workflow/PipelineDemo/examples/example_PipelineDemo_ProcessA.R
#' 
#' @importFrom QFeatures addAssay removeAssay
#' @import DaparToolshed
#' 
NULL

#' @rdname PipelineDemo
#' @export
#' 
PipelineDemo_ProcessA_conf <- function(){
  MagellanNTK::Config(
    fullname = 'PipelineDemo_ProcessA',
    mode = 'process',
    steps = c('Duplicate data'),
    mandatory = c(FALSE)
  )
}


#' @param id xxx
#' 
#' @rdname PipelineDemo
#' 
#' @author Samuel Wieczorek
#' 
#' @export
#'
PipelineDemo_ProcessA_ui <- function(id){
  ns <- NS(id)
  shinyjs::useShinyjs()
}


#' @param id xxx
#'
#' @param dataIn An instance of the class 
#'
#' @param steps.enabled A vector of boolean which has the same length of the steps
#' of the pipeline. This information is used to enable/disable the widgets. It is not
#' a communication variable between the caller and this module, thus there is no
#' corresponding output variable
#'
#' @param remoteReset It is a remote command to reset the module. A boolean that
#' indicates if the pipeline has been reset by a program of higher level
#' Basically, it is the program which has called this module
#' 
#' @param steps.status xxx
#' 
#' @param current.pos xxx
#' 
#'
#' @rdname PipelineDemo
#' 
#' @importFrom stats setNames rnorm
#' @import omXplore
#' @importFrom shinyjs hidden useShinyjs toggle
#' @importFrom QFeatures addAssay
#' 
#' @export
#' 
PipelineDemo_ProcessA_server <- function(id,
  dataIn = reactive({NULL}),
  steps.enabled = reactive({NULL}),
  remoteReset = reactive({0}),
  steps.status = reactive({NULL}),
  current.pos = reactive({1}),
  btnEvents = reactive({NULL})
){
  
  # Define default selected values for widgets
  # This is only for simple workflows
  widgets.default.values <- list(
    Duplicatedata_duplicate = NULL)
  
  rv.custom.default.values <- list(
    history = MagellanNTK::InitializeHistory()
  )
  
  ###-------------------------------------------------------------###
  ###                                                             ###
  ### ------------------- MODULE SERVER --------------------------###
  ###                                                             ###
  ###-------------------------------------------------------------###
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    
    core.code <- MagellanNTK::Get_Workflow_Core_Code(
      mode = 'process',
      name = id,
      w.names = names(widgets.default.values),
      rv.custom.names = names(rv.custom.default.values)
    )
    
    eval(str2expression(core.code))

    output$Description <- renderUI({
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(),
        content = tagList(
          DT::DTOutput(ns('Duplicatedata_tabs_UI'))
        )
      )
      
    })
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(grepl('Description', btnEvents()))
      req(dataIn())
      rv$dataIn <- dataIn()

        dataOut$trigger <- MagellanNTK::Timestamp()
        dataOut$value <- NULL
        rv$steps.status['Description'] <- MagellanNTK::stepStatus$VALIDATED
      })

    # >>>> -------------------- STEP 1 : Global UI ------------------------------------
    output$Duplicatedata <- renderUI({
      shinyjs::useShinyjs()

      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(
          uiOutput(ns('Duplicatedata_duplicate_ui'))
        ),
        content = tagList()
      )
    })
    
    output$Duplicatedata_tabs_UI <- DT::renderDT({
      req(rv.widgets$Step1_Id)
      
      .ind <- as.numeric(rv.widgets$Duplicatedata_duplicate)
      DT::datatable(
        SummarizedExperiment::assay(rv$dataIn,.ind)
      )
    })
    
    output$Duplicatedata_duplicate_ui <- renderUI({
      widget <- selectInput(
        ns('Duplicatedata_duplicate'),
        "Duplicate",
        choices = 1:length(rv$dataIn),
        selected = rv.widgets$Duplicatedata_duplicate)
      
      MagellanNTK::toggleWidget(widget, rv$steps.enabled["Duplicatedata"])
    })
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(grepl('Duplicatedata', btnEvents()))

      .ind <- as.numeric(rv.widgets$Duplicatedata_duplicate)
      .tmp <- rv$dataIn[[.ind]]
      
      #browser()
      rv$dataIn <- do.call(
        eval(parse(text = session$userData$funcs$addDatasets)), 
        list(object = rv$dataIn, 
          dataset = .tmp,
          name = 'ProcessA'
        )
      )
  

          # DO NOT MODIFY THE THREE FOLLOWING LINES
          dataOut$trigger <- MagellanNTK::Timestamp()
          dataOut$value <- NULL
          rv$steps.status['Duplicatedata'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    
    # >>> START ------------- Code for step 3 UI---------------
    output$Save <- renderUI({
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(),
        content = tagList()
      )
    })

    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(grepl('Save', btnEvents()))
        
          dataOut$trigger <- MagellanNTK::Timestamp()
          dataOut$value <- rv$dataIn
          rv$steps.status['Save'] <- MagellanNTK::stepStatus$VALIDATED

      })

    # Insert necessary code which is hosted by MagellanNTK
    # DO NOT MODIFY THIS LINE
    eval(parse(text = MagellanNTK::Module_Return_Func()))
})

}
