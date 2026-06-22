#' @title   mod_homepage_ui and mod_homepage_server
#'
#' @description  A shiny Module.
#'
#' @param id A `character()` as the id of the Shiny module
#' @param mdfile The path to the Rmd file which describes the pipeline
#' @param dataset An instance of the class `MultiAssayExperiment`
#'
#' @return A shiny App
#'
#' @name mod_homepage
#'
#' @examples
#' if (interactive()) {
#'   shiny::runApp(mod_homepage())
#' }
#'
NULL

#' @rdname mod_homepage
#' @export
#' @importFrom shiny NS tagList
mod_homepage_ui <- function(id) {
  ns <- NS(id)
  tagList(
    insert_md_ui(ns("md_file")),
    uiOutput(ns("infos_dataset"))
  )
}

#' @rdname mod_homepage
#'
#' @export
#'
mod_homepage_server <- function(id,
                                mdfile = file.path(system.file("www/md",
                                  package = "MagellanNTK"
                                ), "Presentation.Rmd"),
                                dataset = reactive({
                                  NULL
                                })) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    if (file.exists(mdfile)) {
      .mdfile <- mdfile
    } else {
      .mdfile <- file.path(system.file("www/md",
        package = "MagellanNTK"
      ), "404.Rmd")
    }

    insert_md_server("md_file", normalizePath(.mdfile))

    output$infos_dataset <- renderUI({
      req(dataset())
      parts_infos_dataset <- strsplit(session$userData$funcs$infos_dataset,
        "::",
        fixed = TRUE
      )[[1]]
      do.call(
        getExportedValue(
          parts_infos_dataset[1],
          paste0(parts_infos_dataset[2], "_server")
        ),
        list(
          id = "eda1",
          dataIn = reactive({
            dataset()
          })
        )
      )

      do.call(
        getExportedValue(
          parts_infos_dataset[1],
          paste0(parts_infos_dataset[2], "_ui")
        ),
        list(id = ns("eda1"))
      )
    })
  })
}

#' @rdname mod_homepage
#'
#' @importFrom shiny fluidPage shinyApp
#'
#' @export
#'
mod_homepage <- function() {
  ui <- fluidPage(
    mod_homepage_ui("mod_pkg")
  )

  server <- function(input, output, session) {
    mod_homepage_server("mod_pkg")
  }

  app <- shinyApp(ui, server)
}
