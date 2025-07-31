#' @export
process_layout <- function(ns, sidebar, content){
  
  #div(
  # tags$style(type = "text/css",
  #   paste0(
  #     "#", ns("myprocesscontent"), 
  #     " {padding-top: ", default.layout$top_process_content, "px; ",
  #     #"padding-left: ", default.layout$left_process_content, "px; ",
  #     "height: 100%; ",
  #     "width: 300px; ",
  #     "background-color: ", default.layout$bgcolor_process_content, "; }",
  #    ", #", ns('myprocesstimeline'),
  #    "{ padding-top: ", default.layout$top_process_timeline, "px; ",
  #    "width: ", default.layout$width_process_timeline, "px; ",
  #    "height: 100%;",
  #     "background-color: ", default.layout$bgcolor_process_timeline, "; ",
  #    "}")
  # ),
  
  # div(
  #   style = "background-color: lightblue; width: 200px;",
  #   sidebar
  # ),
  #   div(
  #     style = "background-color: yellow; margin-left: 200px;",
  #     content
  #     )
  # )
  # tagList(
  #   absolutePanel(
  #     top = 400,
  #     left = 400, 
  #     # style = " background-color: orange; width: 200px; 
  #     #   height: 100vh; ",
  #     p('tututu')
  #   ),
  # splitLayout(
  #   cellWidths = c('200px'),
  # 
  #   div(id = "mysidebar",
  #     style = " background-color: lightblue; ",
  #     sidebar
  #   ),
  #   div(id = "mycontent",
  #     #style = "background-color:red; height: 100%; ",
  #     style = " background-color: yellow;",
  #     content
  #   )
  # )
  # )
  # 
  div(
    div(
      #style = "display: flex;",
      #style = "padding-top: 75px; padding-left: 300px; width: 100%;",
      sidebar
    ),

    absolutePanel(
      style = "position: absolute; background-color: yellow;}",
      top = 76,
      left = 260,
      #width = '100%',
      #height = '100%',
      #draggable = TRUE,
      #div(
      #  id = ns("myprocesscontent"),
      div(
        #style = "padding-top: 75px; padding-left: 300px; width: 100%;",
        p('totottototot')
      )
    )
    
    
  )
  
  
  
}