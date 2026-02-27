#' @title Shiny example module `Pipeline Demo`
#'
#' @description
#' This module contains the configuration informations for the corresponding pipeline.
#' It is called by the `nav_pipeline` module of the package `MagellanNTK`.
#' This documentation is for developers who want to create their own pipelines 
#' nor processes to be managed with `MagellanNTK`.
#' 
#' The name of the server() and ui() functions are formatted with keywords separated by '_', as follows:
#' * first string `mod`: indicates that it is a Shiny module
#' * `pipeline name` is the name of the pipeline to which the process belongs
#' * `process name` is the name of the process itself
#' 
#' This convention is important because MagellanNTK dynamically constructs 
#' the names of the different server and UI functions when calling them.
#' 
#' @param id A `character(1)` which is the 'id' of the module.
#'
#' @param dataIn An instance of the class `MultiAssayExperiment`
#'
#' @param steps.enabled A vector of boolean which has the same length of the steps
#' of the pipeline. This information is used to enable/disable the widgets. It is not
#' a communication variable between the caller and this module, thus there is no
#' corresponding output variable
#'
#' @param remoteReset It is a remote command to reset the module. An `integer()` that
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
#' 
#' wf.path <- system.file('workflow/Demo', package = 'MagellanNTK')
#' 
#' MagellanNTK(wf.path, 'Demo')
#' 
#' MagellanNTK(wf.path, 'Demo_DataGeneration')
#' 
#' MagellanNTK(wf.path, 'Demo_Preprocessing')
#' 
#' MagellanNTK(wf.path, 'Demo_Clustering')
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
Demo_conf <- function(){
  MagellanNTK::Config(
    mode = 'pipeline',
    fullname = 'Demo',
    steps = c('DataGeneration', 'Preprocessing', 'Clustering'),
    mandatory = c(TRUE, TRUE, FALSE)
  )
}



#' @rdname modulePipeline
#' @export
#' 
Demo_ui <- function(id){
  ns <- NS(id)
}




#' @rdname modulePipeline
#' @export
#'
Demo_server <- function(id,
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


