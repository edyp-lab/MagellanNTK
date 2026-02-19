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
#' In this example, `PipelineDemo_Clustering_ui()` and `PipelineDemo_Clustering_server()` define
#' the code for the process `PipelineDemo_Clustering` which is part of the pipeline called `PipelineDemo`.
#' 
#' @examples
#' if (interactive()){
#' library(MagellanNTK)
#' data(lldata, package = 'MagellanNTK')
#' path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
#' shiny::runApp(proc_workflowApp("PipelineDemo_Clustering", path, dataIn = lldata))
#' }
#' 
#' 
NULL

#' @rdname PipelineDemo
#' @export
#' 
PipelineDemo_Clustering_conf <- function(){
  MagellanNTK::Config(
    fullname = 'PipelineDemo_Clustering',
    mode = 'process',
    steps = c('Clustering'),
    mandatory = c(FALSE)
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
PipelineDemo_Clustering_ui <- function(id){
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
PipelineDemo_Clustering_server <- function(id,
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
    Clustering_Method = "kmeans",
    Clustering_Nbclust = 2
  )
  
  # Define default selected values for widgets
  rv.custom.default.values <- list(
    history = MagellanNTK::InitializeHistory(),
    clusters = NA
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
      
      rv.custom$clusters <- rep("-", nrow(rv$dataIn[[length(rv$dataIn)]]))
      
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Description'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    ###########################################################################-
    #
    #------------------------------CLUSTERING-----------------------------------
    #
    ###########################################################################-
    output$Clustering <- renderUI({
      shinyjs::useShinyjs()
      
      # Function for layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(
          uiOutput(ns("Clustering_widgets_UI"))
        ),
        content = tagList(
          DT::DTOutput(ns("Clustering_tabs_UI")),
        )
      )
    })
    
    # Define widgets for the step
    output$Clustering_widgets_UI <- renderUI({
      widget <- tagList(
        selectInput(
          ns('Clustering_Method'),
          "Choose method",
          choices = c("kmeans", "hclust"),
          selected = rv.widgets$Clustering_Method,
          width = "200px"),
        
        numericInput(ns("Clustering_Nbclust"),
          "Number of clusters",
          value = rv.widgets$Clustering_Nbclust,
          min = 1,
          max = nrow(rv$dataIn[[length(rv$dataIn)]]),
          step = 1,
          width = "200px")
      )
      
      MagellanNTK::toggleWidget(widget, rv$steps.enabled["Clustering"])
    })
    
    # Create datatable for the step
    output$Clustering_tabs_UI <- DT::renderDT({
      req(rv$dataIn)
      req(rv$steps.status['Description'] == MagellanNTK::stepStatus$VALIDATED)
      
      DT::datatable(
        data.frame(rownames = rownames(rv$dataIn[[length(rv$dataIn)]]), cluster = rv.custom$clusters)
      )
    })
    
    # oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Clustering', btnEvents()))
      
      # Create temporary duplicate of dataset to perform clustering
      datatmp <- rv$dataIn[[length(rv$dataIn)]]
      # Proceed with clustering
      if (rv.widgets$Clustering_Method == "kmeans") {
        rv.custom$clusters <- kmeans(SummarizedExperiment::assay(datatmp), centers = rv.widgets$Clustering_Nbclust)$cluster
      } else if (rv.widgets$Clustering_Method == "hclust") {
        hc <- hclust(dist(SummarizedExperiment::assay(datatmp)))
        rv.custom$clusters <- cutree(hc, k = rv.widgets$Clustering_Nbclust)
      }
      SummarizedExperiment::rowData(datatmp)$Cluster <- as.factor(rv.custom$clusters)
      
      # Adding to history
      rv.custom$history <- Add2History(rv.custom$history, 'Clustering', 'Clustering', 'Method', rv.widgets$Clustering_Method)
      rv.custom$history <- Add2History(rv.custom$history, 'Clustering', 'Clustering', 'Nb clusters', rv.widgets$Clustering_Nbclust)
      
      # Add clustered dataset
      rv$dataIn <- do.call(
        eval(parse(text = session$userData$funcs$addDatasets)), 
        list(object = rv$dataIn, 
             dataset = datatmp,
             name = 'Clustering'
        )
      )
     
      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Clustering'] <- MagellanNTK::stepStatus$VALIDATED
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
