#' @title Main Shiny application
#' @description xxx
#' 
#' @param id xxx
#' @param obj xxx
#' @param workflow.path xxx
#' @param workflow.name xxxx
#' @param verbose A `boolean(1)` 
#' @param usermod xxx
#' 
#' 
#' 
#' @details
#' The list of customizable funcs (param `funcs`) contains the following items:
#' 
#'  These are the default values where each item points to a default fucntion
#'  implemented into MagellanNTK.
#'  
#'  The user can modify these values by two means:
#'  * setting the values in the parameter to pass to the function 
#'  `MagellanNTK()`,
#'  * inside the UI of MagellanNTK, in the settings panels
#'  
#' @name magellanNTK
#' 
#' @examples
#' \dontrun{
#' MagellanNTK()
#' }
#' 
NULL

#' The application User-Interface
#'     DO NOT REMOVE.
#' @importFrom shiny shinyUI tagList 
#' @importFrom shinydashboardPlus dashboardSidebar dashboardPage dashboardHeader 
#' @importFrom shinyjs useShinyjs extendShinyjs
#' 
#' @rdname magellanNTK
#' 
#' @export
#' 
MagellanNTK_ui <- function(id){
  ns <- NS(id)
  # shiny::tagList(
  #   #launchGA(),
  #   shinyjs::useShinyjs(),
  #   shinyjs::extendShinyjs(
  #     text = "shinyjs.resetProstar = function() {history.go(0)}",
  #     functions = c("resetProstar")),
  #   
  #   shiny::titlePanel("", windowTitle = "Prostar"),
    #hidden(div(id = 'div_mainapp_module',
    #
    mainapp_ui(ns('mainapp_module'))
    #)
  #)
}



options(shiny.maxRequestSize=3000*1024^2,
  encoding = "UTF-8",
  shiny.fullstacktrace = TRUE
)
require(compiler)
enableJIT(3)


#' The application server-side
#' 
#'     DO NOT REMOVE.
#' @importFrom shiny moduleServer addResourcePath reactive
#' 
#' @export
#' 
#' 
#' @rdname magellanNTK
#' 
MagellanNTK_server <- function(
    id,
  dataIn = reactive({NULL}),
  workflow.path = reactive({NULL}),
  workflow.name = reactive({NULL}),
  verbose = FALSE,
  usermod = 'dev'){
  
  moduleServer(id, function(input, output, session){
    ns <- session$ns 
    #addResourcePath(prefix = "www", directoryPath = "./www")
    addResourcePath('www', system.file('app/www', package='MagellanNTK'))
    
    #shiny::observeEvent(funcs, {
    #  for(i in names(funcs))
    #    requireNamespace(unlist(strsplit(funcs[[i]], split='::'))[1])
      
    
    # observeEvent(path, {
    #   session$userData$workflow.path <- path
    #   
    #   session$userData$funcs <- readConfigFile(path)$funcs
    #   
    # })
    # 
    

      #shinyjs::toggle('mainapp_module', condition = !is.null(funcs))
      mainapp_server('mainapp_module',
        dataIn = reactive({dataIn()}),
        workflow.path = reactive({workflow.path()}),
        workflow.name = reactive({workflow.name()}),
        verbose = verbose,
        usermod = usermod
        )
    })
  }
#)
#}



#'  
#' @importFrom shiny shinyApp runApp
#' 
#' 
#' @examples
#' \dontrun{
#' # launch without initial config
#' shiny::runApp(MagellanNTK())
#' }
#' 
#' @export
#' 
#' @rdname magellanNTK
#' 
MagellanNTK <- function(
    obj = NULL,
    workflow.path = NULL,
    workflow.name = NULL,
    verbose = FALSE,
    usermod = 'dev') {
  
  # options(
  #   shiny.maxRequestSize = 1024^3,
  #   port = 3838,
  #   host = "0.0.0.0",
  #   launch.browser = FALSE,
  #   browser = NULL
  # )
  

  files <- list.files(file.path(workflow.path, 'R'), full.names = TRUE)
  for(f in files)
    source(f, local = FALSE, chdir = TRUE)
  
  
  source_shinyApp_files()
  
  # Set global variables to global environment
  #.GlobalEnv$funcs <- funcs
  #.GlobalEnv$workflow <- workflow
  
  #on.exit(rm(funcs, envir = .GlobalEnv))
  #on.exit(rm(workflow, envir=.GlobalEnv))
  
  #source_wf_files(workflow$path)
  #
  ui <-  MagellanNTK_ui("infos")
  
  
  server <- function(input, output, session) {
    
    MagellanNTK_server("infos",
      dataIn = reactive({obj}),
      workflow.path = reactive({workflow.path}),
      workflow.name = reactive({workflow.name}),
      verbose = verbose,
      usermod = usermod
      )
}
  
  # Launch app
  app <- shiny::shinyApp(ui, server)
  
  if (usermod == 'dev')
    shiny::runApp(app, 
      #launch.browser = FALSE, 
      port = 3838, 
      host = "0.0.0.0")
  else if (usermod == 'user')
    shiny::runApp(app, 
      #launch.browser = FALSE, 
      port = 3838, 
      host = "0.0.0.0")

}
