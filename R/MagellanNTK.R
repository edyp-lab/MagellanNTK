#' @title Main Shiny application
#'
#' @param id A `character()` as the id of the Shiny module
#' @param workflow.path A `character()` which is the path to the directory which 
#' contains the files and directories of the pipeline.
#' @param workflow.name A `character()` which is the name of the pipeline to
#' launch and run whithin the framework of MagellanNTK. It designs the name of 
#' a directory which contains the files and directories of the pipeline.
#' @param verbose A `boolean` to indicate whether to turn off (FALSE) or ON (TRUE)
#' the verbose mode for logs.
#' @param usermod A `character()` to specifies the running mode of MagellanNTK: 
#' 'user' (default) or 'dev'. For more details, please refer to the document 
#' 'Inside MagellanNTK'
#' @param ... Additional parameters
#' @param sidebarSize The width of the sidebar. Available values are 'small', 'medium', 'large'
#'
#' @name magellanNTK
#'
#' @examples
#' if (interactive()) {
#'     MagellanNTK()
#'     }
#'
#' @return A shiny app
#' 
#' @importFrom shiny shinyUI tagList moduleServer addResourcePath reactive
#' shinyApp runApp
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#'
#'
NULL





options(
  shiny.maxRequestSize = 3000 * 1024^2,
  encoding = "UTF-8",
  shiny.fullstacktrace = TRUE
)




#' @rdname magellanNTK
#'
#' @export
#'
MagellanNTK_ui <- function(id, sidebarSize = 'medium') {
    ns <- NS(id)
    .size <- switch(sidebarSize, 
      small = '150px',
      medium = '300px',
      large = '400px'
    )      
      mainapp_ui(id = ns("mainapp_module"), size = .size)
}




#' @export
#'
#' @rdname magellanNTK
#'
MagellanNTK_server <- function(
        id,
        workflow.path = reactive({NULL}),
        workflow.name = reactive({NULL}),
        verbose = FALSE,
        usermod = "user") {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns
        addResourcePath("www", system.file("app/www", package = "MagellanNTK"))
        
        
        mainapp_server("mainapp_module",
            workflow.path = reactive({workflow.path()}),
            workflow.name = reactive({workflow.name()}),
            verbose = verbose,
            usermod = usermod
        )
    })
}



#' @export
#'
#' @rdname magellanNTK
#'
MagellanNTK <- function(
         workflow.path = NULL,
        workflow.name = NULL,
        verbose = FALSE,
        usermod = "user",
        sidebarSize = 'medium',
        ...) {

  
  if (is.null(workflow.path))
  {
    warning("workflow.path is NULL. Abort...")
  }
  
  if (is.null(workflow.name))
  {
    warning("workflow.name is NULL. Abort...")
  }
  
  if(is.null(workflow.name) || is.null(workflow.path)) return(NULL)
  
  
    app.path <- system.file("app", package = "MagellanNTK")
    source(file.path(app.path, "global.R"), local = FALSE, chdir = TRUE)

    files <- list.files(file.path(workflow.path, "R"), full.names = TRUE)
    for (f in files) {
        source(f, local = FALSE, chdir = TRUE)
    }

    source_shinyApp_files()

    ui <- MagellanNTK_ui("infos", sidebarSize = sidebarSize)


    server <- function(input, output, session) {
        MagellanNTK_server("infos",
            workflow.path = reactive({workflow.path}),
            workflow.name = reactive({workflow.name}),
            verbose = verbose,
            usermod = usermod
        )
    }

    # Launch app
    app <- shiny::shinyApp(ui, server)

    shiny::runApp(app,
      launch.browser = TRUE,
      port = 3838,
      host = "127.0.0.1"
    )
}
