#' @title   mod_release_notes_ui and mod_release_notes_server
#'
#' @description  A shiny Module.
#'
#' @param id A `character()` as the id of the Shiny module
#' @param URL_releaseNotes The path to the Rmd file to display. It can be a path
#' to a file on the computer or a link to a file over internet.
#'
#' @return A shiny App
#'
#' @name mod_release_notes
#'
#' @examples
#' if (interactive()) {
#'   url <- "http://www.prostar-proteomics.org/md/versionNotes.md"
#'   shiny::runApp(release_notes(url))
#'
#'   local.url <- system.file("/workflow/PipelineDemo/md/links.Rmd",
#'     package = "MagellanNTK"
#'   )
#'   shiny::runApp(release_notes(local.url))
#' }
#'
NULL

#' @rdname mod_release_notes
#'
#' @importFrom shiny NS tagList
#'
#' @export
#'
mod_release_notes_ui <- function(id) {
  ns <- NS(id)

  tabsetPanel(
    tabPanel(
      id = "Current release",
      insert_md_ui(ns("versionNotes_MD"))
    )
  )
}

#' @rdname mod_release_notes
#'
#' @export
#'
mod_release_notes_server <- function(id, URL_releaseNotes) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    insert_md_server("versionNotes_MD", URL_releaseNotes)
  })
}

#' @rdname mod_release_notes
#'
#' @export
#'
release_notes <- function(URL_releaseNotes) {
  ui <- mod_release_notes_ui("notes")

  server <- function(input, output, session) {
    mod_release_notes_server("notes",
      URL_releaseNotes = URL_releaseNotes
    )
  }

  app <- shinyApp(ui = ui, server = server)
}
