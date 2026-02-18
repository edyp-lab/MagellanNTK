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
#' In this example, `PipelineDemo_Preprocessing_ui()` and `PipelineDemo_Preprocessing_server()` define
#' the code for the process `PipelineDemo_Preprocessing` which is part of the pipeline called `PipelineDemo`.
#' 
#' @examples
#' if (interactive()){
#' library(MagellanNTK)
#' data(lldata, package = 'MagellanNTK')
#' path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
#' shiny::runApp(proc_workflowApp("PipelineDemo_Preprocessing", path, dataIn = lldata))
#' }
#' 
#' @importFrom QFeatures addAssay removeAssay
#' @import DaparToolshed
#' 
NULL

#' @rdname PipelineDemo
#' @export
#' 
PipelineDemo_Preprocessing_conf <- function(){
  MagellanNTK::Config(
    fullname = 'PipelineDemo_Preprocessing',
    mode = 'process',
    steps = c('Filtering', 'Normalization'),
    mandatory = c(FALSE, TRUE)
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
PipelineDemo_Preprocessing_ui <- function(id){
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
PipelineDemo_Preprocessing_server <- function(id,
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
    Filtering_Value = 10,
    Filtering_Operator = "<=",
    Filtering_Type = "Mean",
    Normalization_Type = "Sum"
  )
  
  # Define default values for reactive values
  rv.custom.default.values <- list(
    dataIn1 = NULL,
    dataIn2 = NULL,
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
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Description', btnEvents()))
      
      req(dataIn())
      rv$dataIn <- dataIn()
      
      # As there is two sub-step, creates two duplicates
      rv.custom$dataIn1 <- rv$dataIn
      rv.custom$dataIn2 <- rv$dataIn
      
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Description'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    ###########################################################################-
    #
    #-------------------------------FILTERING-----------------------------------
    #
    ###########################################################################-
    output$Filtering <- renderUI({
      shinyjs::useShinyjs()
      
      # Function for layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(
          uiOutput(ns("Filtering_widgets_UI"))
        ),
        content = tagList(
          plotOutput(ns("Filtering_plot_UI"))
        )
      )
    })
    
    # Define widgets for the step
    output$Filtering_widgets_UI <- renderUI({
      widget <- tagList(
        selectInput(
          ns('Filtering_Type'),
          "Type of filter",
          choices = c("Mean", "Sum"),
          selected = rv.widgets$Filtering_Type,
          width = "200px"),
        
        selectInput(
          ns('Filtering_Operator'),
          "Type of operator",
          choices = c( "<=", "<", ">=", ">"),
          selected = rv.widgets$Filtering_Operator,
          width = "200px"),
        
        numericInput(ns('Filtering_Value'),
                     "Value",
                     value = rv.widgets$Filtering_Value,
                     min = 0,
                     step = 0.1,
                     width = "200px")
      )
      
      MagellanNTK::toggleWidget(widget, rv$steps.enabled["Filtering"])
    })
    
    # Create plot for the step
    output$Filtering_plot_UI <- renderPlot({
      req(rv.custom$dataIn1)
      
      plotdata <- switch(rv.widgets$Filtering_Type,
             Mean = rowMeans(SummarizedExperiment::assay(rv.custom$dataIn1[[length(rv.custom$dataIn1)]])),
             Sum = rowSums(SummarizedExperiment::assay(rv.custom$dataIn1[[length(rv.custom$dataIn1)]]))
      )
      
      hist(plotdata, 
           main = paste0("Histogram of ", rv.widgets$Filtering_Type, " row values"), 
           xlab = paste0("row ", rv.widgets$Filtering_Type, "value"))
    })
    
    # oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Filtering', btnEvents()))
      req(rv.custom$dataIn1)
      
      # Create temporary duplicate of dataset to perform filtering
      datatmp <- rv.custom$dataIn1[[length(rv.custom$dataIn1)]]
      # Proceed with filtering
      rowval <- switch(rv.widgets$Filtering_Type,
             Mean = rowMeans(SummarizedExperiment::assay(rv.custom$dataIn1[[length(rv.custom$dataIn1)]])),
             Sum = rowSums(SummarizedExperiment::assay(rv.custom$dataIn1[[length(rv.custom$dataIn1)]]))
      )
      op <- match.fun(rv.widgets$Filtering_Operator)
      idx_rm <- which(op(rowval, rv.widgets$Filtering_Value))
      if (length(idx_rm) != 0){
        assaytmp <- SummarizedExperiment::assay(datatmp)[-idx_rm, ]
        datatmp <- SummarizedExperiment::SummarizedExperiment(assaytmp)
      }
      
      # Add to history
      rv.custom$history <- Add2History(rv.custom$history, 'Preprocessing', 'Filtering', 'Type', rv.widgets$Filtering_Type)
      rv.custom$history <- Add2History(rv.custom$history, 'Preprocessing', 'Filtering', 'Operator', rv.widgets$Filtering_Operator)
      rv.custom$history <- Add2History(rv.custom$history, 'Preprocessing', 'Filtering', 'Value', rv.widgets$Filtering_Value)
      
      # Add filtered dataset
      rv.custom$dataIn1 <- do.call(
        eval(parse(text = session$userData$funcs$addDatasets)), 
        list(object = rv.custom$dataIn1, 
          dataset = datatmp,
          name = paste0(names(rv.custom$dataIn1)[length(rv.custom$dataIn1)], '_filtered')
        )
      )
      
      # Transfer the new dataset to the second sub-step
      rv.custom$dataIn2 <- rv.custom$dataIn1
     
      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Filtering'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    ###########################################################################-
    #
    #----------------------------NORMALIZATION----------------------------------
    #
    ###########################################################################-
    output$Normalization <- renderUI({
      shinyjs::useShinyjs()
      
      # Function for layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(
          uiOutput(ns("Normalization_widgets_UI"))
        ),
        content = tagList(
          plotOutput(ns("Normalization_plot_UI"))
        )
      )
    })
    
    # Define widgets for the step
    output$Normalization_widgets_UI <- renderUI({
      widget <- tagList(
        selectInput(
          ns('Normalization_Type'),
          "Normalization type",
          choices = c("Mean", "Sum"),
          selected = rv.widgets$Normalization_Type,
          width = "200px"),
      )
      
      MagellanNTK::toggleWidget(widget, rv$steps.enabled["Normalization"])
    })
    
    # Create plot for the step
    output$Normalization_plot_UI <- renderPlot({
      req(rv.custom$dataIn2)
      
      boxplot(SummarizedExperiment::assay(rv.custom$dataIn2[[length(rv.custom$dataIn2)]]))
    })
    
    # oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Normalization', btnEvents()))
      
      # Create temporary duplicate of dataset to perform normalization
      datatmp <- rv.custom$dataIn2[[length(rv.custom$dataIn2)]]
      # Proceed with normalization
      assaytmp <- switch(rv.widgets$Normalization_Type,
                       Mean = apply(SummarizedExperiment::assay(datatmp), 2, function(x){x/sum(x)}),
                       Sum = apply(SummarizedExperiment::assay(datatmp), 2, function(x){x/sum(x)})
      )
      SummarizedExperiment::assay(datatmp) <- assaytmp
      
      # Adding to history
      rv.custom$history <- Add2History(rv.custom$history, 'Preprocessing', 'Normalization', 'Type', rv.widgets$Normalization_Type)
      
      # Add normalized dataset
      rv.custom$dataIn2 <- do.call(
        eval(parse(text = session$userData$funcs$addDatasets)),
        list(object = rv.custom$dataIn2,
          dataset = datatmp,
          name = paste0(names(rv.custom$dataIn2)[length(rv.custom$dataIn2)], '_filtered')
        )
      )
      
      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Normalization'] <- MagellanNTK::stepStatus$VALIDATED
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
      
      # As there is two sub-step, if both are performed there is two new dataset instead of one
      # Removing the first created out of the two if that is the case
      len_start <- length(rv$dataIn)
      len_end <- length(rv.custom$dataIn2)
      len_diff <- len_end - len_start
      
      req(len_diff > 0)
      
      if (len_diff == 2)
        rv.custom$dataIn2 <- keepDatasets(rv.custom$dataIn2, -(len_end - 1))
      
      # Rename the new dataset with the name of the process
      names(rv.custom$dataIn2)[length(rv.custom$dataIn2)] <- 'Preprocessing'
      
      # Add step history to the dataset history
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
