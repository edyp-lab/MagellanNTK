#' @export
process_layout <- function(ns, sidebar, content){

  tagList(
    tags$style(type = "text/css",
      paste0(
        "#", ns("myprocesscontent"), " {padding-top: 10px; padding-left: 250px; height: 100%; width: 100%; background-color: orange; }
       #", ns('myprocesssidebar'), " { padding-top: 85px; float: left; width: 250px; height: 100%; background-color: lightblue; }")
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