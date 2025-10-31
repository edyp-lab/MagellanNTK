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
    shiny::absolutePanel(
      left = default.layout$left_pipeline_sidebar,
      top = default.layout$top_pipeline_sidebar,
      height = default.layout$height_pipeline_sidebar,
      width = default.layout$width_pipeline_sidebar,
      style = paste0(
        "position : absolute; ",
        "background-color: ", default.layout$bgcolor_pipeline_sidebar, "; ",
        "height: 100vh;"
      ),
      div(
        style = " align-items: center; justify-content: center; margin-bottom: 20px;",
        uiOutput(ns("datasetNameUI"))
      ),
      div(
        uiOutput(ns("EncapsulateScreens_ui"))
      )
    ),
    div(
      style = "padding-left: 240px; margin-top: -15px;",
      fluidRow(
        style = paste0(
          "background-color: ", default.layout$bgcolor_pipeline_timeline, " ; ",
          "display: flex; ",
          "align-items: center; ",
          "justify-content: center;"
        ),
        column(
          width = 1,
          shinyjs::disabled(
            actionButton(ns("prevBtn"),
              tl_h_prev_icon,
              class = PrevNextBtnClass,
              style = btn_css_style
            )
          )
        ),
        column(width = 1, mod_modalDialog_ui(id = ns("rstBtn"))),
        column(
          width = 1,
          actionButton(ns("nextBtn"),
            tl_h_next_icon,
            class = PrevNextBtnClass,
            style = btn_css_style
          )
        ),
        column(width = 9, timeline_pipeline_ui(ns("timeline_pipeline")))
      )
    )
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
      child.data2send = NULL,
      rstBtn = reactive({0})
    )
    
    # Store the return values (lists) of child processes
    tmp.return <- reactiveValues()
    
    
    
    output$datasetNameUI <- renderUI({
      #req(inherits(dataIn(), 'QFeatures'))
      # h3(DaparToolshed::filename(dataIn()))
      h3('FILENAME TO DO')
    })
    
    
    # Catch any event on the 'id' parameter. As this parameter is static
    # and is attached to the server, this function can be view as the
    # initialization of the server module. This code is generic to both
    # process and pipeline modules
    observeEvent(c(id, dataIn()), ignoreInit = FALSE, ignoreNULL = TRUE, {
      
      # Get the new dataset in a temporary variable
      rv$temp.dataIn <- dataIn()
      rv$dataIn.original <- dataIn()
      session$userData$dataIn.original <- dataIn()
      
      ### Call the server module of the process/pipeline which name is
      ### the parameter 'id'.
      ### The name of the server function is prefixed by 'mod_' and
      ### suffixed by '_server'. This will give access to its config
      rv$proc <- do.call(
        paste0(id, "_server"),
        list(
          id = id,
          dataIn = reactive({rv$temp.dataIn}),
          steps.enabled = reactive({rv$steps.enabled}),
          remoteReset = reactive({ rv$rstBtn() + remoteReset()}),
          steps.status = reactive({rv$steps.status})
        )
      )
      
      # Update the reactive value config with the config of the pipeline
      rv$config <- rv$proc$config()
      
      n <- length(rv$config@steps)
      rv$steps.status <- setNames(rep(stepStatus$UNDONE, n), nm = GetStepsNames())
      #rv$prev.children.trigger <- setNames(rep(NA, n), nm = GetStepsNames())
      
      rv$steps.enabled <- setNames(rep(FALSE, n), nm = GetStepsNames())
      
      rv$steps.skipped <- setNames(rep(FALSE, n), nm = GetStepsNames())
      rv$resetChildren <- setNames(rep(0, n), nm = GetStepsNames())
      rv$resetChildrenUI <- setNames(rep(0, n), nm = GetStepsNames())
      
      rv$child.data2send <- setNames(
        lapply(as.list(GetStepsNames()), function(x) NULL),
        nm = GetStepsNames()
      )
      
      rv$currentStepName <- reactive({
        GetStepsNames()[rv$current.pos]
      })
      
      # Launch the server timeline for this process/pipeline
      timeline_pipeline_server(
        "timeline_pipeline",
        config = rv$config,
        status = reactive({rv$steps.status}),
        enabled = reactive({rv$steps.enabled}),
        position = reactive({rv$current.pos})
      )
      
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
      
      # ###
      # ### Launch the server for each step of the pipeline
      # ###
      # lapply(GetStepsNames(), function(x) {
      #   tmp.return[[x]] <- nav_process_server(
      #     id = paste0(id, "_", x),
      #     dataIn = reactive({rv$child.data2send[[x]]}),
      #     status = reactive({rv$steps.status[x]}),
      #     is.enabled = reactive({isTRUE(rv$steps.enabled[x])}),
      #     remoteReset = reactive({rv$resetChildren[x]}),
      #     remoteResetUI = reactive({rv$resetChildrenUI[x]}),
      #     is.skipped = reactive({isTRUE(rv$steps.skipped[x])}),
      #     verbose = verbose,
      #     usermod = usermod
      #   )
      # })
    }, priority = 1000)
    
    
    
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
          usermod = usermod
        )
      })
    })
    
    
    GetChildrenValues <- reactive({
      lapply(
        GetStepsNames(),
        function(x) {
          tmp.return[[x]]$dataOut()$trigger
        }
      )
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
    observeEvent(GetValuesFromChildren()$triggers, ignoreInit = FALSE, {
      #browser()
      
      processHasChanged <- newValue <- NULL
      
      triggerValues <- GetValuesFromChildren()$triggers
      return.values <- GetValuesFromChildren()$values
      
      if (is.null(return.values)) {
        # The entire pipeline has been reseted
        rv$dataIn <- dataIn()
        rv$steps.status[seq_len(length(rv$config@steps))] <- stepStatus$UNDONE
        
        
        rv$child.data2send <- setNames(lapply(GetStepsNames(), function(x) {
          rv$dataIn
        }), nm = GetStepsNames())
        
      } else {
        .cd <- max(triggerValues, na.rm = TRUE) == triggerValues
        processHasChanged <- GetStepsNames()[which(.cd)]
        
        # Get the new value
        newValue <- tmp.return[[processHasChanged]]$dataOut()$value
        
        # Indice of the dataset in the object
        # If the original length is not 1, then this indice is different
        # than the above one
        ind.processHasChanged <- which(names(rv$config@steps) == processHasChanged)
        
        
        len <- length(rv$config@steps)
        
        if (is.null(newValue)) { # A process has been reseted
          
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
          
          
          # The process that has been rested is enabled so as to rerun it
          rv$steps.enabled[ind.processHasChanged] <- TRUE
          
          rv$steps.skipped[(lastValidated + 1):len] <- FALSE
          Update_State_Screens(rv$steps.skipped, rv$steps.enabled, rv)
          
          # Update the datasend Vector
          lapply((lastValidated + 1):len, function(x){
            rv$child.data2send[[x]] <- rv$child.data2send[[lastValidated + 1]]
          })
        } else {
          # A process has been validated
          rv$steps.status[ind.processHasChanged] <- stepStatus$VALIDATED
          #browser()
          if (ind.processHasChanged < len) {
            rv$steps.status[(1 + ind.processHasChanged):len] <- stepStatus$UNDONE
          }
          
          
          rv$steps.status <- Discover_Skipped_Steps(rv$steps.status)
          rv$dataIn <- newValue
          
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
    
    
    # The parameter 'is.enabled()' is updated by the caller and tells the
    # process if it is enabled or disabled (remote action from the caller)
    # This enables/disables an entire process/pipeline
    observeEvent(is.enabled(), ignoreNULL = TRUE, ignoreInit = TRUE, {
      if (isTRUE(is.enabled())) {
        rv$steps.enabled <- Update_State_Screens(
          is.skipped = is.skipped(),
          is.enabled = is.enabled(),
          rv = rv
        )
      } else {
        rv$steps.enabled <- setNames(rep(is.enabled(), length(rv$config@steps)),
          nm = names(rv$config@steps)
        )
      }
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
      
      
      #browser()
      ind.undone <- unname(which(rv$steps.status == stepStatus$UNDONE))
      rv$resetChildrenUI[ind.undone] <- rv$resetChildrenUI[ind.undone] + 1
    })
    
    
    # The parameter is.skipped() is set by the caller and tells the process
    # if it is skipped or not (remote action from the caller)
    observeEvent(is.skipped(), ignoreNULL = FALSE, ignoreInit = TRUE, {
      if (isTRUE(is.skipped())) {
        rv$steps.status <- All_Skipped_tag(rv$steps.status, stepStatus$SKIPPED)
      } else {
        rv$steps.status <- All_Skipped_tag(rv$steps.status, stepStatus$UNDONE)
        rv$steps.enabled <- Update_State_Screens(
          is.skipped = is.skipped(),
          is.enabled = is.enabled(),
          rv = rv
        )
      }
    })
    
    
    
    ResetPipeline <- function() {
      # rv$dataIn <- session$userData$dataIn.original
      rv$dataIn <- NULL
      rv$current.pos <- 1
      
      n <- length(rv$config@steps)
      # The status of the steps are reinitialized to the default
      # configuration of the process
      rv$steps.status <- setNames(rep(stepStatus$UNDONE, n), nm = names(rv$config@steps))
      
      # The reset of the children is made by incrementing
      # the values by 1. This has for effect to be detected
      # by the observeEvent function. It works like an actionButton
      # widget
      
      rv$resetChildren[seq_len(n)] <- rv$resetChildren[seq_len(n)] + 1
      
      # Return the NULL value as dataset
      dataOut$trigger <- Timestamp()
      dataOut$value <- rv$dataIn
    }
    
    
    observeEvent(remoteReset(), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(rv$config)
      ResetPipeline()
    })
    
    
    observeEvent(rv$rstBtn(), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(rv$config)
      ResetPipeline()
    })
    
    # Show the info panel of a skipped module
    output$SkippedInfoPanel <- renderUI({
      Build_SkippedInfoPanel(
        steps.status = rv$steps.status,
        current.pos = rv$current.pos,
        config = rv$config
      )
    })
    
    # Show the debug infos if requested (dev_mode mode)
    # This function is not directly implemented in the main UI of nav_ui
    # because it is hide/show w.r.t. the value of dev_mode
    output$debug_infos_ui <- renderUI({
      req(verbose)
      
      Debug_Infos_server(
        id = "debug_infos",
        title = paste0("Infos from ", rv$config@mode, ": ", id),
        config = reactive({rv$config}),
        rv.dataIn = reactive({rv$dataIn}),
        dataIn = reactive({dataIn()}),
        dataOut = reactive({dataOut}),
        steps.status = reactive({rv$steps.status}),
        steps.skipped = reactive({rv$steps.skipped}),
        current.pos = reactive({rv$current.pos}),
        steps.enabled = reactive({rv$steps.enabled}),
        is.enabled = reactive({is.enabled()})
      )
      
      Debug_Infos_ui(ns("debug_infos"))
    })
    
    
    GetStepsNames <- reactive({
      names(rv$config@steps)
    })
    
    # This function uses the UI definition to:
    # 1 - initialize the UI (only the first screen is shown),
    # 2 - encapsulate the UI in a div (used to hide all screens at a time
    #     before showing the one corresponding to the current position)
    output$EncapsulateScreens_ui <- renderUI({
      len <- length(rv$config@ll.UI)
      
      lapply(seq_len(len), function(i) {
        if (i == 1) {
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
    
    rv$rstBtn <- mod_modalDialog_server(
      id = "rstBtn",
      title = "Reset",
      uiContent = p(txt)
    )
    
    observeEvent(input$closeModal, {
      removeModal()
    })
    # 
    # 
    #         # Catch a new value on the parameter 'dataIn()' variable, sent by the
    #         # caller. This value may be NULL or contain a dataset.
    #         # The first action is to store the dataset in the temporary variable
    #         # temp.dataIn. Then, two behaviours:
    #         # 1 - if the variable is NULL. xxxx
    #         # 2 - if the variable contains a dataset. xxx
    #         observeEvent(dataIn(), ignoreNULL = FALSE, ignoreInit = FALSE, {
    #             req(rv$config)
    #             
    #           # in case of a new dataset, reset the whole pipeline
    #           # ResetPipeline()
    #           
    #             # Get the new dataset in a temporary variable
    #             rv$temp.dataIn <- dataIn()
    #             session$userData$dataIn.original <- dataIn()
    # 
    #             # The mode pipeline is a node and has to send
    #             # datasets to its children
    #             if (is.null(rv$dataIn)) {
    #                 
    #                 rv$child.data2send <- setNames(lapply(GetStepsNames(), function(x) {
    #                   rv$dataIn
    #                 }), nm = GetStepsNames())
    # 
    #                # rv$steps.enabled <- res$steps.enabled
    #             }
    # 
    #             if (is.null(dataIn())) {
    #                 # The process has been reseted or is not concerned
    #                 # Disable all screens of the process
    #                 rv$steps.enabled <- ToggleState_Screens(
    #                     cond = FALSE,
    #                     range = seq_len(length(rv$config@steps)),
    #                     is.enabled = is.enabled,
    #                     rv = rv
    #                 )
    #             } else {
    #                 # A new dataset has been loaded
    #                 # # Update the different screens in the process
    #                 rv$steps.enabled <- Update_State_Screens(
    #                     is.skipped = is.skipped(),
    #                     is.enabled = is.enabled(),
    #                     rv = rv
    #                 )
    # 
    # 
    #                 # Enable the first screen
    #                 rv$steps.enabled <- ToggleState_Screens(
    #                     cond = TRUE,
    #                     range = 1,
    #                     is.enabled = is.enabled(),
    #                     rv = rv
    #                 )
    #             }
    #         })
    
    
    observeEvent(rv$current.pos, ignoreInit = TRUE, {
      ToggleState_NavBtns(
        current.pos = rv$current.pos,
        nSteps = length(rv$config@steps)
      )
      shinyjs::hide(selector = paste0(".page_", id))
      shinyjs::show(GetStepsNames()[rv$current.pos])
      
      if (rv$steps.status[rv$current.pos] == stepStatus$VALIDATED) {
        rv$child.position[rv$current.pos] <- paste0("last_", Timestamp())
      }
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