#' @export
process_layout <- function(ns, sidebar, content){

  tagList(
    tags$style(type = "text/css",
      paste0(
        "#", ns("myprocesscontent"), " {padding-top: 00px; padding-left: 200px; height: 100vh; width: 100%; background-color: orange; } 
       #", ns('myprocesssidebar'), " { padding-top: 75px; padding-left: -20px; float: left; width: 250px; height: 100vh; background-color: lightblue; }")
    ),
    
    div(id = ns("myprocesssidebar"), sidebar),
    div(id = ns("myprocesscontent"), content)
    )

}