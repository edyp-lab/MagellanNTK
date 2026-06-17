#' @title Shiny process module `PipelineTemplate_Convert`
#'
#' @description
#' ...
#'
#' The name of the _server() and _ui() functions are formatted as follows : 
#' `PipelineName_ProcessName` with :
#' * `PipelineName` is the name of the pipeline to which the process belongs
#' * `ProcessName` is the name of the process itself
#' 
#' For more information, see the "Build a pipeline with MagellanNTK" vignette.
#'
#' ...
#'
#' @param id A `character(1)` which is the 'id' of the module.
#' @param dataIn An instance of the class `MultiAssayExperiment`.
#' @param steps.enabled A vector of boolean which has the same length of the
#' steps of the pipeline. This information is used to enable/disable the
#' widgets. It is not a communication variable between the caller and this
#' module, thus there is no corresponding output variable.
#' @param remoteReset It is a remote command to reset the module. An
#' `integer()` that indicates is the pipeline has been reseted by a program of
#' higher level Basically, it is the program which has called this module.
#' @param steps.status A vector of `character()` which indicates the status of
#' each step which can be either 'validated', 'undone' or 'skipped'. Enabled or
#' disabled in the UI.
#' @param current.pos A `integer(1)` which acts as a remote command to make
#' a step active in the timeline. Default is 1.
#'
#' @return An instance of the class `MultiAssayExperiment`.
#'
#' @examples
#' if (interactive()) {
#'   wf.path <- system.file("workflow/PipelineDemo", package = "MagellanNTK")
#'
#'   MagellanNTK(wf.path, "PipelineDemo")
#'
#'   MagellanNTK(wf.path, "PipelineDemo_DataGeneration")
#'
#'   MagellanNTK(wf.path, "PipelineDemo_Preprocessing")
#'
#'   MagellanNTK(wf.path, "PipelineDemo_Clustering")
#' }
#' 
#' @name PipelineTemplate_Convert
#' @importFrom shiny moduleServer reactiveValues observeEvent NS tagList actionLink fluidRow column uiOutput hr reactive fluidPage
#' @importFrom stats setNames
#'
NULL

#' @description The `PipelineName_Convert_conf` function ...
#'
#' @rdname PipelineTemplate_Convert
#' @export
#'
PipelineName_Convert_conf <- function(){
  # This list contains the basic configuration of the process
  MagellanNTK::Config(
    fullname = 'PipelineName_Convert',
    # Define the type of module
    mode = 'process',
    # List of all steps of the process
    steps = c('Step1'),
    # A vector of boolean indicating if the steps are mandatory or not.
    mandatory = c(TRUE)
    
  )
}

#' @description The ui function is the same for every module and should
#' not be modified. This serves to initiate the ns variable, largely used in
#' the _server() function.
#' Do not modify anything in this function.
#' 
#' @rdname PipelineTemplate_Convert
#' @export
#' 
PipelineName_Convert_ui <- function(id) {
  ns <- NS(id)
}

#' @description ...
#'
#' @rdname PipelineTemplate_Convert
#' @export
#'
PipelineName_Convert_server <- function(id,
  dataIn = reactive({NULL}),
  steps.enabled = reactive({TRUE}),
  remoteReset = reactive({NULL}),
  steps.status = reactive({NULL}),
  current.pos = reactive({1}),
  btnEvents = reactive({NULL})
) {
  
  widgets.default.values <- list()
  
  rv.custom.default.values <- list()
  
  
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
      
      MagellanNTK::process_layout_process(session,
        ns = NS(id),
        sidebar = tagList(),
        content = tagList()
      )
    })
    
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(grepl('Description', btnEvents()))

        rv$dataIn <- dataIn()
        dataOut$trigger <- MagellanNTK::Timestamp()
        dataOut$value <- rv$dataIn
        rv$steps.status['Description'] <- MagellanNTK::stepStatus$VALIDATED
    })
    

    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(grepl('Step1', btnEvents()))
          
      # DO NOT MODIFY THE THREE FOLLOWINF LINES
    dataOut$trigger <- MagellanNTK::Timestamp()
     dataOut$value <- NULL
    rv$steps.status['SelectFile'] <- MagellanNTK::stepStatus$VALIDATED
    })
    

    
    output$Save <- renderUI({
      MagellanNTK::process_layout_process(session,
        ns = NS(id),
        sidebar = tagList(),
        content = tagList()
      )
    })
    
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(grepl('Save', btnEvents()))
      
      # DO NOT MODIFY THE THREE FOLLOWINF LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- rv$dataIn
      rv$steps.status['Save'] <- MagellanNTK::stepStatus$VALIDATED
    })
    # Insert necessary code which is hosted by MagellanNTK
    # DO NOT MODIFY THIS LINE
    eval(parse(text = MagellanNTK::Module_Return_Func()))
  })
}
