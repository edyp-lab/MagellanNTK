#' @title mod_open_demo_dataset_ui and mod_open_demo_dataset_server
#'
#' @description  A shiny Module.
#'
#' @param id A `character()` as the id of the Shiny module
#' @param dataIn An instance of class xxx
#' @param ... Additional parameters
#'
#' @name view_dataset
#'
#' @return A shiny App
#'
#' @examples
#' if (interactive()) {
#' data(lldata)
#' shiny::runApp(view_dataset(lldata))
#' }
#'
NULL




#' @export
#' @rdname view_dataset
#' @importFrom shiny NS tagList h3
#' @return NA
#'
view_dataset_ui <- function(id) {
    ns <- NS(id)
    tagList()
}


#' @rdname view_dataset
#'
#' @export
#' @importFrom shiny moduleServer reactiveValues reactive
#'
view_dataset_server <- function(
        id,
        dataIn = NULL,
        ...) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns


    })
}



#' @export
#' @rdname view_dataset
#' @importFrom shiny shinyApp reactiveValues reactive
#'
view_dataset <- function(dataIn, ...) {
    ui <- view_dataset_ui("demo")


    server <- function(input, output, session) {
        rv <- reactiveValues(
            dataIn = NULL
        )

        rv$dataIn <- view_dataset_server("demo",
            dataIn = reactive({
                dataIn
            }),
            ...
        )
    }

    app <- shinyApp(ui = ui, server = server)
}
