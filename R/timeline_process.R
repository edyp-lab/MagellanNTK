#' @title Timelines
#'
#' @description xxx
#'
#' @param id xxx
#' @param config xxx
#' @param status xxx,
#' @param position xxx
#' @param enabled xxx
#'
#' @name timelines
#'
#' @importFrom shiny NS tagList
#' @importFrom sass sass sass_file
#' @return NA
#'
#' @examples
#' NULL
#'
NULL





#' @export
#' @rdname timelines
#' 
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#'
timeline_process_ui <- function(id) {
    ns <- NS(id)
    fpath <- system.file("www/sass", "process_timeline.sass", package = "MagellanNTK")

    # inlineCSS(sass(sass_file("www/sass/process_timeline.sass"))),


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
        status,
        position,
        enabled) {
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
            # tl_status[which(config@mandatory)] <- "mandatory"
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
            # .size <-"25px"
            # .iconsize <- "25px"

            tags$div(
                class = "process-timeline",
                lapply(seq_len(length(config@steps)), function(i) {
                    step_class <- paste("li", UpdateTags()[i])

                    tags$div(
                        class = step_class,
                        tags$div(
                            class = "icon",
                            tags$img(src = icons[i], height = "25px"),
                            # style = paste0("height: ", .size, "; width: ", .size, ";")
                            style = paste0("height: 30px; width: 30px;")
                        ),
                        tags$div(class = "label", config@steps[i])
                    )
                })
            )
        })
    })
}
