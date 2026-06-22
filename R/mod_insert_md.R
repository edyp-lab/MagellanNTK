#' @title   insert_md_ui and insert_md_server
#'
#' @description  A shiny Module.
#'
#' @param id A `character()` as the id of the Shiny module
#' @param url The path to the Rmd file to display. It can be a path
#' to a file on the computer or a link to a file over internet.
#'
#' @return A shiny App
#'
#' @name mod_insert_md
#'
#' @examples
#' if (interactive()) {
#'   base <- system.file("www/md", package = "MagellanNTK")
#'   url <- file.path(base, "Presentation.Rmd")
#'   shiny::runApp(insert_md(url))
#' }
#'
NULL

#' @rdname mod_insert_md
#'
#' @importFrom shiny NS tagList uiOutput htmlOutput observeEvent tagList uiOutput htmlOutput actionLink req includeMarkdown p
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show disabled inlineCSS extendShinyjs
#' @importFrom utils browseURL
#' @import markdown
#'
#' @export
#'
insert_md_ui <- function(id) {
  ns <- NS(id)
  tagList(
    htmlOutput(ns("insertMD"))
  )
}

#' @rdname mod_insert_md
#'
#' @export
#'
insert_md_server <- function(id,
                             url) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$insertMD <- renderUI({
      tryCatch(
        {
          includeMarkdown(readLines(url))
        },
        warning = function(w) {
          tags$p("URL not found<br>", conditionMessage(w))
        }, error = function(e) {
          shinyjs::info(paste("URL not found:", conditionMessage(e), sep = " "))
        }, finally = {
          # cleanup-code
        }
      )
    })
  })
}

#' @rdname mod_insert_md
#'
#' @importFrom shiny shinyApp fluidPage
#'
#' @export
#'
insert_md <- function(url) {
  ui <- fluidPage(
    insert_md_ui("tree")
  )

  server <- function(input, output) {
    insert_md_server("tree", url)
  }

  app <- shinyApp(ui, server)
}
