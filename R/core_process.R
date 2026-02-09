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
#' @param remoteReset It is a remote command to reset the module. A boolean that
#' indicates is the pipeline has been reseted by a program of higher level
#' Basically, it is the program which has called this module
#' 
#' @param remoteResetUI xxx
#' @param status xxx
#' @param history A `data.frame` which contains the history of the dataset for
#' the process of id `id`. If the value is NULL, that means the current process
#' has not been executed on the dataset, otherwise that means that the process
#' has already be run on the dataset. This parameter allows to update the
#' timeline of the process
#' @param is.skipped xxx
#'
#' @param btnEvents xxxx
#'
#' @param verbose A boolean to indicate whether to turn off (FALSE) or ON (TRUE)
#' the verbose mode for logs.
#' @param usermod A character to specifies the running mode of Magellan. 
#' * user (default) : xxx
#' * 'dev: xxx
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
#'     nav_process()
#' }
#'
#' @name nav_process
#'
#' @author Samuel Wieczorek
#' 
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
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
  
  tagList(
    div(
      uiOutput(ns('process_panel_ui_process')),
      uiOutput(ns('process_panel_ui_pipeline')),
      uiOutput(ns("EncapsulateScreens_pipeline_ui"))
      
  ))
}



#'
#' @export
#'
#' @rdname nav_process
#' @importFrom stats setNames
#' @importFrom crayon blue yellow
#' @import shiny
#'
nav_process_server <- function(
    id = NULL,
  dataIn = reactive({NULL}),
  status = reactive({NULL}),
  history = reactive({NULL}),
  is.enabled = reactive({TRUE}),
  remoteReset = reactive({0}),
  remoteResetUI = reactive({0}),
  is.skipped = reactive({FALSE}),
  verbose = FALSE,
  usermod = "user",
  btnEvents = reactive({NULL})
  ) {
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
      
      #status = NULL,
      
      #history = NULL,
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
      prev.remoteReset = 1,
      prev.remoteResetUI = 1,
      # current.pos Stores the current cursor position in the
      # timeline and indicates which of the process' steps is active
      current.pos = 1,
      length = NULL,
      config = NULL,
      rstBtn = reactive({0}),
      btnEvents = reactive({NULL}),
      doProceedAction = NULL
    )
    
    
    # 
    # output$process_panel_ui_process <- renderUI({
    # 
    #   .runmode <- if(!is.null(runmode)) runmode else session$userData$wf_mode
    #     
    #   req(.runmode == 'process')
    #   shiny::absolutePanel(
    #     left = default.layout$left_pipeline_sidebar,
    #     top = 0,
    #     height = default.layout$height_pipeline_sidebar,
    #     width = '350px',
    #     # style de la sidebar contenant les infos des process (timeline, boutons et parametres
    #     style = paste0(
    #       "position : absolute; ",
    #       "background-color: ", MagellanNTK::default.theme(session$userData$usermod)$bgcolor_pipeline_sidebar, "; ",
    #       "border-right: ", default.layout$line_width, "px solid ", default.layout$line_color, ";",
    #       "height: 100vh;"
    #     ),
    #     div(
    #       style = " align-items: center; justify-content: center; margin-bottom: 20px;",
    #       uiOutput(ns("proc_datasetNameUI"))
    #     ),
    #     div(id = ns('div_process_panel_ui_process_ui'),
    #       uiOutput(ns('process_btns_ui')),
    #     uiOutput(ns("testTL")),
    #       uiOutput(ns("EncapsulateScreens_process_ui"))
    #     )
    #   )
    # })
    
    
    output$process_panel_ui_pipeline <- renderUI({
      # .runmode <- if(!is.null(runmode)) runmode else session$userData$wf_mode
      # 
      # req(.runmode == 'pipeline')
      div(
        #style ="position: fixed;",
          uiOutput(ns('process_btns_ui')),
          uiOutput(ns("testTL"))
        )
    })
    
    output$process_btns_ui <- renderUI({
      div(
        style = paste0("
        display: flex; ",
          'padding-top: ', default.layout$padding_top_nav_process_ui, 'px;',
          'padding-left: ', default.layout$padding_left_nav_process_ui, 'px;',
          "align-items: center; ",
          "justify-content: center;",
          "background-color: ", MagellanNTK::default.theme(session$userData$usermod)$bgcolor_process_timeline, ";",
          "border-top: ", default.layout$line_width, "px solid ", default.layout$line_color, ";"
        ),
        uiOutput(ns('prevBtnUI')),
        mod_modalDialog_ui(id = ns("rstBtn")),
        div(id = ns('process_DoBtn'), uiOutput(ns('DoBtn'))),
        div(id = ns('process_DoProceedBtn'), uiOutput(ns('DoProceedBtn'))),
        
        uiOutput(ns('nextBtnUI'))
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
    
    
    output$DoBtn <- renderUI({

      rv$current.pos
      rv$steps.status
      
      enable.do.Btns <- FALSE
      len <- length(rv$config@steps)
      
      
      enable.do.Btns <-  unname(rv$steps.status[rv$current.pos]) != stepStatus$VALIDATED &&
        unname(rv$steps.status[len]) != stepStatus$VALIDATED && (!is.null(dataIn())) &&
        unname(rv$steps.status[rv$current.pos]) != stepStatus$SKIPPED &&
        unname(rv$steps.status[len]) != stepStatus$SKIPPED && (!is.null(dataIn())) &&
        status() != stepStatus$SKIPPED
      
      if (unlist(strsplit(id, '_'))[2] == 'Convert')
        enable.do.Btns <- TRUE
      
      if (len > 1){
   
      } else if (len == 1){
        
        if (('Description' == names(rv$steps.status)) ||
            ('Save' == names(rv$steps.status))
        ){
          enable.do.Btns <- unname(rv$steps.status) != stepStatus$VALIDATED
        }
      }
      
      
      if (length(names(rv$steps.status)) == 1 && 'Save' == names(rv$steps.status)){
        enable.do.Btns <- TRUE
      }
        
      
      widget <- actionButton(ns("DoBtn"), "Run", style = btn_css_style)
      MagellanNTK::toggleWidget(widget, enable.do.Btns)
    })


    output$DoProceedBtn <- renderUI({
      # Display the "do and proceed button"
      # 
      dataIn()
      rv$current.pos
      rv$steps.status
      
      widget <- actionButton(ns("DoProceedBtn"),
        tagList("Run ", shiny::icon('arrow-right')),
        style = btn_css_style
      )
      
      
      enable.doProceed.Btns <- FALSE
      len <- length(rv$config@steps)
      
      enable.doProceed.Btns <- unname(rv$steps.status[rv$current.pos]) != stepStatus$VALIDATED &&
        unname(rv$steps.status[len]) != stepStatus$VALIDATED && (!is.null(dataIn())) &&
        unname(rv$steps.status[rv$current.pos]) != stepStatus$SKIPPED &&
        unname(rv$steps.status[len]) != stepStatus$SKIPPED && (!is.null(dataIn())) &&
        status() != stepStatus$SKIPPED
      
      if (len > 1){
        enable.doProceed.Btns <- enable.doProceed.Btns && rv$current.pos != len
      } else if (len == 1){
        
        if (('Description' == names(rv$steps.status)) ||
            ('Save' == names(rv$steps.status))
        ){
          enable.doProceed.Btns <- unname(rv$steps.status) != stepStatus$VALIDATED
        }
      }
      
      if (unlist(strsplit(id, '_'))[2] == 'Convert')
        enable.doProceed.Btns <- TRUE
      
      
      
      if (length(names(rv$steps.status)) == 1 && 
          ('Save' == names(rv$steps.status) || 'Description' == names(rv$steps.status))
        ){
        enable.doProceed.Btns <- FALSE
      }
      
      
      MagellanNTK::toggleWidget(widget, enable.doProceed.Btns)
    })
    
    
    output$proc_datasetNameUI <- renderUI({
      div(
        style = paste0("padding-left: ", 100, "px;"),
        h3(id)
      )
    })
    
    
    observeEvent(status(), { rv$status <- status()})
    
    # Catch any event on the 'id' parameter. As this parameter is static
    # and is attached to the server, this function can be view as the
    # initialization of the server module. This code is generic to both
    # process and pipeline modules
      observeEvent(id, ignoreInit = FALSE, ignoreNULL = TRUE, {
        #browser()
      rv$rstBtn()
      
      rv$prev.remoteReset <- remoteReset()
      rv$prev.remoteResetUI <- remoteResetUI()
      
      ### Call the server module of the process/pipeline which name is
      ### the parameter 'id'.
      ### The name of the server function is prefixed by 'mod_' and
      ### suffixed by '_server'. This will give access to its config
      
      rv$proc.id <- unlist(strsplit(id, '_'))[2]
      rv$proc <- do.call(
        paste0(id, "_server"),
        list(
          id = id,
          dataIn = reactive({rv$temp.dataIn}),
          steps.enabled = reactive({rv$steps.enabled}),
          remoteReset = reactive({rv$rstBtn() + remoteReset() + remoteResetUI()}),
          steps.status = reactive({rv$steps.status}),
          current.pos = reactive({rv$current.pos}),
          btnEvents = reactive({rv$btnEvents})
        )
      )
      
      # Update the reactive value config with the config of the
      # pipeline
      rv$config <- rv$proc$config()

      n <- length(rv$config@steps)
      stepsnames <- names(rv$config@steps)
      rv$steps.status <- setNames(rep(stepStatus$UNDONE, n), nm = stepsnames)
      
      rv$steps.enabled <- setNames(rep(FALSE, n), nm = stepsnames)
      rv$steps.skipped <- setNames(rep(FALSE, n), nm = stepsnames)
      rv$currentStepName <- reactive({stepsnames[rv$current.pos]})
    },
      priority = 1000
    )
    
    
      
      
      output$testTL <- renderUI({
        timeline_process_server(
          id = "process_timeline",
          config = rv$config,
          status = reactive({rv$steps.status}),
          position = reactive({rv$current.pos}),
          enabled = reactive({rv$steps.enabled})
        )
        
        div(
          style = paste0(
            "background-color: ", MagellanNTK::default.theme(session$userData$usermod)$bgcolor_process_timeline, ";",
            "padding-top: ", default.layout$padding_top_process_sidebar, "px;",
            "padding-bottom: ", default.layout$padding_bottom_process_sidebar, "px;",
            "padding-left: ", default.layout$padding_left_process_sidebar, "px;",
            "border-bottom: ", default.layout$line_width, "px solid ", default.layout$line_color, ";"),
          timeline_process_ui(ns("process_timeline"))
        )
      })
      
      
      # This function uses the UI definition to:
      # 1 - initialize the UI (only the first screen is shown),
      # 2 - encapsulate the UI in a div (used to hide all screens at a time
      #     before showing the one corresponding to the current position)
      output$EncapsulateScreens_pipeline_ui <- renderUI({
        len <- length(rv$config@ll.UI)
        
        tagList(
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
        )
      })

    
    # Catch a new value on the parameter 'dataIn()' variable, sent by the
    # caller. This value may be NULL or contain a dataset.
    # The first action is to store the dataset in the temporary variable
    # temp.dataIn. Then, two behaviours:
    # 1 - if the variable is NULL. xxxx
    # 2 - if the variable contains a dataset. xxx
    observeEvent(dataIn(), ignoreNULL = FALSE, ignoreInit = FALSE, {
      req(rv$config)
      #browser()
      # Get the new dataset in a temporary variable
      rv$temp.dataIn <- dataIn()
     
      rv$history <- GetHistory(dataIn(), rv$proc.id)
      rv$steps.status <- setNames(
        rep(stepStatus$UNDONE, length(rv$steps.status)), 
        nm = names(rv$config@steps))


       rv$steps.status <- RefineProcessStatus(rv$history, rv$steps.status)

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

    })
    
    
    
    
    observeEvent(rv$proc$dataOut()$trigger,
      ignoreNULL = TRUE,
      ignoreInit = TRUE,
      {
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
          
          # Add this for the loading of a dataset in the descciption step
          if (!is.null(rv$proc$dataOut()$value))
            rv$dataIn <- rv$proc$dataOut()$value
          
          if (rv$doProceedAction == "Do_Proceed" && rv$current.pos < length(rv$config@steps)) {
            rv$current.pos <- rv$current.pos + 1
          }
        } # View intermediate datasets
        else if (rv$current.pos > 1 && rv$current.pos < length(rv$config@steps)) {
          rv$dataIn <- rv$proc$dataOut()$value
          
          if (rv$doProceedAction == "Do_Proceed" && rv$current.pos < length(rv$config@steps)) {
            rv$current.pos <- rv$current.pos + 1
          }
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
          #browser()
          # Update the 'dataOut' reactive value to return
          #  this dataset to the caller. this `nav_process`
          #  is only a bridge between the process and the  caller
          # For a pipeline, the output is updated each
          # time a process has been validated
          #browser()
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
    
    
    
    observeEvent(input$DoProceedBtn, ignoreInit = TRUE, {
      # Catch the event to send it to the process server
      rv$btnEvents <- paste0(names(rv$steps.status)[rv$current.pos], '_Do_Proceed_', input$DoProceedBtn)
      rv$doProceedAction <- "Do_Proceed"
    })
    
    observeEvent(input$DoBtn, ignoreInit = TRUE, {
      # Catch the event to send it to the process server
      rv$btnEvents <- paste0(names(rv$steps.status)[rv$current.pos], '_Do_', input$DoBtn)
      rv$doProceedAction <- "Do"
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
    
    
    # Function to update the status of the current process wrt the history
    # that has been sent by the pipeline server 
    
    RefineProcessStatus <- function(history, steps.status){
      req(history)
      req(steps.status)
      steps.status <- setNames(rep(stepStatus$UNDONE, length(steps.status)), 
        nm = names(steps.status))
     

      if (length(steps.status) > 1){
        steps.status[1] <- stepStatus$VALIDATED
        # It is not Description nor Save processes
        .ind <- which(names(steps.status) %in% history[, 'Step'])
        steps.status[.ind] <- stepStatus$VALIDATED
        steps.status['Save'] <- stepStatus$VALIDATED
      } else if (length(steps.status) == 1 && names(steps.status) == 'Description'){
        steps.status[1] <- stepStatus$VALIDATED
      } else if (length(steps.status) == 1 && names(steps.status) == 'Save'){
        steps.status[1] <- stepStatus$VALIDATED
      }
      
      
      return(steps.status)
    }
    
    observeEvent(rv$status, ignoreInit = TRUE, ignoreNULL = TRUE, {
     
      shinyjs::toggleState("DoProceedBtn", condition = unname(rv$status) == stepStatus$UNDONE)
      shinyjs::toggleState("DoBtn", condition = unname(rv$status) == stepStatus$UNDONE)
      
      if (rv$status == stepStatus$VALIDATED){
       req(rv$history)
        if (unlist(strsplit(id, '_'))[2] == 'Description' ||
            unlist(strsplit(id, '_'))[2] == 'Save'){
          rv$steps.status['Description'] <- stepStatus$VALIDATED
        } else{
          
          rv$steps.status <- RefineProcessStatus(rv$history, rv$steps.status)
        }
      } else if (rv$status == stepStatus$UNDONE){


      }
    })
    
    # Catch new status event from the module of the process
    # See https://github.com/daattali/shinyjs/issues/166
    # https://github.com/daattali/shinyjs/issues/25
    observeEvent(rv$steps.status, ignoreInit = FALSE, {
    
      rv$steps.status <- Discover_Skipped_Steps(rv$steps.status)
      
      rv$steps.enabled <- Update_State_Screens(
        is.skipped = is.skipped(),
        is.enabled = is.enabled(),
        rv = rv
      )
      
      # .size <- length(rv$steps.status)
      # if (rv$steps.status[.size] == stepStatus$VALIDATED) {
      #   # Set current position to the last one
      #   rv$current.pos <- .size
      #   browser()
      #   # If the last step is validated, it is time to send result by
      #   # updating the 'dataOut' reactiveValue.
      #   dataOut$trigger <- Timestamp()
      #   dataOut$value <- rv$dataIn
      # }
    })
    
    
    # @description
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
    
    ResetProcess <- function() {
      # The cursor is set to the first step
      rv$current.pos <- 1
      rv$history <- MagellanNTK::InitializeHistory()
      
        
    }
    
    observeEvent(rv$rstBtn(), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(rv$config)
      rv$dataIn <- rv$temp.dataIn <- dataIn()
      ResetProcess()
      
      
      # browser()
      # proc.name <- unlist(strsplit(id, '_'))[2]
      # if (proc.name == names(rv$dataIn)[length(rv$dataIn)]){
      #   #That means that the process has already been executed and
      #   #one miuste delete the last assay
      #   rv$dataIn <- QFeatures::removeAssay(rv$dataIn, length(rv$dataIn))
      #   rv$temp.dataIn <- rv$dataIn
      # }
      
      # Return the NULL value as dataset
      #browser()
        dataOut$trigger <- Timestamp()
      dataOut$value <- -10
    })
    
    observeEvent(remoteReset(), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(rv$config)
      if (rv$prev.remoteReset < unname(remoteReset())){
        rv$dataIn <- rv$temp.dataIn <- dataIn()
        ResetProcess()
        rv$prev.remoteReset <- remoteReset()
      }
    })
    
    observeEvent(remoteResetUI(), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(rv$config)
      if (rv$prev.remoteResetUI < unname(remoteResetUI())){
        shiny::withProgress(message = paste0("Reseting UI in process", id), {
          shiny::incProgress(0.5)
          ResetProcess()
          rv$prev.remoteResetUI <- remoteResetUI()
          shiny::incProgress(1)
        })
      }  
    })
    
    GetStepsNames <- reactive({
      names(rv$config@steps)
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
    
    
 
    
    
    observeEvent(rv$current.pos, ignoreInit = FALSE, {
      if (length(rv$config@steps) == 1){
        shinyjs::toggleState(id = "prevBtn", condition = FALSE)
        shinyjs::toggleState(id = "nextBtn", condition = FALSE)
      } else {
        # If the cursor is not on the first position, show the 'prevBtn'
        shinyjs::toggleState(id = "prevBtn", condition = rv$current.pos != 1)
        
        # If the cursor is set before the last step, show the 'nextBtn'
        shinyjs::toggleState(id = "nextBtn", condition = rv$current.pos < length(rv$config@steps))
      }
      
      
      enable.do.Btns <- enable.doProceed.Btns <- FALSE
      len <- length(rv$config@steps)
      
      enable.do.Btns <- enable.doProceed.Btns <- unname(rv$steps.status[rv$current.pos]) != stepStatus$VALIDATED &&
        unname(rv$steps.status[len]) != stepStatus$VALIDATED
      
      
      if (len > 1)
        enable.doProceed.Btns <- enable.doProceed.Btns && 
        rv$current.pos != len
      
      #shinyjs::toggleState("DoProceedBtn", condition = enable.doProceed.Btns)
      #shinyjs::toggleState("DoBtn", condition = enable.do.Btns)
      shinyjs::toggleState("DoProceedBtn", condition = TRUE)
      shinyjs::toggleState("DoBtn", condition = TRUE)
      
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
#' @rdname nav_process
#' @importFrom shiny fluidPage shinyApp
#'
nav_process <- function() {
  server_env <- environment() # will see all dtwclust functions
  server_env$dev_mode <- FALSE
  
  # Uncomment and Change this for a process workflow
  proc.name <- "PipelineDemo_Process1"
  pipe.name <- "PipelineDemo"
  # name <- 'PipelineDemo_Description'
  layout <- c("h")
  
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
      uiOutput("UI"),
      uiOutput("debugInfos_ui")
    )
  )
  
  server <- function(input, output, session) {
    session$userData$workflow.path <- path
    
    rv <- reactiveValues(
      dataIn = NULL,
      dataOut = NULL
    )
    
    output$UI <- renderUI({
      nav_process_ui(proc.name)
    })
    
    output$debugInfos_ui <- renderUI({
      req(server_env$dev_mode)
      Debug_Infos_server(
        id = "debug_infos",
        title = "Infos from shiny app",
        rv.dataIn = reactive({
          rv$dataIn
        }),
        dataOut = reactive({
          rv$dataOut$dataOut()
        })
      )
      Debug_Infos_ui("debug_infos")
    })
    
    
    
    observe({
      rv$dataOut <- nav_process_server(
        id = proc.name,
        dataIn = reactive({rv$dataIn}),
        remoteReset = reactive({input$simReset}),
        is.skipped = reactive({input$simSkipped %% 2 != 0}),
        is.enabled = reactive({input$simEnabled %% 2 == 0})
      )
    })
  }
  
  
  shiny::shinyApp(ui, server)
}