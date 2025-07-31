#' @title The server() function of the module `nav_process`
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
#'
#' @param tl.layout A vector of character ('h' for horizontal, 'v' for vertical)
#' where each item correspond to the orientation of the timeline for a given
#' level of navigation module.
#' 
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
#' \dontrun{
#' nav_process()
#' }
#' 
#' @name nav_process
#' 
#' @author Samuel Wieczorek
#'
NULL


#' @param id A `character(1)` which defines the id of the module. 
#' It is the same as for the server() function.
#'
#' @rdname nav_process
#'
#' @export
#'
nav_process_ui <- function(id) {
  ns <- NS(id)
  # "#", ns('mycontent'), "{ padding-left: 220px; height: 100%; background-color: orange; }
  #     #", ns('mysidebar'),  "{ width: 200px; height: 100%; float: left; background-color: lightblue; }
      
 # tagList(
  #  padding = 0,
    # tags$style(type = "text/css",
    #   paste0(
    #   "#", ns('btns_process_panel'), "{ position: relative; background-color: green; }")
    # ),
   div (
     id = ns("btns_process_panel"),
     #style = "background-color: green;",
     
     absolutePanel(
       top = 74,
       left = 75,
       width = 250,
       #height = '100vh',
       draggable = FALSE,
       style = "position : absolute ; background-color: lightblue;",
       
       div(style = "display: flex; align-items: center; justify-content: center;",
          actionButton(ns("prevBtn"),
              tl_h_prev_icon,
              class = PrevNextBtnClass,
              style = btn_css_style
            ),
          mod_modalDialog_ui(id = ns("rstBtn")),
          actionButton(ns("nextBtn"),
            tl_h_next_icon,
            class = PrevNextBtnClass,
            style = btn_css_style
          )),
       div(style = "display: flex; align-items: center; justify-content: center;",
         actionButton(ns("DoBtn"),
            'Do X',
            class = PrevNextBtnClass,
            style = btn_css_style
          ),
          actionButton(ns("DoProceedBtn"),
            'Do X & proceed',
            class = PrevNextBtnClass,
            style = btn_css_style
          )
         ),
       uiOutput(ns('testTL'))
       )
     #uiOutput(ns("EncapsulateScreens_ui")),
     
   # div(
   #   style="padding-top: 70px; background-color: transparent;",
   #   
   #   uiOutput(ns('testTL'))
   # )
     

    # Contains the UI for the debug module
    #uiOutput(ns("debug_infos_ui"))
  )
}



