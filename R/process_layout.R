#' @title Timelines
#'
#' @description xxx
#'
#' @param ns xxx
#' @param sidebar xxx
#' @param content xxx
#'
#' @rdname process_layout
#'
#' @import shiny
#' @importFrom sass sass sass_file
#' @return NA
#' @export
#'
process_layout <- function(ns, sidebar, content) {
    div(
        div(style = paste0(
          "background-color: ", default.layout$bgcolor_process_sidebar, ";",
          "padding-left: ", default.layout$left_process_timeline, "px;",
          "padding-bottom: ", default.layout$bottom_process_timeline, "px;",
          "padding-top: ", default.layout$top_process_timeline, "px;"s),
            sidebar
        ),
        shiny::absolutePanel(
            style = paste0(
                "position: absolute; ",
                "width: ", default.layout$width_process_content, ";",
                "background-color: ", default.layout$bgcolor_process_content, ";}"
            ),
            top = default.layout$top_process_content,
            left = default.layout$left_process_content,
            content
        )
    )
}
