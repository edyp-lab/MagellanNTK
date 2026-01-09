#' @title Timelines
#'
#' @description xxx
#'
#' @param session The R session parameter
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
process_layout <- function(session, ns, sidebar, content) {
  
  switch(session$userData$wf_mode,
    process = process_layout_process(session, ns, sidebar, content),
    pipeline = process_layout_pipeline(session, ns, sidebar, content)
  )
}


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
process_layout_process <- function(session, ns, sidebar, content) {
  
  div(
        div(style = paste0(
          "background-color: ", MagellanNTK::default.theme(session$userData$usermod)$bgcolor_process_sidebar, ";",
          "padding-left: ", default.layout$left_process_timeline, "px;",
          "padding-bottom: ", default.layout$bottom_process_timeline, "px;",
          "padding-top: ", default.layout$top_process_timeline, "px;"),
          sidebar
        ),
        shiny::absolutePanel(
          style = paste0(
            "position: absolute; ",
            "width: ", default.layout$width_process_content_standalone, ";",
            # "padding-top: ", default.layout$top_process_content_standalone, "px;",
            "background-color: ", default.theme(session$userData$usermod)$bgcolor_process_content, ";}"
          ),
          top = default.layout$top_process_content_standalone,
          left = default.layout$left_process_content_standalone,
          content
        )
      )
}


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
process_layout_pipeline <- function(session, ns, sidebar, content) {
  
  div(
        div(style = paste0(
          "background-color: ", default.theme(session$userData$usermod)$bgcolor_process_sidebar, ";",
          "padding-left: ", default.layout$left_process_timeline, "px;",
          "padding-bottom: ", default.layout$bottom_process_timeline, "px;",
          "padding-top: ", default.layout$top_process_timeline, "px;"),
          sidebar
        ),
        shiny::absolutePanel(
          style = paste0(
            "position: absolute; ",
            "width: ", default.layout$width_process_content, ";",
            "padding-top: ", default.layout$top_process_content, "px;",
            "background-color: ", default.theme(session$userData$usermod)$bgcolor_process_content, ";}"
          ),
          top = default.layout$top_process_content,
          left = default.layout$left_process_content,
          content
        )
      )
}