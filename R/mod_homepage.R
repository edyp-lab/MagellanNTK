#' @title   mod_homepage_ui and mod_homepage_server
#' @description  A shiny Module.
#'
#' @param id A `character()` as the id of the Shiny module
#' @param mdfile xxx
#' @param dataset xxx
#'
#' @name mod_homepage
#'
#' @examples
#' if (interactive()) {
#'     shiny::runApp(mod_homepage())
#' }
#'
#' @return NA
#'
NULL


#' @rdname mod_homepage
#' @export
#' @importFrom shiny NS tagList
mod_homepage_ui <- function(id) {
    ns <- NS(id)
    tagList(
        insert_md_ui(ns("md_file")),
      uiOutput(ns('infos_dataset'))
    )
}



#' @rdname mod_homepage
#' @export
mod_homepage_server <- function(
        id,
        mdfile = file.path(system.file("app/md",
            package = "MagellanNTK"
        ), "Presentation.Rmd"),
  dataset = reactive({NULL})
  ) {
    # mdfile <- file.path(system.file('app/md',
    #   package = 'MagellanNTK'),'Presentation.Rmd')


    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        if (file.exists(mdfile)) {
            .mdfile <- mdfile
        } else {
            .mdfile <- file.path(system.file("app/md",
                package = "MagellanNTK"
            ), "404.Rmd")
        }

        insert_md_server("md_file", normalizePath(.mdfile))
        
        output$infos_dataset <- renderUI({
          req(dataset())
          do.call(
            eval(parse(text = paste0(session$userData$funcs$infos_dataset, "_server"))),
            list(
              id = "eda1",
              dataIn = reactive({dataset()})
            )
          )
          
          do.call(
            eval(parse(text = paste0(session$userData$funcs$infos_dataset, "_ui"))),
                      list(id = ns("eda1"))
                    )
        })
    })
}


#' @export
#' @rdname mod_homepage
#' @importFrom shiny fluidPage shinyApp
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
