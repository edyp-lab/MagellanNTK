#' @title Shiny process module `PipelineTemplate_Save`
#'
#' @description
#' This module contains the configuration informations for the 'Save'
#' step of the workflow. It is called by the `nav_pipeline` module of the
#' package `MagellanNTK`. This documentation is for developers who want to
#' create their own pipelines or processes to be managed with `MagellanNTK`.
#'
#' The name of the _server() and _ui() functions are formatted as follows :
#' `PipelineName_ProcessName` with :
#' * `PipelineName` is the name of the pipeline to which the process belongs
#' * `ProcessName` is the name of the process itself
#'
#' For more information, see the "Build a pipeline with MagellanNTK" vignette.
#'
#' These functions are used to create the 'Save' step.
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
#'   MagellanNTK(wf.path, "PipelineDemo_Save")
#' }
#'
#' @name PipelineTemplate_Save
#' @importFrom shiny moduleServer reactiveValues observeEvent NS tagList actionLink fluidRow column uiOutput hr reactive fluidPage
#' @importFrom stats setNames
#'
NULL

#' @description The `PipelineName_Save_conf` function is a function that
#' configures the 'Save' step and its sub-steps.
#' It is a simple R function, not a Shiny module.
#'
#' @rdname PipelineTemplate_Save
#' @export
#'
PipelineName_Save_conf <- function() {
  MagellanNTK::Config(
    # The complete name of the process, which must be the same as the filename.
    # Replace "PipelineName" by the name of your pipeline.
    # This name must only contain only alphanumerical characters beside the '_'
    # separator between the pipeline name and the process name.
    fullname = "PipelineName_Save",

    # Specify that this code will be used to configure a process.
    # It will be used by the nav_process Shiny module (see core_process.R file).
    # !! Do not modify this line !!
    mode = "process"

    # As this process contains no sub-steps (apart from the “Save”
    # sub-step, which does not require explicit definition), it does not require
    # the 'step' and 'mandatory' arguments
  )
}


#' @description The ui function is the same for every module and should
#' not be modified. This serves to initiate the ns variable, largely used in
#' the _server() function.
#' Do not modify anything in this function.
#'
#' @rdname PipelineTemplate_Save
#' @export
#'
PipelineName_Save_ui <- function(id) {
  ns <- NS(id)
}


#' @description The server function defines what happens during the step.
#' Replace "PipelineName" by the name of your pipeline.
#'
#' @rdname PipelineTemplate_Save
#' @export
#'
PipelineName_Save_server <- function(
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
  btnEvents = reactive({
    NULL
  })
) {
  # Define default values and initialize widgets that will be used in the
  # process. It can be customized if needed.
  # Values defined in widgets.default.values are accessible via rv.widgets$Name
  widgets.default.values <- list()

  # Define default values and initialize reactive values that will be used in
  # the process. It can be customized if needed.
  # Values defined in rv.custom.default.values can be accessed through
  # rv.custom$Name
  rv.custom.default.values <- list()

  ###########################################################################-
  #
  #----------------------------MODULE SERVER----------------------------------
  #
  ###########################################################################-
  # Initiates the creation of the module
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Necessary code hosted by MagellanNTK
    # Initiates the various variables required for the module to function,
    # such as the widgets values and reactive values
    # !! DO NOT MODIFY THESE LINES !!
    core.code <- MagellanNTK::Get_Workflow_Core_Code(
      mode = "process",
      name = id,
      w.names = names(widgets.default.values),
      rv.custom.names = names(rv.custom.default.values)
    )

    eval(str2expression(core.code))

    ###########################################################################-
    #
    #---------------------------------SAVE--------------------------------------
    #
    ###########################################################################-
    # Defines everything that should be displayed in this sub-step
    output$Save <- renderUI({
      # Find .Rmd file used to describe the step inside the 'md' directory
      # of the pipeline
      file <- normalizePath(file.path(
        system.file("workflow", package = "MagellanNTK"),
        unlist(strsplit(id, "_"))[1],
        "md",
        paste0(id, ".Rmd")
      ))

      # Function for the layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        # Defines the ui elements for the sidebar of the process for
        # the given sub-step
        sidebar = tagList(),
        # Defines the ui elements for the content area of the process for
        # the given sub-step
        content = tagList(
          # If a file has been found, it it displayed in the content area
          if (file.exists(file)) {
            includeMarkdown(file)
          } else {
            p("No Description available")
          }
        )
      )
    })

    # This allows to access data in the Save sub-step
    # without a Description sub-step
    observeEvent(req(dataIn()), {
      rv$dataIn <- dataIn()
    })

    # Here can be added any additional element

    # This oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      # The core engine in MagellanNTK (found in the core_process.R file)
      # manages the navigation buttons and sends the button's value to all
      # process modules with each click (which is a concatenation of the
      # sub-step name in the process and the number of clicks on the button).
      # In the process modules, this value is retrieved by the btnEvents()
      # variable

      # Filter clicks on the Run/Run -> button from the 'Save' sub-step
      # Specified which sub-step this is associated with
      req(grepl("Save", btnEvents()))

      # Here can be added what needs to be done on the dataset once the Run
      # button has been clicked

      # !! DO NOT MODIFY THE THREE FOLLOWING LINES !!
      # Signals that the button has been clicked and the sub-step completed
      dataOut$trigger <- MagellanNTK::Timestamp()
      # Output data. Non-null has it is the last sub-step of the process
      dataOut$value <- rv$dataIn
      # Updates the validation status of the sub-step
      rv$steps.status["Save"] <- MagellanNTK::stepStatus$VALIDATED
    })

    # Insert necessary code which is hosted by MagellanNTK
    # !! DO NOT MODIFY THIS LINE !!
    eval(parse(text = MagellanNTK::Module_Return_Func()))
  })
}
