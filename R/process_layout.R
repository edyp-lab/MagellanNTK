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
#' @importFrom shiny NS tagList
#' @importFrom sass sass sass_file
#' @return NA
#' @export
#'
process_layout <- function(ns, sidebar, content){
  #shinybrowser::detect()
  div(
    div(
      sidebar
    ),

    absolutePanel(
      style = paste0(
        "position: absolute; ",
        "width: ", default.layout$width_process_content, ";}"),
      top = default.layout$top_process_content,
      left = default.layout$left_process_content,
      content
    )
  )
}