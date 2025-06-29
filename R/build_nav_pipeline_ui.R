#' @rdname Build_nav_X_ui
#' 
#' @export
#'
Build_nav_pipeline_ui <- function(ns) {
     wellPanel(
    fluidRow(
      style = "display: flex; align-items: top; justify-content: center;",
      column(width = 1, shinyjs::disabled(
        actionButton(ns("prevBtn"),
          tl_h_prev_icon,
          class = PrevNextBtnClass,
          style = btn_css_style
        )
      )),
      column(width = 1,
        mod_modalDialog_ui(id = ns("rstBtn"))
        ),
      column(width = 1,
        actionButton(ns("nextBtn"),
          tl_h_next_icon,
          class = PrevNextBtnClass,
          style = btn_css_style
        )
      ),
      column(width = 9, timeline_pipeline_ui(ns("timeline_pipeline")))
    ),
    div(
      id = ns("Screens"),
      uiOutput(ns("SkippedInfoPanel")),
      uiOutput(ns("EncapsulateScreens_ui"))
    )
  )
  
}
