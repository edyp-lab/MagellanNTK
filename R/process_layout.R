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
  
  splitLayout(
    cellWidths = c('200px', '100%'),

    div(id = "mysidebar",
      style = " background-color: lightblue; width: 200px; padding-top: 70px;",
        #style = paste("background-color:orange; height: 100vh; padding-top: 150px; "),
      sidebar
    ),
    div(id = "mycontent",
      #style = "background-color:red; height: 100%; ",
      style = " background-color: yellow; width: 300px;",
      content
    )
  )

  
#   absolutePanel(
#     #id = ns("myprocesstimeline"),
#      style = paste0(
#        "position: relative; ",
#     #   padding-top: ", default.layout$top_process_timeline, "px; ",
#     #   width: ", default.layout$width_process_timeline, "; ",
#     #   height: ", default.layout$height_process_timeline, ";",
#        "background-color: yellow; margin-left: 250px; margin-top: 150px;",
#     #   #"z-index: 999;",
#        "}"),
#     top = -248,
#     left = -47,
#     #width = '100%',
#     #height = '100%',
#     draggable = TRUE,
#     div(
#     #  id = ns("myprocesscontent"),
#       content
#     )
#   )
# )
  # absolutePanel(
  #   #id = ns("myprocesstimeline"),
  #    style = paste0(
  #   #   "position: fixed; ",
  #   #   padding-top: ", default.layout$top_process_timeline, "px; ",
  #   #   width: ", default.layout$width_process_timeline, "; ",
  #   #   height: ", default.layout$height_process_timeline, ";",
  #      "background-color: ", default.layout$bgcolor_process_content, "; ",
  #   #   #"z-index: 999;",
  #      "}"),
  #   top = 200,
  #   left = default.layout$width_process_timeline,
  #   #width = '100%',
  #   #height = '100%',
  #   draggable = TRUE,
  #   #div(
  #   #  id = ns("myprocesscontent"),
  #     content
  #   #)
  # ),
  # 
  # absolutePanel(
  #   #id = ns("myprocesstimeline"),
  #   style = paste0(
  #     "position: fixed; ",
  #     #"padding-top: ", default.layout$top_process_timeline, "px; ",
  #     "width: ", default.layout$width_process_timeline, "; ",
  #     "height: ", default.layout$height_process_timeline, ";",
  #     "background-color: ", default.layout$bgcolor_process_timeline, "; ",
  #     "z-index: 999;",
  #     "}"),
  #   top = default.layout$top_process_timeline,
  #   left = default.layout$left_process_btns,
  #   draggable = TRUE,
  #   div(
  #     id = ns("myprocesstimeline"),
  #     # style = paste0(
  #     #   "padding-top: 0px; ",
  #     #   "padding-left: ", "0px",
  #     #   #"height: 100%; ",
  #     #   #"width: 300px; ",
  #     #   "background-color: ", default.layout$bgcolor_process_timeline, "; }"),
  #     sidebar
  #   )
  # )
  
  
#)

  
 
}