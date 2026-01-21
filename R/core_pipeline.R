#' @title The server() function of the module `nav_pipeline`
#'
#' @description The module navigation can be launched via a Shiny app.
#' This is the core module of MagellanNTK
#'
#' @param id A `character(1)` which defines the id of the module. It is the same
#' as for the ui() function.
#'
#' @param dataIn The dataset
#'
#' @param is.enabled A `boolean`. This variable is a remote command to specify
#' if the corresponding module is enabled/disabled in the calling module of
#' upper level.
#' For example, if this module is part of a pipeline and the pipeline calculates
#' that it is disabled (i.e. skipped), then this variable is set to TRUE. Then,
#' all the widgets will be disabled. If not, the enabling/disabling of widgets
#' is deciding by this module.
#'
#' @param remoteReset It is a remote command to reset the module. A boolen that
#' indicates is the pipeline has been reseted by a program of higher level
#' Basically, it is the program which has called this module
#'
#' @param is.skipped xxx
#' @param verbose = FALSE,
#' @param usermod = 'user'
#'
#'
#'
#'
#'
#' @return A list of four items:
#' * dataOut A dataset of the same class of the parameter dataIn
#' * steps.enabled A vector of `boolean` of the same length than config@steps
#' * status A vector of `integer(1)` of the same length than the config@steps
#'   vector
#' * reset xxxx
#'
#' @examples
#' if (interactive()) {
#'     library(shiny)
#'     nav_pipeline()
#' }
#'
#' @name nav_pipeline
#'
#' @author Samuel Wieczorek
#'
NULL


#' @param id A `character(1)` which defines the id of the module.
#' It is the same as for the server() function.
#'
#' @rdname nav_pipeline
#' @import shiny
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#'
#' @export
#'
nav_pipeline_ui <- function(id) {
  ns <- NS(id)
  
  div(
    style = "width: 100%;",
    uiOutput(ns('pipeline_panel_ui')),
    uiOutput(ns('pipeline_tl_btn_ui'))
  
  )
}



