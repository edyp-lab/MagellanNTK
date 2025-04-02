library(shinydashboard)
library(shinyjs)



#' #' The application User-Interface
#' #' 
#' #' @param request Internal parameter for `{shiny}`. 
#' #'     DO NOT REMOVE.
#' #' @importFrom shiny shinyUI tagList 
#' #' @import shinydashboardPlus
#' #' @import shinydashboard
#' #' @importFrom shinyjs useShinyjs extendShinyjs
#' #' @noRd
#' #' @export
#' #' 
#' ui_MagellanNTK <- shiny::shinyUI(
#'   
#'     shiny::tagList(
#'       tags$head(
#'         tags$link(rel = "stylesheet", type = "text/css", href = "www/css/styles.css")
#'       ),
#'         #launchGA(),
#'         #shinyjs::useShinyjs(),
#'         #shinyjs::extendShinyjs(
#'         #  text = "shinyjs.resetProstar = function() {history.go(0)}",
#'          #   functions = c("resetProstar")),
#'         
#'         #shiny::titlePanel("", windowTitle = "Prostar"),
#'           mainapp_ui('mainapp_module')
#'     )
#' )

