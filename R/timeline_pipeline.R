#' @title Shiny module for the pipeline timeline
#'
#' @description Define the appearance of the pipeline timeline.
#'
#' @param id A `character()` as the id of the Shiny module
#' @param config An instance of the class `Config`
#' @param status A boolean which indicates whether the current status of the
#' pipeline
#' @param position An integer which reflects the current position of the cursor
#' within the steps.
#' @param enabled A vector of booleans with the same length as the number of
#' steps (See the slot steps in the config object). Each element indicates if
#' the corresponding step is enabled (TRUE) or (DISABLED)
#'
#' @return A shiny App
#'
#' @name timelines
#'
#' @examples
#' if (interactive()) {
#'   config <- Config(
#'     mode = "pipeline",
#'     fullname = "PipelineDemo",
#'     steps = c("DataGeneration", "Preprocessing", "Clustering"),
#'     mandatory = c(TRUE, FALSE, FALSE)
#'   )
#'   status <- reactive({
#'     c(1, 1, -1, 1, 0)
#'   })
#'   pos <- reactive({
#'     4
#'   })
#'   enabled <- reactive({
#'     c(0, 0, 0, 0, 1)
#'   })
#'   shiny::runApp(timeline_pipeline(config, status, pos, enabled))
#' }
#'
NULL

#' @rdname timelines
#'
#' @export
#'
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show disabled inlineCSS extendShinyjs
#'
timeline_pipeline_ui <- function(id) {
  ns <- NS(id)
  fpath <- system.file("www/sass", "pipeline_timeline.sass",
    package = "MagellanNTK"
  )
  tagList(
    shinyjs::useShinyjs(),
    shinyjs::inlineCSS(sass::sass(sass::sass_file(fpath))),
    uiOutput(ns("show_pipeline_TL"))
  )
}

#' @rdname timelines
#'
#' @export
#'
timeline_pipeline_server <- function(id,
                                     config,
                                     status,
                                     position,
                                     enabled) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    UpdateTags <- reactive({
      req(config@steps != "")
      tl_status <- rep("undone", length(config@steps))
      tl_status[which(status() == stepStatus$VALIDATED)] <- "completed"
      tl_status[which(status() == stepStatus$SKIPPED)] <- "skipped"

      for (i in seq_along(tl_status)) {
        tl_status[i] <- paste(
          tl_status[i],
          if (enabled()[i]) "enabled" else "disabled",
          if (config@mandatory[i]) "mandatory"
        )
      }

      tl_status[position()] <- paste(tl_status[position()], "active")

      return(tl_status)
    })

    output$show_pipeline_TL <- renderUI({
      req(config@steps != "")

      tags$div(
        class = "pipeline-timeline",
        lapply(seq_along(config@steps), function(i) {
          step_class <- paste("li", UpdateTags()[i])
          box_tags <- NULL

          tags$li(
            class = step_class,
            tags$div(
              class = "timestamp status",
              tags$h4(config@steps[i])
            ),
            tags$div(class = "boxes", box_tags)
          )
        })
      )
    })
  })
}

#' @rdname timelines
#'
#' @export
#'
timeline_pipeline <- function(
  config,
  status,
  position,
  enabled
) {
  ui <- fluidPage(
    timeline_pipeline_ui("myTimeline")
  )

  server <- function(input, output, session) {
    timeline_pipeline_server(
      "myTimeline",
      config,
      status,
      position,
      enabled
    )
  }

  app <- shiny::shinyApp(ui, server)
}
