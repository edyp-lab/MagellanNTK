#' @title Error modal shiny module.
#'
#' @description A shiny module that shows messages in modal.
#'
#' @param id A `character()` as the id of the Shiny module
#' @param msg The text to display in the modal
#'
#' @name errorModal
#'
#' @examples
#' if (interactive()) {
#'     shiny::runApp(errorModal("my error text"))
#' }
#' 
#' @return A shiny App
#' @importFrom shiny moduleServer observeEvent showModal modalDialog wellPanel
#' HTML
#'
NULL


#' @rdname errorModal
#'
#' @export
#'
errorModal_ui <- function(id) {}

#' @rdname errorModal
#' @export
#'
errorModal_server <- function(id, msg) {
    shiny::moduleServer(id, function(input, output, session) {
        observeEvent(TRUE, ignoreInit = FALSE, {
            shiny::showModal(
                div(
                    id = "errModal",
                    tags$style("#errModal .modal-dialog{width: 600px;}"),
                    shiny::modalDialog(
                        h3("Error log"),
                        tags$style("#tPanel {overflow-y:scroll; color: red;}"),
                        shiny::wellPanel(
                            id = "tPanel",
                            HTML(paste("> ", msg, collapse = "<br/>"))
                        ),
                        easyClose = TRUE
                    )
                )
            )
        })
    })
}





#' @export
#' @rdname errorModal
#' @importFrom shiny fluidPage shinyApp
#'
errorModal <- function(msg) {
    ui <- fluidPage(
        errorModal_ui(id = "ex")
    )

    server <- function(input, output) {
        errorModal_server(id = "ex", msg = msg)
    }

    app <- shiny::shinyApp(ui, server)
}
