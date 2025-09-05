#' @title Shiny example process module.
#'
#' @description
#' This module contains the configuration information for the corresponding pipeline.
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
#' In this example, `PipelineDemo_Process2_ui()` and `PipelineDemo_Process2_server()` define
#' the code for the process `ProcessDemo` which is part of the pipeline called `PipelineDemo`.
#'
#' @name example_module_Process2
#' 
#' @param id xxx
#' @param dataIn The dataset
#' @param steps.enabled A vector of boolean which has the same length of the steps
#' of the pipeline. This information is used to enable/disable the widgets. It is not
#' a communication variable between the caller and this module, thus there is no
#' corresponding output variable
#' @param remoteReset It is a remote command to reset the module. A boolean that
#' indicates is the pipeline has been reseted by a program of higher level
#' Basically, it is the program which has called this module
#' @param steps.status xxx
#' @param current.pos xxx
#' @param path xxx
#' 
#' 
#' 
#' 
#' 
#' @author Samuel Wieczorek
#' 
#' 
NULL

#' @rdname example_module_Process2
#' @export
#' 
PipelineDemo_Process2_conf <- function(){
  Config(
    fullname = 'PipelineDemo_Process2',
    mode = 'process',
    steps = c('Step 1'),
    mandatory = c(FALSE)
  )
}


#' @rdname example_module_Process2
#' 
#' @export
#'
PipelineDemo_Process2_ui <- function(id){
  ns <- NS(id)
}



