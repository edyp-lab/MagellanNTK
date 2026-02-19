

#' @title xxx
#' @description xxx
#' @name mod_convert
#' @author Samuel Wieczorek, Manon Gaudin
#' @examples
#' if (interactive()){
#' library(MagellanNTK)
#' path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
#' shiny::runApp(proc_workflowApp("PipelineDemo_Convert", path))
#' }
#' 
NULL


#' @rdname mod_convert
#' @export
#' 
PipelineDemo_Convert_conf <- function(){
  # This list contains the basic configuration of the process
  MagellanNTK::Config(
    fullname = 'PipelineDemo_Convert',
    # Define the type of module
    mode = 'process',
    # List of all steps of the process
    steps = c('Step1'),
    # A vector of boolean indicating if the steps are mandatory or not.
    mandatory = c(TRUE)
    
  )
}



#' @title   mod_choose_pipeline_ui and mod_choose_pipeline_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#'
#' @rdname mod_convert
#'
#' @keywords internal
#' @export
#'
#' @importFrom shiny NS tagList
#' @import sos
#'
#' @return NA
#'
PipelineDemo_Convert_ui <- function(id) {
  ns <- NS(id)
}




#' Convert Server Function
#'
#' @param id xxx
#' @param dataIn xxx
#' @param steps.enabled xxx
#' @param remoteReset A `logical(1)` which acts as a remote command to reset
#' the module to its default values. Default is FALSE.
#'
#' @importFrom shinyjs disabled info
#' @importFrom stats setNames
#' @importFrom utils read.csv
#'
#' @export
#'
#' @rdname mod_convert
#'
#' @return NA
#'
PipelineDemo_Convert_server <- function(id,
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
