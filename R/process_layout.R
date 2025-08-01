#' @export
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