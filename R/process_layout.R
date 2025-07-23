#' @export
process_layout <- function(ns, sidebar, content){
  
#   div(
#     id = ns('process_layout'),
#     #style = "position: relative; ",
#     style = "z-index : -10; ",
#     
#     absolutePanel(
#       id = ns('content'),
#       top = MagellanNTK::default.layout$top_panel,
#       left = MagellanNTK::default.layout$left_panel,
#       width = MagellanNTK::default.layout$width_panel,
#       height = "100%",
#       fixed = TRUE,
#       style = "background-color : orange;",
#       div(
#         style = "",
#         tagList(
#           content
#         )
#       )
#     ),
#     absolutePanel(
#       id = ns('sidebar'),
#       top = MagellanNTK::default.layout$top_sidebar,
#       left = MagellanNTK::default.layout$left_sidebar,
#       width = MagellanNTK::default.layout$width_sidebar,
#       height = "100%",
#       fixed = TRUE,
#       style = paste0("background:", default.layout$bgcolor_sidebar, ";"),
#       div(
#         style = "margin-top:55px; z-index : -10; ",
#         sidebar
#       )
#     )
# )
  
  
  


  bslib::page_sidebar(
    tags$head(tags$style(".sidebar-content {background-color: lightblue; width: 300px;}"),
      tags$style(".shiny-input-panel {background-color: lightblue;}")
    ),
    sidebar = bslib::sidebar(
      id = ns("Description_Sidebar"),  # Add an explicit ID
      sidebar
      #position = "left",
      #padding = c(100, 0), # 1ere valeur : padding vertical, 2eme : horizontal
      #style = "background-color : lightblue;"
      ),
    content
  )

}