#' @export
process_layout <- function(sidebar, content){
  
  div(
  style = "position: relative; z-index: 0;",
    absolutePanel(
      top = MagellanNTK::default.layout$top_panel,
      left = MagellanNTK::default.layout$left_panel,
      width = MagellanNTK::default.layout$width_panel,
      height = "100%",
      fixed = TRUE,
      #style = "padding:15px; background:lightblue;",
      div(
        style = "z-index: 0;",
        tagList(
          content
        )
      )
    ),
    absolutePanel(
    top = MagellanNTK::default.layout$top_sidebar,
    left = MagellanNTK::default.layout$left_sidebar,
    width = MagellanNTK::default.layout$width_sidebar,
    height = "100%",
    fixed = TRUE,
    style = paste0("background:", default.layout$bgcolor_sidebar, ";"),
    div(
      style = "margin-top:55px;",
      sidebar
    )
  )
  
  
)

}