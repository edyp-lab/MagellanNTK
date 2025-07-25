#' @export
process_layout <- function(ns, sidebar, content){

  tagList(
    tags$style(type = "text/css",
      paste0(
        "#", ns("myprocesscontent"), " {padding-top: ",
        default.layout$top_process_panel, "px; padding-left: ",
        default.layout$left_process_panel, "px; height: 100%; width: 100%; background-color: ",
        default.layout$bgcolor_process_panel, "; }
       #", ns('myprocesssidebar'), " { padding-top: ",
        default.layout$top_process_sidebar, "x; float: left; width: ",
        default.layout$left_process_panel, "px; height: 100%;}")
    ),

    div(id = ns("myprocesssidebar"), sidebar),
    div(id = ns("myprocesscontent"), content)
    
    )

  
  # splitLayout(
  #   cellWidths = c("250px", "100%"),
  #   
  #   div(id = "div1",
  #     style = paste("background-color:orange; height: 100%; padding-top: ", default.layout$top_sidebar, "px; "),
  #     sidebar
  #   ),
  #   tagList(style = "background-color:red;",
  #     content
  #   )
  # )
}