#'
#' @export
#'
#' @rdname nav_pipeline
#' @importFrom stats setNames
#' @importFrom crayon blue yellow
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#'
nav_pipeline_server <- function(
    id = NULL,
  dataIn = reactive({NULL}),
  is.enabled = reactive({TRUE}),
  remoteReset = reactive({0}),
  is.skipped = reactive({FALSE}),
  verbose = FALSE,
  usermod = "user") {
  ### -------------------------------------------------------------###
  ###                                                             ###
  ### ------------------- MODULE SERVER --------------------------###
  ###                                                             ###
  ### -------------------------------------------------------------###
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Reactive values that will be used to output the current dataset when
    # the last step is validated
    dataOut <- reactiveValues(
      trigger = NULL,
      value = NULL
    )
    
    rv <- reactiveValues(
      # Contains the return value of the process module that has been called
      proc = NULL,
      
      # steps.status A boolean vector which contains the status
      # (validated, skipped or undone) of the steps
      steps.status = NULL,
      
      # dataIn Contains the dataset passed by argument to the
      # module server
      dataIn = NULL,
      dataIn.original = NULL,
      
      # temp.dataIn This variable is used to serves as a tampon
      # between the input of the module and the functions.
      temp.dataIn = NULL,
      
      # steps.enabled Contains the value of the parameter
      # 'is.enabled'
      steps.enabled = NULL,
      
      # A vector of boolean where each element indicates whether
      # the corresponding process is skipped or not
      # ONLY USED WITH PIPELINE
      steps.skipped = NULL,
      
      # A vector of integers that indicates if each step must be reseted
      # This is an information sent to the child processes. Each time a
      # child process must be reseted, the corresponding element is
      # incremented in order to modify its value. Thus, it can be
      # catched by Shiny observers
      # ---ONLY USED WITH PIPELINE---
      resetChildren = NULL,
      resetChildrenUI = NULL,
      # current.pos Stores the current cursor position in the
      # timeline and indicates which of the process' steps is active
      current.pos = 1,
      length = NULL,
      config = NULL,
      
      # A vector of boolean where each element indicates if the
      # corresponding child if enable or disable
      child.enabled = NULL,
      prev.children.trigger = NULL,
      # xxxx
      child.reset = NULL,
      
      # A vector of integers where each element denotes the current
      # position of the corresponding element.
      child.position = NULL,
      
      # xxxx
      child.data2send = NULL
      #rstBtn = reactive({0})
    )
    
    # Store the return values (lists) of child processes
    tmp.return <- reactiveValues()
    
    
    
    
    output$pipeline_panel_ui <- renderUI({
      shiny::absolutePanel(
        left = default.layout$left_pipeline_sidebar,
        top = default.layout$top_pipeline_sidebar,
        height = default.layout$height_pipeline_sidebar,
        width = default.layout$width_pipeline_sidebar,
        # style de la sidebar contenant les infos des process (timeline, boutons et parametres
        style = paste0(
          "position : absolute; ",
          "background-color: ", MagellanNTK::default.theme(session$userData$usermod)$bgcolor_pipeline_sidebar, "; ",
          "border-right: ", default.layout$line_width, "px solid ", default.layout$line_color, ";",
          "height: 100vh;"
        ),
        div(
          style = " align-items: center; justify-content: center; margin-bottom: 20px;",
          uiOutput(ns("datasetNameUI"))
        ),
        div(id = ns('div_EncapsulateScreens_ui'),
          uiOutput(ns("EncapsulateScreens_ui"))
        )
      )
    })
    
    output$pipeline_tl_btn_ui <- renderUI({
      addResourcePath(
        prefix = "images_Prostar2",
        directoryPath = system.file("images", package = "Prostar2")
      )
      div(
        style = paste0(
          "padding-left: ", default.layout$left_pipeline_timeline, "px; margin-top: -15px;",
          "width: 100%;",
          "background-color: red;"
        ),
        fluidRow(
          style = paste0(
            "background-color: ", MagellanNTK::default.theme(session$userData$usermod)$bgcolor_pipeline_timeline, " ; ",
            "display: flex; ",
            "align-items: center; ",
            "justify-content: center;",
            "border-bottom : ", default.layout$line_width, "px solid ", default.layout$line_color, ";"
          ),
          column(width = 2,
            div(id = ns('div_btns_pipeline_ui'),
              style = paste0(
                "display: inline-block;",
                "vertical-align: middle; "
              ),
              div(id = ns('div_btns_prev_ui'), style="display: inline-block;", uiOutput(ns('prevBtnUI'))),
              # div(style="display: inline-block;",
              #   mod_modalDialog_ui(id = ns("rstBtn"))
              # ),
              div(id = ns('div_btns_next_ui'), style="display: inline-block;", uiOutput(ns('nextBtnUI')))
            )
          ),
          column(width = 9, 
            
            timeline_pipeline_ui(ns("timeline_pipeline"))
            ),
          column(width = 1, 
            
            actionButton(ns("btn_eda"), 
              label = tagList(
                p("EDA", style = "margin: 0px;"),
                tags$img(src = "images_Prostar2/logoEDA_50.png", width = '50px')
                ),
                style = "padding: 0px; margin: 0px; border: none;
          background-size: cover; background-position: center;
          background-color: transparent; font-size: 12px; z-index: 9999999;")
          )
        )
      )
    })
    
    
    
    
    
    output$prevBtnUI <- renderUI({
      req(rv$config)
      rv$current.pos
      
      widget <- actionButton(ns("prevBtn"), tl_h_prev_icon, style = btn_css_style)
      
      if (length(rv$config@steps) == 1)
        .cond <- FALSE
      else 
        .cond <- rv$current.pos != 1
      
      MagellanNTK::toggleWidget(widget, .cond)
    })
    
    output$nextBtnUI <- renderUI({
      req(rv$config)
      rv$current.pos
      
      widget <-actionButton(ns("nextBtn"), tl_h_next_icon,  style = btn_css_style)
      
      if (length(rv$config@steps) == 1)
        .cond <- FALSE
      else 
        .cond <-  rv$current.pos < length(rv$config@steps)
      
      MagellanNTK::toggleWidget(widget, .cond)
    })
    
    
    
    
    
    observeEvent(input$btn_eda, {
      
      req(session$userData$funcs)
      req(dataOut$value)
      
      do.call(
        eval(parse(text = paste0(session$userData$funcs$infos_dataset, "_server"))),
        list(
          id = "eda1",
          dataIn = reactive({dataOut$value})
        )
      )
      
      do.call(
        eval(parse(text = paste0(session$userData$funcs$history_dataset, "_server"))),
        list(
          id = "eda2",
          dataIn = reactive({dataOut$value})
        )
      )
      
      do.call(
        eval(parse(text = paste0(session$userData$funcs$view_dataset, "_server"))),
        list(
          id = "eda3",
          dataIn = reactive({dataOut$value})
        )
      )
      
      showModal(
        shinyjqui::jqui_draggable(
          modalDialog(
            shiny::tabsetPanel(
              id = ns("tabcard"),
              
              shiny::tabPanel(
                title = h3("Infos", style = "margin-right: 30px;"), 
                do.call(
                  eval(parse(text = paste0(session$userData$funcs$infos_dataset, "_ui"))),
                  list(id = ns("eda1"))
                )
              ),
              shiny::tabPanel(
                title = h3("History", style = "margin-right: 30px;"), 
                do.call(
                  eval(parse(text = paste0(session$userData$funcs$history_dataset, "_ui"))),
                  list(id = ns("eda2"))
                )
              ),
              shiny::tabPanel(
                title = h3("EDA"),
                do.call(
                  eval(parse(text = paste0(session$userData$funcs$view_dataset, "_ui"))),
                  list(id = ns("eda3"))
                )
              )
            ),
            #title = "EDA", 
            size = "l"
          ))
      )
    })
    
    
    
    output$datasetNameUI <- renderUI({
      div(
        style = paste0("padding-left: ", 100, "px;"),
        h3(id)
      )
    })
    
    
    # Catch any event on the 'id' parameter. As this parameter is static
    # and is attached to the server, this function can be view as the
    # initialization of the server module. This code is generic to both
    # process and pipeline modules
    observeEvent(id, ignoreInit = FALSE, ignoreNULL = TRUE, {
      
      # Get the new dataset in a temporary variable
      # rv$temp.dataIn <- dataIn()
      # rv$dataIn.original <- dataIn()
      # session$userData$dataIn.original <- dataIn()
      
      ### Call the server module of the process/pipeline which name is
      ### the parameter 'id'.
      ### The name of the server function is prefixed by 'mod_' and
      ### suffixed by '_server'. This will give access to its config
      rv$proc <- do.call(
        paste0(id, "_server"),
        list(
          id = id,
          dataIn = reactive({NULL}),
          steps.enabled = reactive({rv$steps.enabled}),
          #remoteReset = reactive({ rv$rstBtn() + remoteReset()}),
          remoteReset = reactive({remoteReset()}),
          steps.status = reactive({rv$steps.status})
        )
      )
      
      # Update the reactive value config with the config of the pipeline
      rv$config <- rv$proc$config()
      
      n <- length(rv$config@steps)
      
      rv$resetChildren <- setNames(rep(0, n), nm = GetStepsNames())
      rv$resetChildrenUI <- setNames(rep(0, n), nm = GetStepsNames())
      
      
      rv$steps.status <- UpdateStepsStatus(rv$temp.dataIn, rv$config)
      rv$steps.enabled <- setNames(rep(FALSE, n), nm = GetStepsNames())
      rv$steps.skipped <- Discover_Skipped_Steps(rv$steps.status)
      
      #rv$child.data2send <- BuildData2Send(dataIn(), GetStepsNames())
      
      rv$currentStepName <- reactive({
        GetStepsNames()[rv$current.pos]
      })

     
      # Launch the ui for each step of the pipeline
      # This function could be stored in the source file of the
      # pipeline but the strategy is to insert minimum extra
      # code in the files for pipelines and processes. This is
      # useful when other devs will develop other pipelines and
      # processes. Thus, it will be easier.
      
      rv$config@ll.UI <- setNames(lapply(
        GetStepsNames(),
        function(x) {
          nav_process_ui(ns(paste0(id, "_", x)))
        }
      ), nm = paste0(GetStepsNames()))

    }, priority = 1000)
    
    
    
    
    # 
    observe({
      rv$steps.status
      rv$steps.enabled
      rv$current.pos

      # Launch the server timeline for this process/pipeline
      timeline_pipeline_server(
        "timeline_pipeline",
        config = rv$config,
        status = reactive({rv$steps.status}),
        enabled = reactive({rv$steps.enabled}),
        position = reactive({rv$current.pos})
      )
    })
    
    
    #         # Catch a new value on the parameter 'dataIn()' variable, sent by the
    #         # caller. This value may be NULL or contain a dataset.
    #         # The first action is to store the dataset in the temporary variable
    #         # temp.dataIn. Then, two behaviours:
    #         # 1 - if the variable is NULL. xxxx
    #         # 2 - if the variable contains a dataset. xxx
    observeEvent(req(dataIn()), ignoreNULL = FALSE, ignoreInit = FALSE, {
      req(rv$config)
      

      # Get the new dataset in a temporary variable
      rv$temp.dataIn <- dataIn()
      rv$dataIn.original <- dataIn()
      session$userData$dataIn.original <- dataIn()
      
      
      # in case of a new dataset, reset the whole pipeline
      # ResetPipeline()
      
      n <- length(rv$config@steps)
      
      rv$resetChildren <- setNames(rep(0, n), nm = GetStepsNames())
      rv$resetChildrenUI <- setNames(rep(0, n), nm = GetStepsNames())
      
      
      rv$steps.status <- UpdateStepsStatus(rv$temp.dataIn, rv$config)
      rv$steps.enabled <- setNames(rep(FALSE, n), nm = GetStepsNames())
      rv$steps.skipped <- Discover_Skipped_Steps(rv$steps.status)
      
      rv$child.data2send <- BuildData2Send(dataIn(), GetStepsNames())
      
      
             # A new dataset has been loaded
        # # Update the different screens in the process
        rv$steps.enabled <- Update_State_Screens(
          is.skipped = is.skipped(),
          is.enabled = is.enabled(),
          rv = rv
        )
        
        
        # Enable the first screen
        rv$steps.enabled <- ToggleState_Screens(
          cond = TRUE,
          range = 1,
          is.enabled = is.enabled(),
          rv = rv
        )

        rv$current.pos <- SetCurrentPosition(rv$steps.status)
    })
    
    
    
    observe({
      ###
      ### Launch the server for each step of the pipeline
      ###
      lapply(GetStepsNames(), function(x) {
        tmp.return[[x]] <- nav_process_server(
          id = paste0(id, "_", x),
          dataIn = reactive({rv$child.data2send[[x]]}),
          status = reactive({rv$steps.status[x]}),
          is.enabled = reactive({isTRUE(rv$steps.enabled[x])}),
          remoteReset = reactive({rv$resetChildren[x]}),
          remoteResetUI = reactive({rv$resetChildrenUI[x]}),
          is.skipped = reactive({isTRUE(rv$steps.skipped[x])}),
          verbose = verbose,
          usermod = usermod)
      })
    })
    

    
    GetValuesFromChildren <- reactive({
      
      # Get the trigger values for each steps of the module
      return.trigger.values <- setNames(lapply(GetStepsNames(), function(x) {
        tmp.return[[x]]$dataOut()$trigger
      }), nm = GetStepsNames())
      
      # Replace NULL values by NA
      return.trigger.values[sapply(return.trigger.values, is.null)] <- NA
      triggerValues <- unlist(return.trigger.values)
      

      # Get the values returned by each step of the modules
      return.values <- setNames(
        lapply(
          GetStepsNames(),
          function(x) {
            tmp.return[[x]]$dataOut()$value
          }
        ), nm = GetStepsNames())
      
      
      list(
        triggers = triggerValues,
        values = unlist(return.values)
      )
    })
    

    # Catch the returned values of the processes attached to pipeline
    observeEvent(GetValuesFromChildren()$triggers, ignoreInit = TRUE, {
      
      processHasChanged <- newValue <- NULL
      len <- length(rv$steps.status)
      
      
      triggerValues <- GetValuesFromChildren()$triggers
      return.values <- GetValuesFromChildren()$values
      
      if (sum(is.na(triggerValues)) == length(triggerValues) || is.null(return.values)){
        # Initialisation
        # 
        rv$current.pos <- SetCurrentPosition(rv$steps.status)
      } else {   
        
        #browser()
        .cd <- max(triggerValues, na.rm = TRUE) == triggerValues
        processHasChanged <- GetStepsNames()[which(.cd)]
        
        # Get the new value
        newValue <- tmp.return[[processHasChanged]]$dataOut()$value
        
        # Indice of the dataset in the object
        # If the original length is not 1, then this indice is different
        # than the above one
        ind.processHasChanged <- which(names(rv$config@steps) == processHasChanged)
        if (is.null(newValue)){
          
        } else if (is.numeric(newValue) && newValue == -10){
          # A process has been reseted
          lastValidated <- GetMaxValidated_BeforePos(pos = ind.processHasChanged, rv = rv)
          
          # If no process has been validated yet
          if (is.null(lastValidated))
            lastValidated <- 0
          
          # # A process has been reseted (it has returned a NULL value)
          # One take the last validated step (before the one
          # corresponding to processHasChanges
          # but it is straightforward because we just updates rv$status
          
          rv$steps.status[(lastValidated + 1):len] <- stepStatus$UNDONE
          
          # All the following processes (after the one which has changed) are disabled
          #rv$steps.enabled[(lastValidated + 1):len] <- FALSE
          #rv$steps.status <- UpdateStepsStatus(dataIn(), rv$config)
          
          
          # The process that has been rested is enabled so as to rerun it
          rv$steps.enabled[ind.processHasChanged] <- TRUE
          
          rv$steps.skipped[(lastValidated + 1):len] <- FALSE
          Update_State_Screens(rv$steps.skipped, rv$steps.enabled, rv)
          
          rv$current.pos <- SetCurrentPosition(rv$steps.status)
          # Update the datasend Vector
           lapply((lastValidated + 1):len, function(x){
             rv$child.data2send[[x]] <- rv$child.data2send[[lastValidated + 1]]
           })
          
          
        } else {# A process has been validated
          rv$steps.status[ind.processHasChanged] <- stepStatus$VALIDATED

          if (ind.processHasChanged < len) {
            rv$steps.status[(1 + ind.processHasChanged):len] <- stepStatus$UNDONE
          }
          
          
          rv$steps.status <- Discover_Skipped_Steps(rv$steps.status)
          rv$dataIn <- newValue
          rv$current.pos <- SetCurrentPosition(rv$steps.status)
          # Update the datasend Vector
           lapply((ind.processHasChanged + 1):len, function(x){
           rv$child.data2send[[x]] <- rv$dataIn
           })

        }
        
      }
      
      print(rv$child.data2send)
      
      # Send result
      dataOut$trigger <- Timestamp()
      dataOut$value <- rv$child.data2send[[length(rv$child.data2send)]]
    })
    
    # Update the current position after a click  on the 'Previous' button
    observeEvent(input$prevBtn, ignoreInit = TRUE, {
      rv$current.pos <- NavPage(
        direction = -1,
        current.pos = rv$current.pos,
        len = length(rv$config@steps)
      )
    })
    
    # Update the current position after a click on the 'Next' button
    observeEvent(input$nextBtn, ignoreInit = TRUE, {
      rv$current.pos <- NavPage(
        direction = 1,
        current.pos = rv$current.pos,
        len = length(rv$config@steps)
      )
    })
    
    
    # Catch new status event
    # See https://github.com/daattali/shinyjs/issues/166
    # https://github.com/daattali/shinyjs/issues/25
    observeEvent(rv$steps.status, ignoreInit = TRUE, {
      rv$steps.status <- Discover_Skipped_Steps(rv$steps.status)
      rv$steps.enabled <- Update_State_Screens(
        is.skipped = is.skipped(),
        is.enabled = is.enabled(),
        rv = rv
      )
      
      n <- length(rv$config@steps)

      
      ind.undone <- unname(which(rv$steps.status == stepStatus$UNDONE))
      rv$resetChildrenUI[ind.undone] <- rv$resetChildrenUI[ind.undone] + 1
    })
    

    GetStepsNames <- reactive({
      req(rv$config@steps)
      names(rv$config@steps) 
    })
    
    # This function uses the UI definition to:
    # 1 - initialize the UI (only the first screen is shown),
    # 2 - encapsulate the UI in a div (used to hide all screens at a time
    #     before showing the one corresponding to the current position)
    output$EncapsulateScreens_ui <- renderUI({
      rv$current.pos
      len <- length(rv$config@ll.UI)
      

      lapply(seq_len(len), function(i) {
        if (i == rv$current.pos) {
          div(
            id = ns(GetStepsNames()[i]),
            class = paste0("page_", id),
            rv$config@ll.UI[[i]]
          )
        } else {
          shinyjs::hidden(
            div(
              id = ns(GetStepsNames()[i]),
              class = paste0("page_", id),
              rv$config@ll.UI[[i]]
            )
          )
        }
      })
    })
    
    
    # Define message when the Reset button is clicked
    template_reset_modal_txt <- "This action will reset the current process.
        The input dataset will be the output of the last previous validated
        process and all further datasets will be removed"
    
    txt <- span(gsub("mode", "mode_Test", template_reset_modal_txt))
    
    # rv$rstBtn <- mod_modalDialog_server(
    #   id = "rstBtn",
    #   title = "Reset",
    #   uiContent = p(txt)
    # )
    
    observeEvent(input$closeModal, {
      removeModal()
    })

   
    
    
    observeEvent(rv$current.pos, ignoreInit = TRUE, {
      ToggleState_NavBtns(
        current.pos = rv$current.pos,
        nSteps = length(rv$config@steps)
      )
      shinyjs::hide(selector = paste0(".page_", id))
      shinyjs::show(GetStepsNames()[rv$current.pos])
    })
    
    
    # The return value of the nav_process module server
    # The item 'dataOut' has been updated by the module process and it is
    # returned to the function that has called this nav_process module (it
    # can be a module, a Shiny app or another nav module for example,
    # nav_pipeline)
    list(
      dataOut = reactive({dataOut}),
      steps.enabled = reactive({rv$steps.enabled}),
      status = reactive({rv$steps.status})
    )
  })
}





