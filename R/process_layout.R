#' @export
process_layout <- function(ns, sidebar, content){

  # tagList(
  #   tags$style(type = "text/css",
  #     paste0(
  #       "#", ns("myprocesscontent"), " {padding-top: 10px; padding-left: 250px; height: 100%; width: 100%; background-color: orange; } 
  #      #", ns('myprocesssidebar'), " { padding-top: 85px; float: left; width: 250px; height: 100%; background-color: lightblue; }")
  #   ),
  #   
  #   div(id = ns("myprocesssidebar"), sidebar),
  #   div(id = ns("myprocesscontent"), content)
  #   )

  
  splitLayout(
    cellWidths = c("250px", "100%"),
    
    div(id = "div1",
      style = "background-color:orange; height: 100vh; padding-top: 85px; ",
      sidebar
    ),
    div(style = "background-color:green; height: 100vh;",
      content
    )
  )
}