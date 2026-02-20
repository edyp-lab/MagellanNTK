#' @title A modal window to display messages
#' @description This module is not directly used by MagellanNTK core functions.
#' It is rather a useful tool for third part pipelines and processes.
#' @name mod_err_modal
#'
#' @param id A `character()` as the id of the Shiny module
#' @param title A `character()` as the title of the modal
#' @param text A `character()` as the content of the modal
#' @param footer The content of the footer . May be UI content
#'
#' @examples
#' if (interactive()) {
#'     shiny::runApp(mod_errorModal("myTitle", "myContent"))
#' }
#'
#' @return A shiny App
#'
NULL


#' @rdname mod_err_modal
#' @export
#'
mod_errorModal_ui <- function(id) {}

#' @rdname mod_err_modal
#' @export
#'
mod_errorModal_server <- function(id,
    title = NULL,
    text = NULL,
    footer = modalButton("Close")) {
    shiny::moduleServer(
        id,
        function(input, output, session) {
            observeEvent(TRUE, ignoreInit = FALSE, {
                shiny::showModal(
                    div(
                        id = "errModal",
                        tags$style("#errModal .modal-dialog{width: 600px;}"),
                        shiny::modalDialog(
                            h3(title, style = "color: red;"),
                            tags$style("#tPanel {overflow-y:scroll; color: black; background: white;}"),
                            shiny::wellPanel(
                                id = "tPanel",
                                HTML(paste(text, collapse = "<br/>")),
                                width = "250px"
                            ),
                            footer = footer,
                            easyClose = TRUE
                        )
                    )
                )
            })
        }
    )
}




#' @rdname mod_err_modal
#' @export
#'
mod_errorModal <- function(title = NULL, text = NULL) {
    ui <- fluidPage()

    server <- function(input, output) {
        mod_errorModal_server("test",
            title = title,
            text = text
        )
    }
    app <- shiny::shinyApp(ui, server)
}
