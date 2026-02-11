#' @title Shiny module to choose directory
#'
#' @name choose_dir
#'
#' @param id The 'id' of the Shiny module
#' @param path The initial path to be opened for choosing a directory
#' @param is.enabled A `boolean`. This variable is used as a remote command to specify
#' if the corresponding module is enabled/disabled in the calling module of
#' upper level.
#' For example, if this module is disabled, then this variable is set to TRUE. Then,
#' all the widgets will be disabled. If not, the enabling/disabling of widgets
#' is deciding by this module.
#' @param show.details xxx
#'
#' @examples
#' if(interactive()){
#' shiny::runApp(chooseDir())
#' }
#' 
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#'
#' @return A Shiny app
#' @author Samuel Wieczorek
NULL


#' @import shinyFiles
#' @export
#' @rdname choose_dir
chooseDir_ui <- function(id) {
    ns <- NS(id)
    fluidPage(
        shinyjs::useShinyjs(),
        uiOutput(ns("directory_ui")),
        shinyjs::hidden(uiOutput(ns("details_ckb_ui"))),
        shinyjs::hidden(
            div(
                id = ns("div_details"),
                tags$h5("Files"),
              DT::DTOutput(ns("files"))
            )
        )
    )
}


#' @import shinyFiles
#' @importFrom shiny checkboxInput
#' @export
#' @rdname choose_dir
chooseDir_server <- function(id,
    path = reactive({"~"}),
    is.enabled = reactive({TRUE}),
    show.details = FALSE) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        rv <- reactiveValues(path = NULL)

        observeEvent(path(), {
            rv$path <- path()
        })

        observe({
            shinyjs::toggle("details_ckb_ui", condition = show.details)
        })

        output$directory_ui <- renderUI({
            widget <- div(
                id = ns("div_directory"),
                directoryInput(ns("directory"),
                    label = "Selected directory",
                    value = rv$path
                )
            )
            toggleWidget(widget, condition = is.enabled())
        })


        output$details_ckb_ui <- renderUI({
            widget <- shiny::checkboxInput(ns("details_ckb"), "Show files details", value = FALSE)
            toggleWidget(widget, condition = is.enabled())
        })




        observeEvent(req(input$directory > 0), ignoreNULL = TRUE, {
            # condition prevents handler execution on initial app launch
            rv$path <- choose.dir(
                default = readDirectoryInput(session, "directory"),
                caption = "Choose a directory..."
            )

            updateDirectoryInput(session, "directory", value = rv$path)
        })



        observeEvent(input$details_ckb, {
            shinyjs::toggle("div_details", condition = isTRUE(input$details_ckb))
        })


        output$directory <- shiny::renderText({
            readDirectoryInput(session, "directory")
        })

        output$files <- DT::renderDT({
            files <- list.files(readDirectoryInput(session, "directory"), full.names = TRUE)
            data.frame(name = basename(files), file.info(files))
        })

        reactive({
            readDirectoryInput(session, "directory")
        })
    })
}


#' @export
#' @rdname choose_dir
chooseDir <- function(show.details = FALSE) {
    ui <- fluidPage(
        div(id = "div_test",
            chooseDir_ui("test")
        ),
        uiOutput("info")
    )

    server <- function(input, output, session) {
        observe({
            shinyjs::toggleState("div_test", condition = FALSE)
        })

        rv <- reactiveValues(path = "~")

        rv$path <- chooseDir_server("test",
            path = reactive({"~"}),
            is.enabled = reactive({TRUE}),
            show.details = show.details
        )


        output$info <- renderUI({
            rv$path
            p(rv$path())
        })
    }
    app <- shinyApp(ui, server)
}
