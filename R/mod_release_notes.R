#' @title   mod_release_notes_ui and mod_release_notes_server
#' @description  A shiny Module.
#'
#' @param id A `character()` as the id of the Shiny module
#' @param URL_releaseNotes xxx
#'
#' @name mod_release_notes
#'
#' @examples
#' if (interactive()) {
#'     url <- "http://www.prostar-proteomics.org/md/versionNotes.md"
#'     shiny::runApp(release_notes(url))
#' }
#'
#' @return NA
#'
NULL



#' @rdname mod_release_notes
#' @export
#' @importFrom shiny NS tagList
mod_release_notes_ui <- function(id) {
    ns <- NS(id)

    tabsetPanel(
        tabPanel(
            id = "Current release",
                insert_md_ui(ns("versionNotes_MD"))
            )
            # shinyBS::bsCollapsePanel("Former releases",
            #                          insert_md_ui(ns("formerReleases_MD")), style = "info")
        )
}



#' @rdname mod_release_notes
#' @export
#'
mod_release_notes_server <- function(id, URL_releaseNotes) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns
        insert_md_server("versionNotes_MD", URL_releaseNotes)
        # insert_md_server("formerReleases_MD", url_formerReleases)
    })
}


#' @rdname mod_release_notes
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
