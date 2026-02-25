
#' @rdname PipelineDemo
#' @export
#' 
nomPipeline_Process1_conf <- function(){
  MagellanNTK::Config(
    fullname = 'nomPipeline_Process1',
    mode = 'process',
    steps = c('Step 1'),
    mandatory = c(TRUE)
  )
}


#' @rdname PipelineDemo
#' @export
#'
nomPipeline_Process1_ui <- function(id){
  ns <- NS(id)
}


#' @rdname PipelineDemo
#' @export
#' 
nomPipeline_Process1_server <- function(id,
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
    SD_choice = 1
  )
  
  # Define default values for reactive values
  rv.custom.default.values <- list(
    history = MagellanNTK::InitializeHistory()
  )
  
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
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(grepl('Description', btnEvents()))
      
      req(dataIn())
      rv$dataIn <- dataIn()

      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Description'] <- MagellanNTK::stepStatus$VALIDATED
    })

    ###########################################################################-
    #
    #----------------------------DATAGENERATION---------------------------------
    #
    ###########################################################################-
    output$DataGeneration <- renderUI({
      shinyjs::useShinyjs()
      
      # Function for layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(
          uiOutput(ns('DataGeneration_widgets_UI'))
        ),
        content = tagList(
          h3("Preview :"),
          DT::dataTableOutput(ns('DataGeneration_tabs_UI'))
          )
      )
    })
    
    # Define widgets for the step
    output$DataGeneration_widgets_UI <- renderUI({
      widget <- numericInput(ns("SD_choice"),
                             "Choose sd",
                             value = rv.widgets$SD_choice,
                             min = 0,
                             step = 1,
                             width = "200px")
      
      MagellanNTK::toggleWidget(widget, rv$steps.enabled["DataGeneration"])
    })
    
    # Create datatable for the step
    output$DataGeneration_tabs_UI <- DT::renderDT({
      req(rv$dataIn)
      req(rv$steps.status['Description'] == MagellanNTK::stepStatus$VALIDATED)
      
      DT::datatable(
        SummarizedExperiment::assay(rv$dataIn, length(rv$dataIn))
      )
    })
    
    # oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(grepl('DataGeneration', btnEvents()))
      
      # Create temporary duplicate of dataset to perform data generation
      datatmp <- rv$dataIn[[length(rv$dataIn)]]
      # Proceed with data generation
      nbcol <- ncol(datatmp)
      nbrow <- nrow(datatmp)
      gauss1 <- matrix(rnorm(nbcol * ceiling(nbrow/2), mean = 10, sd = rv.widgets$SD_choice), ncol = nbcol)
      gauss2 <- matrix(rnorm(nbcol * floor(nbrow/2), mean = 30, sd = rv.widgets$SD_choice), ncol = nbcol)
      assaytmp <- rbind(gauss1, gauss2)
      colnames(assaytmp) <- colnames(datatmp)
      if (is.null(rownames(datatmp))){
        rownames(datatmp) <- 1:nrow(datatmp)
      }
      rownames(assaytmp) <- rownames(datatmp)
      SummarizedExperiment::assay(datatmp) <- assaytmp
      
      # Add to history
      rv.custom$history <- Add2History(rv.custom$history, 'DataGeneration', 'DataGeneration', 'SD choice', rv.widgets$SD_choice)
      
      # Add generated dataset
      rv$dataIn <- do.call(
        eval(parse(text = session$userData$funcs$addDatasets)), 
        list(object = rv$dataIn, 
          dataset = datatmp,
          name = 'DataGeneration'
        )
      )

      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['DataGeneration'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    ###########################################################################-
    #
    #---------------------------------SAVE--------------------------------------
    #
    ###########################################################################-
    output$Save <- renderUI({
      # Function for layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(),
        content = tagList()
      )
    })
    
    # oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Save', btnEvents()))

      # Add step history to the dataset history
      len <- length(rv$dataIn)
      rv$dataIn[[len]] <- SetHistory(rv$dataIn[[len]], rv.custom$history)
      
      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- rv$dataIn
      rv$steps.status['Save'] <- MagellanNTK::stepStatus$VALIDATED
    })

    # Insert necessary code which is hosted by MagellanNTK
    # DO NOT MODIFY THIS LINE
    eval(parse(text = MagellanNTK::Module_Return_Func()))
  }
  )
}
