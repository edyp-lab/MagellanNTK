#' @title Shiny module for the process timeline
#' @param id A `character()` as the id of the Shiny module
#' @param config An instance of the class `Config`
#' @param status A boolean which indicates whether the current status of the 
#' process ,
#' @param position An integer which reflects the current position of the cursor
#' within the steps.
#' @param enabled A vector of booleans with the same length as the number of steps (
#' See the slot steps in the config object). Each element indicates if the
#' corresponding step is enabled (TRUE) or (DISABLED)
#'
#' @name timelines
#'
#' @importFrom shiny NS tagList
#' @importFrom sass sass sass_file
#' 
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#' 
#' 
#' @return A shiny app
#'
#' @examples 
#' if(interactive()){
#' config <- Config(
#'     mode = "process",
#'     fullname = "PipelineDemo_Preprocessing",
#'     steps = c('Filtering', 'Normalization'),
#'     mandatory = c(FALSE, TRUE)
#' )
#' status <- reactive({c(1, 1, 0, 0)})
#' pos <- reactive({2})
#' enabled <- reactive({c(0, 0, 1, 1)})
#' shiny::runApp(timeline_process(config, status, pos, enabled))
#' }
#' 
#' 
#' if(interactive()){
#' config <- Config(
#'     mode = "pipeline",
#'     fullname = "PipelineDemo",
#'     steps = c('DataGeneration', 'Preprocessing', 'Clustering'),
#'     mandatory = c(TRUE, FALSE, FALSE)
#' )
#' status <- reactive({c(1, 1, -1, 1, 0)})
#' pos <- reactive({4})
#' enabled <- reactive({c(0, 0, 0, 0, 1)})
#' shiny::runApp(timeline_pipeline(config, status, pos, enabled))
#' }
#' 
NULL





#' @export
#' @rdname timelines
#'
timeline_process_ui <- function(id) {
    ns <- NS(id)
    fpath <- system.file("www/sass", "process_timeline.sass", package = "MagellanNTK")

    tagList(
        shinyjs::useShinyjs(),
        tags$div(
            shinyjs::inlineCSS(sass::sass(sass::sass_file(fpath))),
            uiOutput(ns("show_process_TL"))
        )
    )
}


#' @rdname timelines
#' @export
#'
timeline_process_server <- function(
        id,
        config,
        status = reactive({NULL}),
        position = reactive({1}),
        enabled = reactive({NULL})) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        addResourcePath("www", system.file("www", package = "MagellanNTK"))


        icons <- lapply(config@steps, function(step) {
            if (step == "Description" | step == "Save") {
                filename <- tolower(step)
                filename <- gsub(" ", "_", filename)
            } else {
                filename <- "step_icon"
            }

            paste0("www/images/", filename, ".png")
        })
        icons <- unlist(icons)



        UpdateTags <- reactive({
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

            pos <- position()
            tl_status[pos] <- paste(tl_status[pos], "active")
            return(tl_status)
        })




        output$show_process_TL <- renderUI({
            
            tags$div(
                class = "process-timeline",
                lapply(seq_len(length(config@steps)), function(i) {
                    step_class <- paste("li", UpdateTags()[i])

                    tags$div(
                        class = step_class,
                        tags$div(
                            class = "icon",
                            tags$img(src = icons[i], height = "25px"),
                            style = paste0("height: 30px; width: 30px;")
                        ),
                        tags$div(class = "label texteSurUneLigne", config@steps[i])
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
timeline_process <- function(config,
  status,
  position,
  enabled) {
    ui <- fluidPage(
      timeline_process_ui("myTimeline")
    )
    
    server <- function(input, output, session) {
      timeline_process_server("myTimeline",
        config,
        status,
        position,
        enabled
      )
    }
    
    app <- shiny::shinyApp(ui, server)
  }
