
#'
#' @rdname timelines
#'
#' @importFrom shiny NS tagList
#' @importFrom sass sass sass_file
#' @return NA
#' @export
#'
timeline_pipeline_ui <- function(id) {
  ns <- NS(id)
  fpath <- system.file("www/sass", "pipeline_timeline.sass", package = "MagellanNTK")
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
      req(config@steps != '')
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
      
      
      # 
      # tl_status[which(config@mandatory)] <- "mandatory"
      # tl_status[which(unlist(status()) == stepStatus$VALIDATED)] <- "completed"
      # tl_status[which(unlist(status()) == stepStatus$SKIPPED)] <- "skipped"
      # 
      # for (i in seq_len(length(enabled()))) {
      #   if (!enabled()[i]) {
      #     tl_status[i] <- paste0(tl_status[i], "Disabled")
      #   }
      # }
      # 
      # tl_status[position()] <- paste0(tl_status[position()], " active")
      # tl_status
    })
    
    output$show_pipeline_TL <- renderUI({
      req(config@steps != '')
      
      tags$div(
        class = "timeline",
        lapply(seq_along(config@steps), function(i) {
          step_class <- paste("li", UpdateTags()[i])
          
          # step_subclass_list <- UpdateSubTags()[[i]]
          box_tags <- NULL
          
          # if (length(step_subclass_list) > 0) {
          #   box_tags <- lapply(step_subclass_list, function(cls) {
          #     tags$span(class = paste("box", cls))
          #   })
          # }
          
          # print(box_tags)
          # print(step_class)
          tags$li(
            class = step_class,
            tags$div(class = "timestamp status",
              tags$h4(config@steps[i])),
            tags$div(class = "boxes", box_tags)
          )
        })
      )
      
      
      
    })
  })
}
