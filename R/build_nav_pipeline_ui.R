#' @rdname Build_nav_X_ui
#' 
#' @export
#'
Build_nav_pipeline_ui <- function(ns) {
  
  # .width <- 250
  # 
  # fluidPage(
  #   absolutePanel(id = "pipeline_timeline",
  #     
  #     shinyjs::disabled(
  #         actionButton(ns("prevBtn"),
  #           tl_h_prev_icon,
  #           class = PrevNextBtnClass,
  #           style = "font-size:60%"
  #         ),
  #         actionButton(ns("nextBtn"),
  #           tl_h_next_icon,
  #           class = PrevNextBtnClass,
  #           style = "font-size:60%"
  #         ),
  #         mod_modalDialog_ui(id = ns("rstBtn"))
  #       ),
  #       actionButton(ns("nextBtn"),
  #           tl_h_next_icon,
  #           class = PrevNextBtnClass,
  #           style = "font-size:60%"
  #         ),
  #       timeline_pipeline_ui(ns("timeline_pipeline"))
  #      ,
  #     fixed = TRUE,
  #     top = 0,
  #     left = .width,
  #     width = '100%',
  #     height = '100',
  #     style = "background-color: yellow;
  #   opacity: 0.85;
  #   padding: 0px 0px 200px 0px;
  #   margin: 0px 0px 0px 0px;
  #   padding-bottom: 2mm;
  #   padding-top: 1mm;",
  #     
  #   )
    # absolutePanel(id = "sssss",
    #   div(
    #     id = ns("Screens"),
    #     uiOutput(ns("SkippedInfoPanel")),
    #     uiOutput(ns("EncapsulateScreens_ui"))
    #   ),
    #   fixed = TRUE,
    #   top = 100,
    #   left = 0,
    #   width = .width,
    #   height = '50%',
    #   style = "background-color: white;
    # opacity: 0.85;
    # padding: 0px 0px 0px 0px;
    # margin: 0px 0px 0px 0px;
    # padding-bottom: 2mm;
    # padding-top: 1mm;",
    #   
    # )
  #)
  # 
  # 
  # bslib::page_sidebar(
  #   #  ui <- layout_sidebar(
  #   #includeCSS("C:/Users/sw175264/Desktop/Evolutions Prostar/Cyril/Maquette/www/theme_base2.css"),
  #   tags$style(".bslib-sidebar-layout .collapse-toggle{display:true;}"),
  #   
  #   title = NULL,
  #   #windowTitle = "Movies",
  #   # sidebar = sidebar(
  #   #   "Some",
  #   #   width = 50,
  #   #   bg = 'orange'
  #   # ),
  #   
  #   
  #   sidebar = bslib::sidebar(
  #     fluidRow(
  #       style = "display: flex; align-items: top; justify-content: center;",
  #       column(width = 1, shinyjs::disabled(
  #         actionButton(ns("prevBtn"),
  #           tl_h_prev_icon,
  #           class = PrevNextBtnClass,
  #           style = "font-size:60%"
  #         )
  #       )),
  #       column(width = 1,
  #         mod_modalDialog_ui(id = ns("rstBtn"))
  #       ),
  #       column(width = 9, uiOutput(ns("show_TL"))),
  #       column(width = 1,
  #         actionButton(ns("nextBtn"),
  #           tl_h_next_icon,
  #           class = PrevNextBtnClass,
  #           style = "font-size:60%"
  #         )
  #       )
  #     ),
  #     width = 510,
  #     position = "left",
  #     bg='lightblue',
  #     padding = c(7, 5), # 1ere valeur : padding vertical, 2eme : horizontal
  #     style = "p1"
  #   ),
  #   div(
  #     id = ns("Screens"),
  #     uiOutput(ns("SkippedInfoPanel")),
  #     uiOutput(ns("EncapsulateScreens_ui"))
  #   )
  # )
  
  
  
  
   wellPanel(
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
      column(width = 1,
        actionButton(ns("nextBtn"),
          tl_h_next_icon,
          class = PrevNextBtnClass,
          style = "font-size:60%"
        )
      ),
      column(width = 9, uiOutput(ns("show_TL")))
    ),
    div(
      id = ns("Screens"),
      uiOutput(ns("SkippedInfoPanel")),
      uiOutput(ns("EncapsulateScreens_ui"))
    )
  )
  
  # bslib::layout_sidebar(
  #   sidebar = bslib::sidebar(
  #     fluidRow(
  #       style = "display: flex; align-items: top; justify-content: center;",
  #       column(width = 1, shinyjs::disabled(
  #         actionButton(ns("prevBtn"),
  #           tl_h_prev_icon,
  #           class = PrevNextBtnClass,
  #           style = "font-size:60%"
  #         )
  #       )),
  #       column(width = 1,
  #         mod_modalDialog_ui(id = ns("rstBtn"))
  #       ),
  #       column(width = 9, uiOutput(ns("show_TL"))),
  #       column(width = 1,
  #         actionButton(ns("nextBtn"),
  #           tl_h_next_icon,
  #           class = PrevNextBtnClass,
  #           style = "font-size:60%"
  #         )
  #       )
  #     ),
  #     width = 510,
  #     position = "left",
  #     bg='lightblue',
  #     padding = c(7, 5), # 1ere valeur : padding vertical, 2eme : horizontal
  #     style = "p1"
  #   ),
  #   div(
  #     id = ns("Screens"),
  #     uiOutput(ns("SkippedInfoPanel")),
  #     uiOutput(ns("EncapsulateScreens_ui"))
  #   )
  # )
  # 
  # )
  
  
  # 
  # 
  # 
  # fluidPage(
  #   #includeCSS("www/theme_base.css"),
  #   
  #   bslib::layout_sidebar(
  #     sidebar = bslib::sidebar(
  #       h3('add frise'),
  #       
  #       
  #       fluidRow(
  #         style = "display: flex; align-items: top; justify-content: center;",
  #         column(width = 1, shinyjs::disabled(
  #           actionButton(ns("prevBtn"),
  #             tl_h_prev_icon,
  #             class = PrevNextBtnClass,
  #             style = "font-size:60%"
  #           )
  #         )),
  #         column(width = 1,
  #           mod_modalDialog_ui(id = ns("rstBtn"))
  #         ),
  #         column(width = 9, uiOutput(ns("show_TL"))),
  #         column(width = 1,
  #           actionButton(ns("nextBtn"),
  #             tl_h_next_icon,
  #             class = PrevNextBtnClass,
  #             style = "font-size:60%"
  #           )
  #         )
  #       ),
  #       
  #       
  #       hr(style = "border-top: 3px solid #000000;"),
  #       uiOutput(ns("Step1_btn_validate_ui")),
  #       hr(style = "border-top: 3px solid #000000;"),
  #       fluidRow(
  #         inputPanel(p("add widgets"))
  #       ),
  #       width = 510,
  #       position = "left",
  #       #bg='lightblue',
  #       padding = c(7, 5), # 1ere valeur : padding vertical, 2eme : horizontal
  #       style = "p1"
  #     ),
  #     div(
  #       id = ns("Screens"),
  #       uiOutput(ns("SkippedInfoPanel")),
  #       uiOutput(ns("EncapsulateScreens_ui"))
  #     )
  #   )
  # )
}