#' @rdname example_module_Process2
#' 
#' @importFrom stats setNames rnorm
#' 
#' @export
#' 
PipelineDemo_Process2_server <- function(id,
  dataIn = reactive({NULL}),
  steps.enabled = reactive({NULL}),
  remoteReset = reactive({NULL}),
  steps.status = reactive({NULL}),
  current.pos = reactive({1}),
  path = NULL,
  btnEvents = reactive({NULL})
){
  
  #source(paste0(path, '/foo.R'), local=TRUE)$value
  
  # Define default selected values for widgets
  # This is only for simple workflows
  widgets.default.values <- list(
    Step1_select1 = 1,
    Step1_select2 = NULL,
    Step1_select3 = 1,
    Step1_radio1 = NULL,
    Step1_btn1 = NULL,
    Step2_select1 = 1,
    Step2_select2 = 1
  )
  
  
  rv.custom.default.values <- list(
    foo = NULL
  )
  
  ###-------------------------------------------------------------###
  ###                                                             ###
  ### ------------------- MODULE SERVER --------------------------###
  ###                                                             ###
  ###-------------------------------------------------------------###
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Insert necessary code which is hosted by MagellanNTK
    # DO NOT MODIFY THIS LINE
    core.code <- Get_Workflow_Core_Code(
      mode = 'process',
      name = id,
      w.names = names(widgets.default.values),
      rv.custom.names = names(rv.custom.default.values)
    )
    
    eval(str2expression(core.code))
    
    
    # >>>
    # >>> START ------------- Code for Description UI---------------
    # >>> 
    
    
    output$Description <- renderUI({
      file <- normalizePath(file.path(session$userData$workflow.path, 
        'md', paste0(id, '.md')))
      
      req(file)
      MagellanNTK::process_layout(
        ns = NS(id),
        sidebar = tagList(),
        #timeline_process_ui(ns('Description_timeline')),
        content = tagList(
          if (file.exists(file))
            includeMarkdown(file)
          else
            p('No Description available')
        )
      )
      
    })
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(btnEvents()=='Description')
      req(dataIn())
      rv$dataIn <- dataIn()
      rv.custom$dataIn1 <- dataIn()
      rv.custom$dataIn2 <- dataIn()
      
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- rv$dataIn
      rv$steps.status['Description'] <- stepStatus$VALIDATED
    })
    
    
    # >>>
    # >>> START ------------- Code for step 1 UI---------------
    # >>> 
    
    # >>>> -------------------- STEP 1 : Global UI ------------------------------------
    output$Step1 <- renderUI({
      shinyjs::useShinyjs()
      path <- file.path(system.file('www/css', package = 'MagellanNTK'),'MagellanNTK.css')
      includeCSS(path)
      
      MagellanNTK::process_layout(
        ns = NS(id),
        sidebar = tagList(
          # timeline_process_ui(ns('POVImputation_timeline')),
          uiOutput(ns("Step1_btn1_ui")),
          uiOutput(ns("Step1_select1_ui")),
          uiOutput(ns("Step1_select2_ui"))
        ),
        content = tagList(
          plotOutput(ns("Step1_showPlot"))
        )
      )
    })
    
    
    # >>> START: Definition of the widgets
    
    
    
    
    # rv.custom$foo <- foo_server('foo',
    #   dataIn = reactive({rv$dataIn}),
    #   reset = reactive({NULL}),
    #   is.enabled = reactive({rv$steps.enabled['Step1']})
    # )
    
    
    
    output$Step1_btn1_ui <- renderUI({
      widget <- actionButton(ns('Step1_btn1'), 'Button',
        class = btn_success_color)
      toggleWidget(widget, rv$steps.enabled['Step1'] )
      #toggleWidget(widget, TRUE )
    })
    
    # This part must be customized by the developer of a new module
    output$Step1_select1_ui <- renderUI({
      widget <- selectInput(ns('Step1_select1'), 'Select',
        choices = 1:4,
        selected = rv.widgets$Step1_select1,
        width = '150px')
      toggleWidget(widget, rv$steps.enabled['Step1'] )
    })
    
    
    output$Step1_select2_ui <- renderUI({
      widget <- selectInput(ns('Step1_select2'), 'Select',
        choices = 1:4,
        selected = rv.widgets$Step1_select2,
        width = '150px')
      toggleWidget(widget, rv$steps.enabled['Step1'])
    })
    
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(btnEvents()=='Step1')
      req(rv$dataIn)
      
      
      # Do some stuff
      
      # DO NOT MODIFY THE THREE FOLLOWINF LINES
      dataOut$trigger <- Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Step1'] <- stepStatus$VALIDATED
      
    })
    
    
    output$Step1_showPlot <- renderPlot({
      plot(1:10)
    })
    # <<< END ------------- Code for step 1 UI---------------
    
    
    # >>> START ------------- Code for step 2 UI---------------
    
    output$Step2 <- renderUI({
      shinyjs::useShinyjs()
      path <- file.path(system.file('www/css', package = 'MagellanNTK'),'MagellanNTK.css')
      includeCSS(path)
      
      MagellanNTK::process_layout(
        ns = NS(id),
        sidebar = tagList(
          uiOutput(ns("Step2_select1_ui")),
          uiOutput(ns("Step2_select2_ui"))
        ),
        content = tagList(
          uiOutput(ns("POVImputation_showDetQuantValues")),
          htmlOutput("helpForImputation"),
          tags$hr(),
          uiOutput(ns('mvplots_ui'))
        )
      )
    })
    
    
    output$Step2_select1_ui <- renderUI({
      widget <- selectInput(ns('Step2_select1'), 'Select',
        choices = 1:4,
        selected = rv.widgets$Step2_select1,
        width = '150px')
      toggleWidget(widget, rv$steps.enabled['Step2'] )
    })
    
    output$Step2_select2_ui <- renderUI({
      widget <- selectInput(ns('Step2_select2'), 'Select',
        choices = 1:4,
        selected = rv.widgets$Step2_select2,
        width = '150px')
      toggleWidget(widget, rv$steps.enabled['Step2'] )
    })
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(btnEvents()=='Step2')
      req(rv$dataIn)
      
      
      # Do some stuff
      
      # DO NOT MODIFY THE THREE FOLLOWINF LINES
      dataOut$trigger <- Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Step2'] <- stepStatus$VALIDATED
    })
    
    # <<< END ------------- Code for step 2 UI---------------
    
    
    # >>> START ------------- Code for step 'Save' UI---------------
    output$Save <- renderUI({
      MagellanNTK::process_layout(
        ns = NS(id),
        sidebar = tagList(
          #timeline_process_ui(ns('Save_timeline'))
        ),
        content = uiOutput(ns('dl_ui'))
      )
    })
    
    output$dl_ui <- renderUI({
      req(rv$steps.status['Save'] == stepStatus$VALIDATED)
      req(config@mode == 'process')
      
      MagellanNTK::download_dataset_ui(ns('createQuickLink'))
    })
    
    output$Save_btn_validate_ui <- renderUI({
      tagList(
        if (config@mode == 'process' && 
            rv$steps.status['Save'] == stepStatus$VALIDATED) {
          download_dataset_ui(ns('createQuickLink'))
        }
      )
    })
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(btnEvents()=='Save')
      # Do some stuff
      #browser()
      rv$dataIn <- MagellanNTK::addDatasets(
        object = rv$dataIn,
        dataset = 10*rv$dataIn[[length(rv$dataIn)]],
        name = 'Process2')
      
      # DO NOT MODIFY THE THREE FOLLOWINF LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- rv$dataIn
      rv$steps.status['Save'] <- stepStatus$VALIDATED
      download_dataset_server('createQuickLink', 
        dataIn = reactive({rv$dataIn}))
      
    })
    # <<< END ------------- Code for step 3 UI---------------
    
    
    #dataOu$widgets <- 
    # Insert necessary code which is hosted by MagellanNTK
    # DO NOT MODIFY THIS LINE
    eval(parse(text = Module_Return_Func()))
  }
  )
}