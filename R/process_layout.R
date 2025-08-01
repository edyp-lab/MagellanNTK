#' @export
process_layout <- function(ns, sidebar, content){
  #shinybrowser::detect()
  div(
    div(
      sidebar
    ),

    absolutePanel(
      style = "position: absolute; width: 100vh;}",
      top = 76,
      left = 255,
      content
    )
  )
}