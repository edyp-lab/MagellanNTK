#' @title Shiny process module `PipelineTemplate_Process1`
#'
#' @description
#' This module contains the configuration informations for the 'Process1'
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
#' These functions are used to create the 'Process1' step.
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
#'   MagellanNTK(wf.path, "PipelineDemo_DataGeneration")
#' }
#'
#' @name PipelineTemplate_Process1
#' @importFrom shiny moduleServer reactiveValues observeEvent NS tagList actionLink fluidRow column uiOutput hr reactive fluidPage
#' @importFrom stats setNames
#'
NULL

#' @description The `PipelineName_Process1_conf` function is a function that
#' configures the 'Process1' step and its sub-steps.
#' It is a simple R function, not a Shiny module.
#'
#' @rdname PipelineTemplate_Process1
#' @export
#'
PipelineName_Process1_conf <- function() {
  MagellanNTK::Config(
    # The complete name of the process, which must be the same as the filename.
    # Replace "PipelineName" by the name of your pipeline and "Process1" by the
    # name of the step.
    # This name must only contain only alphanumerical characters beside the '_'
    # separator between the pipeline name and the process name.
    fullname = "PipelineName_Process1",

    # Specify that this code will be used to configure a process.
    # It will be used by the nav_process Shiny module (see core_process.R file).
    # !! Do not modify this line !!
    mode = "process",

    # Describe the list of sub-steps to be added in the process.
    # These should be in the desired order.
    # These names may include alphanumerical characters, spaces and hyphens,
    # but no special characters.
    steps = c("Sub-step 1"),

    # Indicates if the steps are mandatory or not.
    # This logical vector must have the same length as the previous
    # vector sub-steps.
    mandatory = c(TRUE)
  )
}


#' @description The ui function is the same for every module and should
#' not be modified. This serves to initiate the ns variable, largely used in
#' the _server() function.
#' Do not modify anything in this function.
#'
#' @rdname PipelineTemplate_Process1
#' @export
#'
PipelineName_Process1_ui <- function(id) {
  ns <- NS(id)
}


#' @description The server function defines what happens during the step.
#' Replace "PipelineName" by the name of your pipeline and "Process1" by the
#' name of the step.
#'
#' @rdname PipelineTemplate_Process1
#' @export
#'
PipelineName_Process1_server <- function(
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
  widgets.default.values <- list(
    Substep1_widget1 = NULL
  )

  # Define default values and initialize reactive values that will be used in
  # the process. By default, this list initialize the history but it can be
  # customized if needed and other values added.
  # Values defined in rv.custom.default.values can be accessed through
  # rv.custom$Name
  rv.custom.default.values <- list(
    history = MagellanNTK::InitializeHistory()
  )

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
    #-----------------------------DESCRIPTION-----------------------------------
    #
    ###########################################################################-
    # Defines everything that should be displayed in this sub-step
    # The ‘Description’ sub-step is automatically included in every process and
    # therefore must be defined in each process file
    output$Description <- renderUI({
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

    # Here can be added any additional element

    # This oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      # The core engine in MagellanNTK (found in the core_process.R file)
      # manages the navigation buttons and sends the button's value to all
      # process modules with each click (which is a concatenation of the
      # sub-step name in the process and the number of clicks on the button).
      # In the process modules, this value is retrieved by the btnEvents()
      # variable

      # Filter clicks on the Run/Run -> button from the 'Description' sub-step
      # Specified which sub-step this is associated with
      req(grepl("Description", btnEvents()))

      req(dataIn())
      # Store the current dataset (dataIn()) in the reactive value rv$dataIn
      # This ensure the entry dataset is never modified and can be retrieved
      # in case of a reset
      rv$dataIn <- dataIn()

      # !! DO NOT MODIFY THE THREE FOLLOWING LINES !!
      # Signals that the button has been clicked and the sub-step completed
      dataOut$trigger <- MagellanNTK::Timestamp()
      # Output data. Null has it is not the last sub-step of the process
      dataOut$value <- NULL
      # Updates the validation status of the sub-step
      rv$steps.status["Description"] <- MagellanNTK::stepStatus$VALIDATED
    })

    ###########################################################################-
    #
    #-------------------------------SUB-STEP 1----------------------------------
    #
    ###########################################################################-
    # Defines everything that should be displayed in this sub-step
    output$Substep1 <- renderUI({
      # Function for layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        # Defines the ui elements for the sidebar of the process for
        # the given sub-step
        sidebar = tagList(),
        # Defines the ui elements for the content area of the process for
        # the given sub-step
        content = tagList()
      )
    })

    # This is an example of a widget
    # For clarity, it may be a good practice to use the sub-step name as a
    # prefix for the output name but it is not mandatory
    output$Substep1_widget1_UI <- renderUI({
      # It can be any widget
      # It is important to set the default value to rv.widgets$widgetName
      # to make sure this widget has the default value in case of a reset
      # The id of the widget must be within the ns() function
      widget <- numericInput(ns("Substep1_widget1"),
        "Widget1",
        value = rv.widgets$Substep1_widget1
      )

      # This allows the widget's state to be changed from enabled to disabled
      # (or vice versa) depending on whether the sub-step is enabled or not.
      MagellanNTK::toggleWidget(widget, rv$steps.enabled["Substep1"])
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

      # Filter clicks on the Run/Run -> button from the 'Substep1' sub-step
      # Specified which sub-step this is associated with
      req(grepl("Substep1", btnEvents()))

      req(rv$dataIn)

      # Here can be added what needs to be done on the dataset once the Run
      # button has been clicked

      # Add new Summarized Experiment to the dataset
      # This is a function included in MagellanNTK by default but is not
      # not mandatory to use
      # The name of the new SE must be the name of the Process
      rv$dataIn <- MagellanNTK::addDatasets(
        rv.custom$dataIn2,
        newSE,
        "Process2_Substep2"
      )

      # Records the actions performed at this stage
      rv.custom$history <- Add2History(
        rv.custom$history,
        "Process1",
        "Substep1",
        "Parameter",
        rv.widgets$Substep1_widget1
      )

      len <- length(rv$dataIn)
      # Attach the history to the dataset
      rv$dataIn[[len]] <- SetHistory(rv$dataIn[[len]], rv.custom$history)

      # !! DO NOT MODIFY THE THREE FOLLOWING LINES !!
      # Signals that the button has been clicked and the sub-step completed
      dataOut$trigger <- MagellanNTK::Timestamp()
      # Output data. Null has it is not the last sub-step of the process
      dataOut$value <- NULL
      # Updates the validation status of the sub-step
      rv$steps.status["Substep1"] <- MagellanNTK::stepStatus$VALIDATED
    })

    ###########################################################################-
    #
    #---------------------------------SAVE--------------------------------------
    #
    ###########################################################################-
    # Defines everything that should be displayed in this sub-step
    # The ‘Save’ sub-step is automatically included in every process and
    # therefore must be defined in each process file
    output$Save <- renderUI({
      # Function for the layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        # Defines the ui elements for the sidebar of the process for
        # the given sub-step
        sidebar = tagList(),
        # Defines the ui elements for the content area of the process for
        # the given sub-step
        content = tagList()
      )
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

      req(rv$dataIn)

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
