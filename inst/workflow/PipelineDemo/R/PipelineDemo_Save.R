
#' @rdname PipelineDemo
#' @export
#' 
PipelineDemo_Save_conf <- function(){
  MagellanNTK::Config(
    fullname = 'PipelineDemo_Save',
    mode = 'process'
  )
}


#' @rdname PipelineDemo
#' @export
#'
PipelineDemo_Save_ui <- function(id){
  ns <- NS(id)
}


#' @rdname PipelineDemo
#' @export
#' 
PipelineDemo_Save_server <- function(id,
  dataIn = reactive({NULL}),
  steps.enabled = reactive({NULL}),
  remoteReset = reactive({0}),
  steps.status = reactive({NULL}),
  current.pos = reactive({1}),
  btnEvents = reactive({NULL})
){
  # Define default selected values for widgets
  # By default, this list is empty for the Save module
  # but it can be customized
  widgets.default.values <- list()
  
  # Define default values for reactive values
  # By default, this list is empty for the Save module
  # but it can be customized
  rv.custom.default.values <- list()
  
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
    #---------------------------------SAVE--------------------------------------
    #
    ###########################################################################-
    output$Save <- renderUI({
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
    
    # To access data in the Save step without a Description step
    observeEvent(req(dataIn()), {
      rv$dataIn <- dataIn()
    })
    
    # oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(grepl('Save', btnEvents()))

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
