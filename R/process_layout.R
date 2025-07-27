#' @export
process_layout <- function(ns, sidebar, content){

div(
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

  absolutePanel(
    id = ns("myprocesstimeline"),
    style = paste0(
      "position: fixed; ",
      "padding-top: ", default.layout$top_process_timeline, "px; ",
      "width: ", default.layout$width_process_timeline, "px; ",
      "height: 100%;",
      "background-color: ", default.layout$bgcolor_process_timeline, "; ",
      "z-index: 99999 !important;",
      "}"),
    draggable = TRUE,
    sidebar
  ),

    div(
      id = ns("myprocesscontent"),
      style = paste0(
        "padding-top: ", default.layout$top_process_content, "px; ",
        "padding-left: ", default.layout$width_process_timeline, "px; ",
        #"height: 100%; ",
        #"width: 300px; ",
        "background-color: ", default.layout$bgcolor_process_content, "; }"),
      draggable = TRUE,
      content)
    )

  
  # splitLayout(
  #   cellWidths = c(
  #     default.layout$width_process_timeline, 
  #     default.layout$width_process_content
  #     ),
  # 
  #   div(id = "div1",
  #     style = paste0(
  #       "padding-top: ", default.layout$top_process_timeline, "px; ",
  #       "padding-left: ", default.layout$left_process_timeline, "px; ",
  #       "height: 100vh; ",
  #       " background-color: ", default.layout$bgcolor_process_timeline, ";"
  #       ),
  #       #style = paste("background-color:orange; height: 100vh; padding-top: 150px; "),
  #     sidebar
  #   ),
  #   div(id = "div2",
  #     #style = "background-color:red; height: 100%; ",
  #     style = paste0("padding-top: ", default.layout$top_process_content, "px; ",
  #     " height: 100vh; ",
  #     " background-color: ", default.layout$bgcolor_process_content, ";"),
  #     content
  #   )
  # )
}