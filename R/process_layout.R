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
      top = default.layout$width_process_content,
      left = default.layout$width_process_content,
      content
    )
  )
}