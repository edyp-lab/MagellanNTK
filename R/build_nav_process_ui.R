#' @rdname Build_nav_X_ui
#' 
#' @export
#'
Build_nav_process_ui <- function(ns) {
  
  tagList(
    fluidRow(
      style = "display: flex; align-items: top; justify-content: center;",
      column(width = 1, shinyjs::disabled(
        actionButton(ns("prevBtn"),
          tl_h_prev_icon,
          class = PrevNextBtnClass,
          style = "font-size:60%"
        )
      )),
      column(width = 1,
        mod_modalDialog_ui(id = ns("rstBtn"))
        ),
      column(width = 9, uiOutput(ns("show_TL"))),
      column(width = 1,
        actionButton(ns("nextBtn"),
          tl_h_next_icon,
          class = PrevNextBtnClass,
          style = "font-size:60%"
        )
      )
    ),
    div(
      id = ns("Screens"),
      uiOutput(ns("SkippedInfoPanel")),
      uiOutput(ns("EncapsulateScreens_ui"))
    )
  )
}
