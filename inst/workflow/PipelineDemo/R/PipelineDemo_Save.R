#' @title xxx
#' @name PipelineDemo_Save
#' 
#' @examples
#' NULL
#' 
#' @importFrom QFeatures addAssay removeAssay
#' @import DaparToolshed
#' 

#' @export
#' @rdname PipelineDemo_Save
PipelineDemo_Save_conf <- function(){
  MagellanNTK::Config(
    fullname = 'PipelineDemo_Save',
    mode = 'process'
  )
}



#' @export
#' @rdname PipelineDemo_Save
PipelineDemo_Save_ui <- function(id){
  ns <- NS(id)
}


#' @export
#' @rdname PipelineDemo_Save
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
  rv.custom.default.values <- list()
  
   moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Insert necessary code which is hosted by MagellanNTK
    # DO NOT MODIFY THIS LINE
    
    core.code <- MagellanNTK::Get_Workflow_Core_Code(
      mode = 'process',
      name = id,
      w.names = names(widgets.default.values),
      rv.custom.names = names(rv.custom.default.values)
    )
    
    eval(str2expression(core.code))

    
    observeEvent(req(dataIn()), {
      rv$dataIn <- dataIn()
    })
    
    
    ###### ------------------- Code for Save (step 0) -------------------------    #####
    output$Save <- renderUI({

      MagellanNTK::process_layout(session,
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
    
  }
  )
}
