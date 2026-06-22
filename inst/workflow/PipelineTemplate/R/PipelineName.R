#' @title Shiny pipeline module `PipelineTemplate`
#'
#' @description
#' This module contains the configuration informations for the corresponding
#' pipeline. It is called by the `nav_pipeline` module of the package
#' `MagellanNTK`. This documentation is for developers who want to create their
#' own pipelines or processes to be managed with `MagellanNTK`.
#'
#' The name of the _server() and _ui() functions are formatted with the
#' pipeline name `PipelineName`.
#'
#' For more information, see the "Build a pipeline with MagellanNTK" vignette.
#'
#' These functions are used to create the pipeline itself, and in particular to
#' define the various steps that make up the workflow.
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
#' @name PipelineTemplate
#' @importFrom shiny moduleServer reactiveValues observeEvent NS tagList actionLink fluidRow column uiOutput hr reactive fluidPage
#' @importFrom stats setNames
#'
NULL

#' @description The `PipelineName_conf` function is a function that configures
#' the entire pipeline.
#' It is a simple R function, not a Shiny module.
#'
#' @rdname PipelineTemplate
#' @export
#'
PipelineName_conf <- function() {
  MagellanNTK::Config(
    # The complete name of the pipeline, which must be the same as the filename.
    # Replace "PipelineName", by the name of your pipeline.
    # This name must only contain only alphanumerical characters.
    fullname = "PipelineName",

    # Specify that this code will be used to configure a pipeline.
    # It will be used by the nav_pipeline Shiny module 
    # (see core_pipeline.R file).
    # !! Do not modify this line !!
    mode = "pipeline",

    # Describe the list of processes to be added in the pipeline.
    # These should be in the desired order.
    # These names must only contain only alphanumerical characters.
    # Each item in this vector must have a corresponding file in the R directory
    # with the format : `PipelineName_ProcessName`
    steps = c("Process1", "Process2"),

    # Indicates if the steps are mandatory or not.
    # This logical vector must have the same length as the previous
    # vector steps.
    mandatory = c(FALSE, TRUE)
  )
}


#' @description The ui function is the same for every module and should
#' not be modified. This serves to initiate the ns variable, largely used in
#' the _server() function.
#' Do not modify anything in this function.
#'
#' @rdname PipelineTemplate
#' @export
#'
PipelineName_ui <- function(id) {
  ns <- NS(id)
}


#' @description The server function does not need to be modified here as it
#' sets up the pipeline. Just replace "PipelineName" if needed.
#'
#' @rdname PipelineTemplate
#' @export
#'
PipelineName_server <- function(
  id,
  dataIn = reactive({
    NULL
  }),
  steps.enabled = reactive({
    NULL
  }),
  remoteReset = reactive({
    0
  }),
  steps.status = reactive({
    NULL
  }),
  current.pos = reactive({
    1
  }),
  path = NULL
) {
  # Contrary to a process function, there is no widget in this module as they
  # are contained inside of the other modules, and this is to set up the 
  # pipeline.
  # Thus, no modification has to be made here.

  # Those two variables must bet set to NULL in this function.
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
    # !! DO NOT MODIFY THIS LINE !!
    eval(parse(text = MagellanNTK::Module_Return_Func()))
  })
}
