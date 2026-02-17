#' @title Shiny example process module.
#'
#' @description
#' This module contains the configuration informations for the corresponding pipeline.
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
#' In this example, `PipelineDemo_ProcessB_ui()` and `PipelineDemo_ProcessB_server()` define
#' the code for the process `PipelineDemo_ProcessB` which is part of the pipeline called `PipelineDemo`.
#' 
#' @examples
#' if (interactive()){
#' library(MagellanNTK)
#' data(Exp1_R25_prot, package = 'DaparToolshedData')
#' path <- system.file('workflow/PipelineDemo', package = 'Prostar2')
#' shiny::runApp(proc_workflowApp("PipelineDemo_ProcessB", path, dataIn = Exp1_R25_prot))
#' }
#' 
#' @importFrom QFeatures addAssay removeAssay
#' @import DaparToolshed
#' 
NULL

#' @rdname PipelineDemo
#' @export
#' 
PipelineDemo_ProcessB_conf <- function(){
  MagellanNTK::Config(
    fullname = 'PipelineDemo_ProcessB',
    mode = 'process',
    steps = c('Step 1', 'Step 2'),
    mandatory = c(TRUE, FALSE)
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
PipelineDemo_ProcessB_ui <- function(id){
  ns <- NS(id)
}


#' @param id xxx
#'
#' @param dataIn The dataset
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
#' @param steps.status xxx
#' 
#' @param current.pos xxx
#'
#' @rdname PipelineDemo
#' 
#' @importFrom stats setNames rnorm
#' @importFrom shinyjs useShinyjs
#'
#' @export
#' 
PipelineDemo_ProcessB_server <- function(id,
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
    Step1_ProductFactor = 1,
    Step1_Id = 1,
    Step2_Id = 1,
    Step2_MinusFactor = 0
  )
  
  rv.custom.default.values <- list(
    dataIn1 = NULL,
    dataIn2 = NULL,
    history = MagellanNTK::InitializeHistory()
  )
  
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
        content = tagList()
      )
      
    })
    
    
    
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Description', btnEvents()))
      
      req(dataIn())
      rv$dataIn <- dataIn()
      
      rv.custom$dataIn1 <- rv$dataIn
      rv.custom$dataIn2 <- rv$dataIn
      
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Description'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    
    
    # >>>
    # >>> START ------------- Code for step 1 UI---------------
    # >>> 
    
    # >>>> -------------------- STEP 1 : Global UI ------------------------------------
    output$Step1 <- renderUI({
      shinyjs::useShinyjs()
      path <- file.path(system.file('www/css', package = 'MagellanNTK'),'MagellanNTK.css')
      includeCSS(path)
      
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(
          uiOutput(ns("Step1_widgets_UI"))
        ),
        content = tagList(
          DT::DTOutput(ns("Step1_tabs_UI")),
        )
      )
    })
    
    
    
    output$Step1_widgets_UI <- renderUI({
      widget <- tagList(
        selectInput(
          ns('Step1_Id'),
          "Choose assay",
          choices = 1:length(rv.custom$dataIn1),
          selected = rv.widgets$Step1_Id),
        selectInput(
          ns('Step1_ProductFactor'),
          "Multiplicative factor",
          choices = 1:10,
          selected = rv.widgets$Step1_ProductFactor)
      )
      
      MagellanNTK::toggleWidget(widget, rv$steps.enabled["Step1"])
    })
    
    
    
    output$Step1_tabs_UI <- DT::renderDT({
      req(rv.widgets$Step1_Id)
      
      .ind <- as.numeric(rv.widgets$Step1_Id)
      DT::datatable(
        as.data.frame(rv.custom$dataIn1[[.ind]]$assay)
      )
    })
    
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Step1', btnEvents()))
      req(rv.custom$dataIn1)
      
      
      .ind <- as.numeric(rv.widgets$Step1_Id)
      .tmp <- rv.custom$dataIn1[.ind]
      .tmp[[.ind]]$assay <- .tmp[[.ind]]$assay * as.numeric(rv.widgets$Step1_ProductFactor)
      rv.custom$history <- Add2History(rv.custom$history, 'ProcessB', 'Step1', 'Product', rv.widgets$Step1_ProductFactor)
      .tmp[[.ind]]$metadata$history <- rv.custom$history
      .name <- paste0(names(rv.custom$dataIn1)[.ind], '_multiplicated')
      
      # Do.call addDatasets
      rv.custom$dataIn1[.name] <- .tmp
      rv.custom$dataIn2 <- rv.custom$dataIn1
      
      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Step1'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    # <<< END ----------------------- Code for step 1 UI--------------------------
    
    
    # >>> START ----------------------- Code for step 2 UI-------------------------
    
    output$Step2 <- renderUI({
      shinyjs::useShinyjs()
      
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(
          uiOutput(ns("Step2_widgets_UI"))
        ),
        content = tagList(
          DT::DTOutput(ns("Step2_tabs_UI")),
        )
      )
    })
    
    output$Step2_widgets_UI <- renderUI({
      widget <- tagList(
        selectInput(
          ns('Step2_Id'),
          "Choose assay",
          choices = 1:length(rv.custom$dataIn2),
          selected = rv.widgets$Step2_Id),
        selectInput(
          ns('Step2_MinusFactor'),
          "Minus factor",
          choices = 1:10,
          selected = rv.widgets$Step2_MinusFactor)
      )
      
      MagellanNTK::toggleWidget(widget, rv$steps.enabled["Step2"])
      
    })
    
    output$Step2_tabs_UI <- DT::renderDT({
      req(rv.widgets$Step2_Id)
      
      .ind <- as.numeric(rv.widgets$Step2_Id)
      DT::datatable(
        as.data.frame(rv.custom$dataIn2[[.ind]]$assay)
      )
    })
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Step2', btnEvents()))
  
      .ind <- as.numeric(rv.widgets$Step2_Id)
      
      .name <- paste0(names(rv.custom$dataIn2)[.ind], '_minus')
      
      # Do.call addDatasets
      rv.custom$dataIn2[.name] <- rv.custom$dataIn2[.ind]
      
      
      rv.custom$dataIn2[[.name]]$assay <- rv.custom$dataIn2[[.name]]$assay - as.numeric(rv.widgets$Step2_MinusFactor)
      rv.custom$history <- Add2History(rv.custom$history, 'ProcessB', 'Step1', 'Minus', rv.widgets$Step2_MinusFactor)
      rv.custom$dataIn2[[.name]]$metadata$history <- rv.custom$dataIn2[[.name]]$history
      
      # DO NOT MODIFY THE THREE FOLLOWINF LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Step2'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    
    output$Save <- renderUI({
      
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(),
        content = tagList()
      )
    })
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Save', btnEvents()))
      
      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- rv.custom$dataIn2
      rv$steps.status['Save'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    # Insert necessary code which is hosted by MagellanNTK
    # DO NOT MODIFY THIS LINE
    eval(parse(text = MagellanNTK::Module_Return_Func()))
  }
  )
}
