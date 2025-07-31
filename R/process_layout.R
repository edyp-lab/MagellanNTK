#' @export
process_layout <- function(ns, sidebar, content){
  
  div(
    div(
      sidebar
    ),

    absolutePanel(
      style = "position: absolute; background-color: yellow;}",
      top = 76,
      left = 255,
      div(
        content
      )
    )
  )
}