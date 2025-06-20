

#' @rdname Build_nav_X_ui
#' 
#' @export
#'
 Build_nav_process_ui <- function(ns){
#   
#   
#   # wellPanel(
#   # 
#   # fluidPage(
#   #   #includeCSS("www/theme_base.css"),
#   #   
#   #   bslib::layout_sidebar(
#   #     sidebar = bslib::sidebar(
#   #       column(12,
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
            #column(width = 9, uiOutput(ns("show_TL"))),
            column(width = 1,
              actionButton(ns("nextBtn"),
                tl_h_next_icon,
                class = PrevNextBtnClass,
                style = "font-size:60%"
              )
            )
          )
#   #         
#   #         hr(style = "border-top: 3px solid #000000;"),
#   #         uiOutput(ns("Normalization_btn_validate_ui")),
#   #         hr(style = "border-top: 3px solid #000000;"),
#   #         fluidRow(
#   #           inputPanel(
#   #             h2(strong("Options"))
#   #           )
#   #         )
#   #       ),
#   #       width = 310,
#   #       position = "left",
#   #       bg='lightblue',
#   #       padding = c(7, 5), # 1ere valeur : padding vertical, 2eme : horizontal
#   #       style = "p1"
#   #     ),
#   #     
#   #     div(
#   #       id = ns("Screens"),
#   #       uiOutput(ns("SkippedInfoPanel")),
#   #       uiOutput(ns("EncapsulateScreens_ui"))
#   #     )
#   #     
#   #     
#   #     #padding = c(0, 40)
#   #   )
#   # )
#   # 
#   # )
#   
#   
#   # tagList(
#   #   fluidRow(
#   #     style = "display: flex; align-items: top; justify-content: center;",
#   #     column(width = 1, shinyjs::disabled(
#   #       actionButton(ns("prevBtn"),
#   #         tl_h_prev_icon,
#   #         class = PrevNextBtnClass,
#   #         style = "font-size:60%"
#   #       )
#   #     )),
#   #     column(width = 1,mod_modalDialog_ui(id = ns("rstBtn"))),
#   #     column(width = 9, uiOutput(ns("show_TL"))),
#   #     column(width = 1,
#   #       actionButton(ns("nextBtn"),
#   #         tl_h_next_icon,
#   #         class = PrevNextBtnClass,
#   #         style = "font-size:60%"
#   #       )
#   #     )
#   #   )
#     # div(
#     #   id = ns("Screens"),
#     #   uiOutput(ns("SkippedInfoPanel")),
#     #   uiOutput(ns("EncapsulateScreens_ui"))
#     # )
#   #)
#   
}