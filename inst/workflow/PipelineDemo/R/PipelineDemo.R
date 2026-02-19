#' @title Shiny example module `Pipeline Demo`
#'
#' @description
#' This module contains the configuration information for the corresponding pipeline.
#' It is called by the nav_pipeline module of the package MagellanNTK
#' This documentation is for developers who want to create their own pipelines nor processes
#' to be managed with `MagellanNTK`.
#' 
#' @param id xxx
#'
#' @param dataIn An instance of the class `MultiAssayExperiment`
#'
#' @param steps.enabled A vector of boolean which has the same length of the steps
#' of the pipeline. This information is used to enable/disable the widgets. It is not
#' a communication variable between the caller and this module, thus there is no
#' corresponding output variable
#'
#' @param remoteReset It is a remote command to reset the module. A boolean that
#' indicates is the pipeline has been reseted by a program of higher level
#' Basically, it is the program which has called this module
#'
#' @param steps.status A vector of `character()` which indicates the status of each step
#' which can be either 'validated', 'undone' or 'skipped'. Enabled or disabled in the UI.
#' 
#' @param current.pos A `integer(1)` which acts as a remote command to make
#'  a step active in the timeline. Default is 1.
#' 
#' 
#' @examples
#' if (interactive()){
#' library(MagellanNTK)
#' wf.name <- 'PipelineDemo'
#' wf.path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
#' 
#' MagellanNTK(wf.path, wf.name)
#' }
#' 
#' @name modulePipeline
#' @importFrom shiny moduleServer reactiveValues observeEvent NS tagList actionLink 
#' fluidRow column uiOutput hr reactive fluidPage
#' @importFrom stats setNames
#' 
#' @return An instance of the class `MultiAssayExperiment`
#' 
#' 
NULL


#' @rdname modulePipeline
#' @export
#' 
PipelineDemo_conf <- function(){
  MagellanNTK::Config(
    mode = 'pipeline',
    fullname = 'PipelineDemo',
    steps = c('DataGeneration', 'Preprocessing', 'Clustering'),
    mandatory = c(TRUE, TRUE, FALSE)
  )
}



#' @rdname modulePipeline
#' @export
#' 
PipelineDemo_ui <- function(id){
  ns <- NS(id)
}




#' @rdname modulePipeline
#' @export
#'
PipelineDemo_server <- function(id,
  dataIn = reactive({NULL}),
  steps.enabled = reactive({NULL}),
  remoteReset = reactive({0}),
  steps.status = reactive({NULL}),
  current.pos = reactive({1}),
  path = NULL
){

    # Contrary to the simple workflow, there is no widget in this module
  # because all the widgets are provided by the simple workflows.
  widgets.default.values <- NULL
  rv.custom.default.values <- NULL
  
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    core.code <- MagellanNTK::Get_Workflow_Core_Code(
      name = id,
      w.names = names(widgets.default.values),
      rv.custom.names = names(rv.custom.default.values)
    )
    
    eval(str2expression(core.code))

    # Insert necessary code which is hosted by MagellanNTK
    # DO NOT MODIFY THIS LINE
    eval(parse(text = MagellanNTK::Module_Return_Func()))
  }
  )
}


