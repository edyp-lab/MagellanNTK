

#' @rdname mod_convert
#' @export
#' 
Demo_Convert_conf <- function(){
  # This list contains the basic configuration of the process
  MagellanNTK::Config(
    fullname = 'Demo_Convert',
    # Define the type of module
    mode = 'process',
    # List of all steps of the process
    steps = c('Step1'),
    # A vector of boolean indicating if the steps are mandatory or not.
    mandatory = c(TRUE)
    
  )
}



#' @rdname Demo
#' @export
#'
Demo_Convert_ui <- function(id) {
  ns <- NS(id)
}


#' @importFrom shinyjs disabled info
#' @importFrom stats setNames
#' @importFrom utils read.csv
#'
#' @export
#'
#' @rdname Demo

Demo_Convert_server <- function(id,
  dataIn = reactive({NULL}),
  steps.enabled = reactive({TRUE}),
  remoteReset = reactive({NULL}),
  steps.status = reactive({NULL}),
  current.pos = reactive({1}),
  btnEvents = reactive({NULL})
) {
  
  widgets.default.values <- list()
  
  rv.custom.default.values <- list()
  
  
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
      
      MagellanNTK::process_layout_process(session,
        ns = NS(id),
        sidebar = tagList(),
        content = tagList()
      )
    })
    
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(grepl('Description', btnEvents()))

        rv$dataIn <- dataIn()
        dataOut$trigger <- MagellanNTK::Timestamp()
        dataOut$value <- rv$dataIn
        rv$steps.status['Description'] <- MagellanNTK::stepStatus$VALIDATED
    })
    

    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(grepl('Step1', btnEvents()))
          
      # DO NOT MODIFY THE THREE FOLLOWINF LINES
    dataOut$trigger <- MagellanNTK::Timestamp()
     dataOut$value <- NULL
    rv$steps.status['SelectFile'] <- MagellanNTK::stepStatus$VALIDATED
    })
    

    
    output$Save <- renderUI({
      MagellanNTK::process_layout_process(session,
        ns = NS(id),
        sidebar = tagList(),
        content = tagList()
      )
    })
    
    
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE, {
      req(grepl('Save', btnEvents()))
      
      # DO NOT MODIFY THE THREE FOLLOWINF LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- rv$dataIn
      rv$steps.status['Save'] <- MagellanNTK::stepStatus$VALIDATED
    })
    # Insert necessary code which is hosted by MagellanNTK
    # DO NOT MODIFY THIS LINE
    eval(parse(text = MagellanNTK::Module_Return_Func()))
  })
}
