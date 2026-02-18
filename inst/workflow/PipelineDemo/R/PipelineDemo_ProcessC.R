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
#' In this example, `PipelineDemo_ProcessC_ui()` and `PipelineDemo_ProcessC_server()` define
#' the code for the process `PipelineDemo_ProcessC` which is part of the pipeline called `PipelineDemo`.
#' 
#' @examples
#' if (interactive()){
#' library(MagellanNTK)
#' data(Exp1_R25_prot, package = 'DaparToolshedData')
#' path <- system.file('workflow/PipelineDemo', package = 'Prostar2')
#' shiny::runApp(proc_workflowApp("PipelineDemo_ProcessC", path, dataIn = Exp1_R25_prot))
#' }
#' 
#' @importFrom QFeatures addAssay removeAssay
#' @import DaparToolshed
#' 
NULL

#' @rdname PipelineDemo
#' @export
#' 
PipelineDemo_ProcessC_conf <- function(){
  MagellanNTK::Config(
    fullname = 'PipelineDemo_ProcessC',
    mode = 'process',
    steps = c('Divide', 'Addition'),
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
PipelineDemo_ProcessC_ui <- function(id){
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
PipelineDemo_ProcessC_server <- function(id,
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
    Divide_Factor = 1,
    Divide_Id = 1,
    Addition_Id = 1,
    Addition_Factor = 0
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
      
      rv.custom$dataIn1 <- rv.custom$dataIn2 <- rv$dataIn
      
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Description'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    
    
    # >>>
    # >>> START ------------- Code for step 1 UI---------------
    # >>> 
    
    # >>>> -------------------- STEP 1 : Global UI ------------------------------------
    output$Divide <- renderUI({
      shinyjs::useShinyjs()
      path <- file.path(system.file('www/css', package = 'MagellanNTK'),'MagellanNTK.css')
      includeCSS(path)
      
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(
          uiOutput(ns("Divide_widgets_UI"))
        ),
        content = tagList(
          DT::DTOutput(ns("Divide_tabs_UI")),
        )
      )
    })
    
    
    
    output$Divide_widgets_UI <- renderUI({
      widget <- tagList(
        selectInput(
          ns('Divide_Id'),
          "Choose assay",
          choices = 1:length(rv.custom$dataIn1),
          selected = rv.widgets$Divide_Id),
        selectInput(
          ns('Divide_Factor'),
          "Division factor",
          choices = 1:10,
          selected = rv.widgets$Divide_Factor)
      )
      
      MagellanNTK::toggleWidget(widget, rv$steps.enabled["Divide"])
    })
    
    
    
    output$Divide_tabs_UI <- DT::renderDT({
      req(rv.widgets$Divide_Id)
      .ind <- as.numeric(rv.widgets$Divide_Id)
      DT::datatable(
        SummarizedExperiment::assay(rv.custom$dataIn1, .ind)
      )
    })
    
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Divide', btnEvents()))
      req(rv.custom$dataIn1)

      

      .ind <- as.numeric(rv.widgets$Divide_Id)
      .tmp <- rv.custom$dataIn1[[.ind]]
      .assay <- SummarizedExperiment::assay(.tmp)
      .product <- .assay / as.numeric(rv.widgets$Divide_Factor)
      SummarizedExperiment::assay(.tmp) <- .product
      rv.custom$history <- Add2History(rv.custom$history, 'ProcessC', 'Divide', 'Product', rv.widgets$Divide_Factor)

      rv.custom$dataIn1 <- do.call(
        eval(parse(text = session$userData$funcs$addDatasets)), 
        list(object = rv.custom$dataIn1, 
          dataset = .tmp,
          name = paste0(names(rv.custom$dataIn1)[.ind], '_divided')
        )
      )
      rv.custom$dataIn2 <- rv.custom$dataIn1
     
      
      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Divide'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    # <<< END ----------------------- Code for step 1 UI--------------------------
    
    
    # >>> START ----------------------- Code for step 2 UI-------------------------
    
    output$Addition <- renderUI({
      shinyjs::useShinyjs()
      
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(
          uiOutput(ns("Addition_widgets_UI"))
        ),
        content = tagList(
          DT::DTOutput(ns("Addition_tabs_UI"))
        )
      )
    })
    
    output$Addition_widgets_UI <- renderUI({
      widget <- tagList(
        selectInput(
          ns('Addition_Id'),
          "Choose assay",
          choices = 1:length(rv.custom$dataIn2),
          selected = rv.widgets$Addition_Id),
        selectInput(
          ns('Addition_Factor'),
          "Minus factor",
          choices = 1:10,
          selected = rv.widgets$Addition_Factor)
      )
      
      MagellanNTK::toggleWidget(widget, rv$steps.enabled["Addition"])
      
    })
    
    output$Addition_tabs_UI <- DT::renderDT({
      req(rv.widgets$Addition_Id)
      
      .ind <- as.numeric(rv.widgets$Addition_Id)
      DT::datatable(
        SummarizedExperiment::assay(rv.custom$dataIn2, .ind)
      )
    })
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Addition', btnEvents()))
  
      
      
      .ind <- as.numeric(rv.widgets$Addition_Id)
      .tmp <- rv.custom$dataIn2[[.ind]]
      .assay <- SummarizedExperiment::assay(.tmp)
      .result <- .assay - as.numeric(rv.widgets$Addition_Factor)
      SummarizedExperiment::assay(.tmp) <- .result
      rv.custom$history <- Add2History(rv.custom$history, 'ProcessC', 'Addition', 'Addition', rv.widgets$Addition_Factor)
      
      rv.custom$dataIn2 <- c(rv.custom$dataIn2, newEL = .tmp)
      names(rv.custom$dataIn2)[length(rv.custom$dataIn2)] <- paste0(names(rv.custom$dataIn2)[.ind], '_addition')
      
      
      # DO NOT MODIFY THE THREE FOLLOWINF LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Addition'] <- MagellanNTK::stepStatus$VALIDATED
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
      
      
    
      len_start <- length(rv$dataIn)
      len_end <- length(rv.custom$dataIn2)
      len_diff <- len_end - len_start
      
      req(len_diff > 0)
      
      if (len_diff == 2)
        rv.custom$dataIn2 <- keepDatasets(rv.custom$dataIn2, -(len_end - 1))
      
      # Rename the new dataset with the name of the process
      names(rv.custom$dataIn2)[length(rv.custom$dataIn2)] <- 'ProcessC'

      len <- length(rv.custom$dataIn2)
      rv.custom$dataIn2[[len]] <- SetHistory(rv.custom$dataIn2[[len]], rv.custom$history)
      
      
      
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
