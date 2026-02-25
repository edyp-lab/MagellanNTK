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
#' wf.path <- system.file('workflow/nomPipeline', package = 'MagellanNTK')
#' 
#' MagellanNTK(wf.path, 'nomPipeline')
#' 
#' MagellanNTK(wf.path, 'nomPipeline_DataGeneration')
#' 
#' MagellanNTK(wf.path, 'nomPipeline_Preprocessing')
#' 
#' MagellanNTK(wf.path, 'nomPipeline_Clustering')
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


#' @description The name of this function is the concatenation of the name of the 
#' pipeline (which is also the name of the file) and the suffix "_conf".
#' It is a simple R function, not a Shiny modules
#' @rdname modulePipeline
#' @export
#' 
nomPipeline_conf <- function(){
  MagellanNTK::Config(
    
    # Specify that this code will be used by the nav_pipeline Shiny module (in the file core.pipeline.R)
    # Do not modify the next line !!
    mode = 'pipeline',
    
    
    
    # Gives the complete name of the pipeline (this must be the same as the filename)
    # Can be customized. Replace "nomPipeline", by the name of your pipeline. Must begin
    # with 'Pipeline' without nay ohter character but alphanumerical
    fullname = 'nomPipeline',
    
    # Describe the list of processes you want to insert in the pipeline
    # Each item in this vector must have a corresponding file in the R directory
    # To indicate that the file is part of the nomPipeline, their name is prefixed by 
    # th name of the pipeline
    # For this example below, there must exist the files:
    #   * nomPipeline_Process1.R
    #   * nomPipeline_Process2.R
    #   * nomPipeline_Process3.R
    #   
    # Can be customized
    steps = c(),
    
    # Indicates if the steps are mandatory or not. This vector has the same length
    # as the vector steps
    # Can be customized
    mandatory = c()
  )
}


#' @description Quite empty but necessary beacau it instantiates the variable ns
#' largely used in the function _server()
#' @rdname modulePipeline
#' @export
#' 
#' Do not modify anything in this function
nomPipeline_ui <- function(id){
  ns <- NS(id)
}




#' @description 
#' Do not modify anything in this function. Just replace "nomPipeline" in the name
#' of the function
#' 
#' @rdname modulePipeline
#' @export
#'
nomPipeline_server <- function(id,
  dataIn = reactive({NULL}),
  steps.enabled = reactive({NULL}),
  remoteReset = reactive({0}),
  steps.status = reactive({NULL}),
  current.pos = reactive({1}),
  path = NULL
){

  # Contrary to the simple workflow, there is no widget in this module
  # because all the widgets are provided by the simple workflows.
  # Those two variables must bet set to NULL in this file
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


