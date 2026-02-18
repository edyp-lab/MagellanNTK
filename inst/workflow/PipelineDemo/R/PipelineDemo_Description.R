#' @title Shiny example process module.
#' 
#' @description
#' This module contains the configuration informations for the corresponding pipeline.
#' It is called by the `nav_pipeline` module of the package `MagellanNTK`.
#' 
#' The name of the server and ui functions are formatted with keywords separated by '_', as follows:
#' * first string `mod`: indicates that it is a Shiny module
#' * `pipeline name` is the name of the pipeline to which the process belongs
#' * `process name` is the name of the process itself
#' 
#' This convention is important because MagellanNTK dynamically constructs 
#' the names of the different server and UI functions when calling them.
#' 
#' In this example, `PipelineDemo_Description_ui()` and `PipelineDemo_Description_server()` define
#' the code for the process `PipelineDemo_Description` which is part of the pipeline called `PipelineDemo`.
#' 
#' @examples
#' if (interactive()){
#' library(MagellanNTK)
#' data(lldata, package = 'MagellanNTK')
#' path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
#' shiny::runApp(proc_workflowApp("PipelineDemo_Description", path, dataIn = lldata))
#' }
#' 
#' @importFrom QFeatures addAssay removeAssay
#' @import DaparToolshed
#' 
NULL

#' @rdname PipelineDemo
#' @export
#' 
PipelineDemo_Description_conf <- function(){
  MagellanNTK::Config(
    fullname = 'PipelineDemo_Description',
    mode = 'process'
  )
}

#' @param id A `character(1)` which is the 'id' of the module.
#' 
#' @rdname PipelineDemo
#' 
#' @author Samuel Wieczorek, Manon Gaudin
#' 
#' @export
#'
PipelineDemo_Description_ui <- function(id){
  ns <- NS(id)
}

#' @param id A `character(1)` which is the 'id' of the module.
#' @param dataIn An instance of the class `MultiAssayExperiment`.
#' @param steps.enabled A vector of boolean which has the same length of the steps
#' of the pipeline. This information is used to enable/disable the widgets. It is not
#' a communication variable between the caller and this module, thus there is no
#' corresponding output variable
#' @param remoteReset It is a remote command to reset the module. A boolean that
#' indicates if the pipeline has been reset by a program of higher level
#' Basically, it is the program which has called this module
#' @param steps.status A `logical()` which indicates the status of each step
#' which can be either 'validated', 'undone' or 'skipped'. Enabled or disabled in the UI.
#' @param current.pos A `integer(1)` which acts as a remote command to make
#'  a step active in the timeline. Default is 1.
#'
#' @rdname PipelineDemo
#' 
#' @importFrom stats setNames rnorm
#' @importFrom shinyjs useShinyjs
#' 
#' @export
#' 
PipelineDemo_Description_server <- function(id,
  dataIn = reactive({NULL}),
  steps.enabled = reactive({NULL}),
  remoteReset = reactive({0}),
  steps.status = reactive({NULL}),
  current.pos = reactive({1}),
  path = NULL,
  btnEvents = reactive({NULL})
){
  # Define default selected values for widgets
  # By default, this list is empty for the Description module
  # but it can be customized
  widgets.default.values <- list()
  
  # Define default values for reactive values
  # By default, this list is empty for the Description module
  # but it can be customized
  rv.custom.default.values <- list()
  
  ###########################################################################-
  #
  #----------------------------MODULE SERVER----------------------------------
  #
  ###########################################################################-
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Necessary code hosted by MagellanNTK
    # DO NOT MODIFY THESE LINE
    core.code <- MagellanNTK::Get_Workflow_Core_Code(
      mode = 'process',
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
    output$Description <- renderUI({
      # Find .Rmd file used to describe the step
      file <- normalizePath(file.path(
        system.file('workflow', package = 'MagellanNTK'),
        unlist(strsplit(id, '_'))[1], 
        'md', 
        paste0(id, '.Rmd')))
      
      # Function for layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(),
        content = tagList(
          if (file.exists(file))
            includeMarkdown(file)
          else
            p('No Description available')
        )
      )
    })
    
    # oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Description', btnEvents()))
      
      req(dataIn())
      rv$dataIn <- dataIn()
      
      # Adding to history
      rv.custom$history <- Add2History(rv.custom$history, 'Description', 'Description', 'Initialization', '-')
      
      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- rv$dataIn
      rv$steps.status['Description'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    # Insert necessary code which is hosted by MagellanNTK
    # DO NOT MODIFY THIS LINE
    eval(parse(text = MagellanNTK::Module_Return_Func()))
  }
  )
}
