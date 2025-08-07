#' @title dl
#'
#' @description  A shiny Module.
#'
#'
#' @param id internal
#' @param dataIn internal
#' @param filename xxx
#' @param data xxx
#'
#' @return NA
#'
#' @name build_report
#' @examples
#' if (interactive()) {
#'     data(sub_R25)
#'     shiny::runApp(build_report(sub_R25))
#'
#'     shiny::runApp(build_report(sub_R25, filename = "myDataset"))
#' }
#'
NULL


#' @importFrom shiny NS tagList h3
#'
#' @rdname build_report
#'
#' @export
#' @examples
#' NULL
build_report_ui <- function(id) {
    ns <- NS(id)
    tagList(
        h3("Build report (default)")
    )
}

#' @rdname build_report
#'
#' @importFrom shiny moduleServer reactiveValues observeEvent
#'
#' @export
#' @examples
#' NULL
build_report_server <- function(
        id,
        dataIn = reactive({
            NULL
        }),
        filename = "myDataset") {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        rv <- reactiveValues()

        observeEvent(dataIn(), ignoreNULL = TRUE, {

        })
    })
}




#' @rdname build_report
#' @importFrom shiny shinyApp reactive
#'
#' @export
#' @examples
#' NULL
#'
build_report <- function(data, filename = "myDataset") {
    ui <- build_report_ui("report")

    server <- function(input, output, session) {
        build_report_server("report",
            dataIn = reactive({
                data
            }),
            filename = filename
        )
    }

    app <- shiny::shinyApp(ui = ui, server = server)
}
