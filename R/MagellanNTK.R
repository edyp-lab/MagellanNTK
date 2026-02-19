#' @title Main Shiny application
#' @description xxx
#'
#' @param id A `character()` as the id of the Shiny module
#' @param workflow.path A `character()` which is the path to the directory which 
#' contains the files and directories of the pipeline.
#' @param workflow.name A `character()` which is the name of the pipeline to
#' launch and run whithin the framework of MagellanNTK. It designs the name of 
#' a directory which contains the files and directories of the pipeline.
#' @param verbose A `boolean` to indicate whether to turn off (FALSE) or ON (TRUE)
#' the verbose mode for logs.
#' @param usermod A character to specifies the running mode of MagellanNTK. 
#' * user (default) : xxx
#' * dev: xxx
#' @param ... Additional parameters
#' @param sidebarSize The width of the sidebar. Available values are 'small', 'medium', 'large'
#'
#'
#' @details
#' The list of customizable functions (param `funcs`) contains the following items:
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
#' if (interactive()) {
#'     MagellanNTK()
#'     }
#'
#' @return A shiny app
#'
NULL

#' The application User-Interface
#'     DO NOT REMOVE.
#' @importFrom shiny shinyUI tagList
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#'
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



options(
    shiny.maxRequestSize = 3000 * 1024^2,
    encoding = "UTF-8",
    shiny.fullstacktrace = TRUE
)


#' @importFrom shiny moduleServer addResourcePath reactive
#'
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
# )
# }




#' @importFrom shiny shinyApp runApp
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

    if (usermod == "dev") {
        shiny::runApp(app,
            launch.browser = TRUE,
            port = 3838,
            host = "127.0.0.1"
        )
    } else if (usermod == "user") {
        shiny::runApp(app,
            launch.browser = TRUE,
            port = 3838,
            host = "127.0.0.1"
        )
    }
}
