#' @title Export dataset Shiyny app
#'
#' @description  A shiny Module.
#'
#' @param id A `character()` as the id of the Shiny module
#' @param dataIn xxx
#' @param data xxx
#'
#' @name mod_export_dataset
#'
#' @examples
#' if (interactive()) {
#'     shiny::runApp(export_dataset(lldata))
#' }
#'
#' @return A list
#'
NULL




#' @export
#' @rdname mod_export_dataset
#' @importFrom shiny NS tagList actionButton
#'
export_dataset_ui <- function(id) {
    ns <- NS(id)
    tagList(
        h3(style = "color: blue;", "Export dataset"),
        actionButton(ns("export_btn"), "Export")
    )
}


#' @rdname mod_export_dataset
#'
#' @export
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#' @importFrom shiny moduleServer reactiveValues observeEvent
#'
export_dataset_server <- function(id, dataIn) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        ## -- Open a MSnset File --------------------------------------------
        observeEvent(input$export_btn, ignoreInit = TRUE, {

        })
    })
}




#' @rdname mod_export_dataset
#'
#' @export
#' @importFrom shiny fluidPage tagList textOutput reactiveValues observeEvent
#' shinyApp
#'
export_dataset <- function(data) {
    ui <- fluidPage(
        tagList(
            export_dataset_ui("export")
        )
    )

    server <- function(input, output, session) {
        export_dataset_server("export",
            dataIn = reactive({
                data
            })
        )
    }

    app <- shiny::shinyApp(ui, server)
}