#'
#' @export
#'
#' @rdname nav_process
#' @importFrom stats setNames
#' @importFrom crayon blue yellow
#' 
nav_process_server <- function(id = NULL,
  dataIn = reactive({NULL}),
  is.enabled = reactive({TRUE}),
  remoteReset = reactive({0}),
  is.skipped = reactive({FALSE}),
  verbose = FALSE,
  usermod = 'user',
  btnEvents = reactive({NULL})
  ){
  
  
  
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
      
      
      # current.pos Stores the current cursor position in the 
      # timeline and indicates which of the process' steps is active
      current.pos = 1,
      length = NULL,
      config = NULL,
      rstBtn = reactive({0}),
      btnEvents = reactive({NULL}),
      doProceedAction = NULL
    )
    
    output$dataset_name <- renderUI({
      #p(DaparToolshed::file(dataIn()))
      p('filename')
      
    })
    
    
    # Catch any event on the 'id' parameter. As this parameter is static 
    # and is attached to the server, this function can be view as the 
    # initialization of the server module. This code is generic to both 
    # process and pipeline modules
    observeEvent(id, ignoreInit = FALSE, ignoreNULL = TRUE,
      {
        # When the server starts, the default position is 1
        # Not necessary ?
        # rv$current.pos <- 2
        
        ### Call the server module of the process/pipeline which name is 
        ### the parameter 'id'. 
        ### The name of the server function is prefixed by 'mod_' and 
        ### suffixed by '_server'. This will give access to its config
        if(verbose)
          cat(crayon::blue(paste0(id, ': call ', paste0(id, "_server()"), '\n')))
        
        rv$proc <- do.call(
          paste0(id, "_server"),
          list(
            id = id,
            dataIn = reactive({rv$temp.dataIn}),
            steps.enabled = reactive({rv$steps.enabled}),
            remoteReset = reactive({rv$rstBtn() + remoteReset()}),
            steps.status = reactive({rv$steps.status}),
            current.pos = reactive({rv$current.pos}),
            btnEvents = reactive({rv$btnEvents})
          )
        )
        
        # Update the reactive value config with the config of the 
        # pipeline
        rv$config <- rv$proc$config()
        
        #rv$config <- RemoveDescriptionStep(rv$config)
        
        # Remove the step 'Description'
        
        
        
        if(verbose){
          cat(crayon::blue(paste0(id, ': call ', paste0(id, "_conf()"), '\n')))
          rv$config
        }
        
        n <- length(rv$config@steps)
        stepsnames <- names(rv$config@steps)
        rv$steps.status <- setNames(rep(stepStatus$UNDONE, n), nm = stepsnames)
        rv$steps.enabled <- setNames(rep(FALSE, n), nm = stepsnames)
        rv$steps.skipped <- setNames(rep(FALSE, n), nm = stepsnames)
        rv$currentStepName <- reactive({stepsnames[rv$current.pos]})

        if(verbose)
          cat(crayon::yellow(paste0(id, ': Entering observeEvent(req(rv$config), {...})\n')))
      },
      priority = 1000
    )
    
    
    
    observeEvent(rv$proc$dataOut()$trigger,
      ignoreNULL = TRUE, ignoreInit = TRUE, {
        req(rv$doProceedAction)
        # If a value is returned, this is because the 
        # # current step has been validated
        
        rv$steps.status[rv$current.pos] <- stepStatus$VALIDATED
        
        # Look for new skipped steps
        rv$steps.status <- Discover_Skipped_Steps(rv$steps.status)
        
        # If it is the first step (description step), then
        # load the dataset in work variable 'dataIn'
        if (rv$current.pos == 1) {
          rv$dataIn <- rv$temp.dataIn
          
          if (rv$doProceedAction == 'Do_Proceed')
          rv$current.pos <- rv$current.pos + 1
          
        } # View intermediate datasets
        else if (rv$current.pos > 1 && rv$current.pos < length(rv$config@steps)) {
          rv$dataIn <- rv$proc$dataOut()$value
          
          if (rv$doProceedAction == 'Do_Proceed')
            rv$current.pos <- rv$current.pos + 1
        } 
        # Manage the last dataset which is the real one 
        # returned by the process
        else if (rv$current.pos == length(rv$config@steps)) {
          # Update the work variable of the nav_process 
          # with the dataset returned by the process
          # Thus, the variable rv$temp.dataIn keeps 
          # trace of the original dataset sent to
          # this  workflow and will be used in case of 
          # reset
          rv$dataIn <- rv$proc$dataOut()$value
          
          # Update the 'dataOut' reactive value to return
          #  this dataset to the caller. this `nav_process` 
          #  is only a bridge between the process and  the
          #  caller
          # For a pipeline, the output is updated each 
          # time a process has been validated
          dataOut$trigger <- Timestamp()
          dataOut$value <- rv$dataIn
        }
      }
    )
    
    
    
    observeEvent(req(!is.null(rv$position)), ignoreInit = TRUE, {
      pos <- strsplit(rv$position, "_")[[1]][1]
      
      if (pos == "last") {
        rv$current.pos <- length(rv$config@steps)
      } else if (is.numeric(pos)) {
        rv$current.pos <- rv$position
      }
    })
    
    
    
    # Specific to pipeline module
    # Used to store the return values (lists) of child processes
    tmp.return <- reactiveValues()
    
    
    observeEvent(input$closeModal, {removeModal()})
    
    # Update the current position after a click  on the 'Previous' button
    observeEvent(input$prevBtn, ignoreInit = TRUE, {
      rv$current.pos <- NavPage(direction = -1,
        current.pos = rv$current.pos,
        len = length(rv$config@steps)
      )
    })
    
    # Update the current position after a click on the 'Next' button
    observeEvent(input$nextBtn, ignoreInit = TRUE, {
      
      rv$current.pos <- NavPage(direction = 1,
        current.pos = rv$current.pos,
        len = length(rv$config@steps)
      )
    })
    
    
    
    observeEvent(input$DoProceedBtn, ignoreInit = TRUE, {
      # Catch the event to send it to the process server
      rv$btnEvents <- names(rv$steps.status)[rv$current.pos]
      rv$doProceedAction <- 'Do_Proceed'
    })
    
    observeEvent(input$DoBtn, ignoreInit = TRUE, {
      # Catch the event to send it to the process server
      rv$btnEvents <- names(rv$steps.status)[rv$current.pos]
      rv$doProceedAction <- 'Do'
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
      if (rv$steps.status[n] == stepStatus$VALIDATED) {
        # Set current position to the last one
        rv$current.pos <- n
        
        # If the last step is validated, it is time to send result by
        # updating the 'dataOut' reactiveValue.
        dataOut$trigger <- Timestamp()
        dataOut$value <- rv$dataIn
      }
    })
    
    
    # @description
    # The parameter is.skipped() is set by the caller and tells the process
    # if it is skipped or not (remote action from the caller)
    observeEvent(is.skipped(), ignoreNULL = FALSE,  ignoreInit = TRUE, {
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
    
    
    
    ResetProcess <- function(){
      rv$dataIn <- NULL
      # The cursor is set to the first step
      rv$current.pos <- 1
      
      n <- length(rv$config@steps)
      # The status of the steps are reinitialized to the default
      # configuration of the process
      rv$steps.status <- setNames(rep(stepStatus$UNDONE, n), nm = names(rv$config@steps))
      
      # Return the NULL value as dataset
      dataOut$trigger <- Timestamp()
      dataOut$value <- NULL
    }
    
    observeEvent(c(remoteReset(), rv$rstBtn()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(rv$config)
      ResetProcess()
    }
    )
    
    
    
    
    # # Catch a click of a the button 'Ok' of a reset modal. This can be in
    # # the local module or in the module parent UI (in this case,
    # # it is called a 'remoteReset')
    # observeEvent(req(rv$rstBtn()), ignoreInit = FALSE, ignoreNULL = TRUE,{
    #   print("In core.R : observeEvent(req(rv$rstBtn())")
    #   ResetProcess()
    # }
    # )
    
    
    # Show the info panel of a skipped module
    # output$SkippedInfoPanel <- renderUI({
    #   Build_SkippedInfoPanel(steps.status = rv$steps.status,
    #     current.pos = rv$current.pos,
    #     config = rv$config
    #   )
    # })
    
    # Show the debug infos if requested (dev_mode mode)
    # This function is not directly implemented in the main UI of nav_ui
    # because it is hide/show w.r.t. the value of dev_mode
    # output$debug_infos_ui <- renderUI({
    #   req(verbose)
    #   
    #   Debug_Infos_server(
    #     id = "debug_infos",
    #     title = paste0("Infos from ",rv$config@mode, ": ", id),
    #     config = reactive({rv$config}),
    #     rv.dataIn = reactive({rv$dataIn}),
    #     dataIn = reactive({dataIn()}),
    #     dataOut = reactive({dataOut}),
    #     steps.status = reactive({rv$steps.status}),
    #     steps.skipped = reactive({rv$steps.skipped}),
    #     current.pos = reactive({rv$current.pos}),
    #     steps.enabled = reactive({rv$steps.enabled}),
    #     is.enabled = reactive({is.enabled()})
    #   )
    #   
    #   Debug_Infos_ui(ns("debug_infos"))
    # })
    
    
    GetStepsNames <- reactive({names(rv$config@steps)})

    
 
    
    output$testTL <- renderUI({
      
      timeline_process_server(
        id = 'process_timeline',
        config = rv$config,
        status = reactive({rv$steps.status}),
        position = reactive({rv$current.pos}),
        enabled = reactive({rv$steps.enabled})
      )
      
      timeline_process_ui(ns('process_timeline'))
    })
    
    
    # This function uses the UI definition to:
    # 1 - initialize the UI (only the first screen is shown),
    # 2 - encapsulate the UI in a div (used to hide all screens at a time 
    #     before showing the one corresponding to the current position)
    output$EncapsulateScreens_ui <- renderUI({
      len <- length(rv$config@ll.UI)
      
      tagList(
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
      )
    })
    
    
    # observeEvent(rv$proc$dataOut()$sidebarState,
    #   ignoreNULL = TRUE, ignoreInit = TRUE, {
    #     shinyjs::toggle('btns_process_panel', 
    #       anim = TRUE,
    #       animType = "fade",
    #       time = 0.1,
    #       condition = rv$proc$dataOut()$sidebarState
    #       )
    #   })
    
    # Launch the UI for the user interface of the module
    # Note for devs: apparently, the renderUI() cannot be stored in the 
    # function 'Build..'
    output$nav_process_mod_ui <- renderUI({
      if(verbose)
        cat(crayon::blue(paste0(id, ': Entering output$nav_mod_ui <- renderUI({...})\n')))

      div(
        style = "position: relative;  ",
        
        #tags$style(".bslib-sidebar-layout .collapse-toggle{display:true;}"),
        
        div(
          id = ns("Screens"),
          style = "z-index: 0;",
          uiOutput(ns("SkippedInfoPanel"))
          ,uiOutput(ns("EncapsulateScreens_ui"))
        )
          ,absolutePanel(
            id = ns("btns_process_panel"),
            top = default.layout$top_process_btns,
            left = default.layout$left_process_btns,
            width = default.layout$width_process_btns,
            height = default.layout$height_process_btns,
            draggable = TRUE,
            style = "
              padding: 0px 0px 0px 0px;
              margin: 0px 0px 0px 0px;
              padding-bottom: 2mm;
              padding-top: 1mm;",

          fluidRow(
            column(width = 3, shinyjs::disabled(
              actionButton(ns("prevBtn"),
                tl_h_prev_icon,
                class = PrevNextBtnClass,
                style = btn_css_style
              )
            )),
            column(width = 3, mod_modalDialog_ui(id = ns("rstBtn"))),
            column(width = 3, actionButton(ns("nextBtn"),
              tl_h_next_icon,
              class = PrevNextBtnClass,
              style = btn_css_style
            ))
          
          ),
            fluidRow(
              column(width = 4, actionButton(ns("DoBtn"),
                'Do X',
                class = PrevNextBtnClass,
                style = btn_css_style
              )),
              column(width = 8, actionButton(ns("DoProceedBtn"),
                'Do X & proceed',
                class = PrevNextBtnClass,
                style = btn_css_style
              ))
              
            ))
        )
    })
    
    
    #Define message when the Reset button is clicked
    template_reset_modal_txt <- "This action will reset the current process.
        The input dataset will be the output of the last previous validated 
        process and all further datasets will be removed"
    
    txt <- span(gsub("mode", 'mode_Test', template_reset_modal_txt))
    
    rv$rstBtn  <- mod_modalDialog_server(
      id = "rstBtn",
      title = 'Reset',
      uiContent = p(txt))
    

    
    
    # Catch a new value on the parameter 'dataIn()' variable, sent by the
    # caller. This value may be NULL or contain a dataset.
    # The first action is to store the dataset in the temporary variable
    # temp.dataIn. Then, two behaviours:
    # 1 - if the variable is NULL. xxxx
    # 2 - if the variable contains a dataset. xxx
    observeEvent(dataIn(),  ignoreNULL = FALSE, ignoreInit = FALSE, {
      req(rv$config)
      
      
      #isolate({
      # A new value on dataIn() means a new dataset sent to the 
      # process
      
      #rv$current.pos <- 1
      
      # Get the new dataset in a temporary variable
      rv$temp.dataIn <- dataIn()
      
      
      
      if (is.null(dataIn())) {
        # The process has been reseted or is not concerned
        # Disable all screens of the process
        rv$steps.enabled <- ToggleState_Screens(
          cond = FALSE,
          range = seq_len(length(rv$config@steps)),
          is.enabled = is.enabled,
          rv = rv
        )
        
        
      } else {
        
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
      }
      
      # Update the initial length of the dataset with the length
      # of the one that has been received
      #rv$original.length <- length(dataIn())
      #})
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
    # can be a module, a Shiny app or another nav_process module for example,
    # nav_process_pipeline)
    list(
      dataOut = reactive({dataOut}),
      steps.enabled = reactive({rv$steps.enabled}),
      status = reactive({rv$steps.status})
    )
  })
}













#' @export
#' @rdname nav
#' @importFrom shiny fluidPage shinyApp
#' 
nav_process <- function(){
  server_env <- environment() # will see all dtwclust functions
  server_env$dev_mode <- FALSE
  
  # Uncomment and Change this for a process workflow
  proc.name <- 'PipelineDemo_Process1'
  pipe.name <- 'PipelineDemo'
  #name <- 'PipelineDemo_Description'
  layout <- c('h')
  
  path <- system.file(file.path('workflow', pipe.name), package='MagellanNTK')
  files <- list.files(file.path(path, 'R'), full.names = TRUE)
  for(f in files)
    source(f, local = FALSE, chdir = TRUE)
  
  app.path <- system.file('app', package='MagellanNTK')
  source(file.path(app.path, 'global.R'), local = FALSE, chdir = TRUE)
  
  ui <- fluidPage(
    tagList(
      fluidRow(
        column(width=2, actionButton('simReset', 'Remote reset',  class='info')),
        column(width=2, actionButton('simEnabled', 'Remote enable/disable', class='info')),
        column(width=2, actionButton('simSkipped', 'Remote is.skipped', class='info'))
      ),
      hr(),
      uiOutput('UI'),
      uiOutput('debugInfos_ui')
    )
  )
  
  server <- function(input, output, session){
    
    session$userData$workflow.path <- path
    
    data(sub_R25)
    
    rv <- reactiveValues(
      dataIn = sub_R25,
      dataOut = NULL
    )
    
    output$UI <- renderUI({nav_process_ui(proc.name)})
    
    output$debugInfos_ui <- renderUI({
      req(dev_mode)
      Debug_Infos_server(id = 'debug_infos',
        title = 'Infos from shiny app',
        rv.dataIn = reactive({rv$dataIn}),
        dataOut = reactive({rv$dataOut$dataOut()})
      )
      Debug_Infos_ui('debug_infos')
    })
    
    
    
    observe({
      
      rv$dataOut <- nav_process_server(
        id = proc.name,
        dataIn = reactive({rv$dataIn}),
        remoteReset = reactive({input$simReset}),
        is.skipped = reactive({input$simSkipped%%2 != 0}),
        is.enabled = reactive({input$simEnabled%%2 == 0})
        )
    })
  }
  
  
  shiny::shinyApp(ui, server)
  
}