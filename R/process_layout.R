#' @export
process_layout <- function(ns, sidebar, content){
  
  window_height <- htmlwidgets::JS('window.innerHeight')
  window_width <- Jhtmlwidgets::S('window.innerWidth')
  
  div(
    div(
      sidebar
    ),

    absolutePanel(
      style = "position: absolute; }",
      top = 76,
      left = 255,
      width = window_width - 255,
      div(
        content
      )
    )
  )
}