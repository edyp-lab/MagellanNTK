#' @title A shiny app to display a modal
#' @description This module is not directly used by MagellanNTK core functions.
#' It is rather a useful tool for third part pipelines and processes.
#' @param id A `character()` as the id of the Shiny module
#' @param title The title to be displayed in the window
#' @param text The titmessage to be displayed in the window
#' @param showClipBtn A `boolean` to indicates if the copy to clipboard button
#' is shown or not.
#' @param type A `character()` for the type of message: 'error', 'warning', etc..
#'
#' @examples
#' if (interactive()) {
#'     shiny::runApp(mod_SweetAlert("my title", "my message"))
#' }
#'
#' @name mod_sweetAlert
#'
#' @return A shiny App
#'
NULL




#' @export
#' @rdname mod_sweetAlert
mod_SweetAlert_ui <- function(id) {}


#' @importFrom shiny moduleServer p icon
#'
#' @export
#' @rdname mod_sweetAlert
#'
mod_SweetAlert_server <- function(
        id,
        title = NULL,
        text = NULL,
        showClipBtn = TRUE,
        type = "error") {
    shiny::moduleServer(
        id,
        function(input, output, session) {
          pkgs.require(c('rclipboard', 'shinyWidgets'))
            shinyWidgets::sendSweetAlert(
                session = session,
                title = NULL,
                text = tags$div(
                    style = "display:inline-block; vertical-align: top;",
                    p(text),
                    if (showClipBtn) {
                        rclipboard::rclipButton(
                            inputId = "clipbtn",
                            label = "",
                            clipText = text,
                            icon = icon("copy"),
                            class = actionBtnClass
                        )
                    }
                ),
                type = type, # success, info, question, error,
                danger_mode = FALSE,
                closeOnClickOutside = TRUE,
                showCloseButton = FALSE
            )
        }
    )
}




#' @export
#' @rdname mod_sweetAlert
#'
mod_SweetAlert <- function(title, text, type = "warning") {
    ui <- fluidPage(
        # actionButton('test', 'Test')
    )

    server <- function(input, output) {
        # observeEvent(input$test, {
        mod_SweetAlert_server("test",
            title = title,
            text = text,
            showClipBtn = FALSE,
            type = type
        )
        # })
    }

    app <- shinyApp(ui, server)
}