#' @export
#' @rdname nav_pipeline
#' @importFrom shiny fluidPage shinyApp
#'
nav_pipeline <- function() {
  server_env <- environment() # will see all dtwclust functions
  server_env$dev_mode <- FALSE
  
  pipe.name <- "PipelineDemo"
  layout <- c("h", "h")
  
  path <- system.file(file.path("workflow", pipe.name), package = "MagellanNTK")
  files <- list.files(file.path(path, "R"), full.names = TRUE)
  for (f in files) {
    source(f, local = FALSE, chdir = TRUE)
  }
  
  app.path <- system.file("app", package = "MagellanNTK")
  source(file.path(app.path, "global.R"), local = FALSE, chdir = TRUE)
  
  ui <- fluidPage(
    tagList(
      fluidRow(
        column(width = 2, actionButton("simReset", "Remote reset", class = "info")),
        column(width = 2, actionButton("simEnabled", "Remote enable/disable", class = "info")),
        column(width = 2, actionButton("simSkipped", "Remote is.skipped", class = "info"))
      ),
      hr(),
      nav_pipeline_ui(pipe.name),
      uiOutput("debugInfos_ui")
    )
  )
  
  server <- function(input, output, session) {
    session$userData$workflow.path <- path
    rv <- reactiveValues(
      dataIn = NULL,
      dataOut = NULL
    )
    
    #  output$UI <- renderUI({nav_pipeline_ui(pipe.name)})
    
    output$debugInfos_ui <- renderUI({
      req(server_env$dev_mode)
      Debug_Infos_server(
        id = "debug_infos",
        title = "Infos from shiny app",
        rv.dataIn = reactive({rv$dataIn}),
        dataOut = reactive({rv$dataOut$dataOut()})
      )
      Debug_Infos_ui("debug_infos")
    })
    
    
    
    observe({
      rv$dataOut <- nav_pipeline_server(
        id = pipe.name,
        dataIn = reactive({rv$dataIn}),
        remoteReset = reactive({input$simReset}),
        is.skipped = reactive({input$simSkipped %% 2 != 0}),
        is.enabled = reactive({input$simEnabled %% 2 == 0})
      )
    })
  }
  
  
  shiny::shinyApp(ui, server)
}