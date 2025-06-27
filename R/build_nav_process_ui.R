#' @rdname Build_nav_X_ui
#' 
#' @export
#'
Build_nav_process_ui <- function(ns) {
  
  
   
  fluidPage(
    #  ui <- layout_sidebar(
    #includeCSS("C:/Users/sw175264/Desktop/Evolutions Prostar/Cyril/Maquette/www/theme_base2.css"),
    tags$style(".bslib-sidebar-layout .collapse-toggle{display:true;}"),

    bs4Dash::bs4Card(
      id = ns("Screens"),
      uiOutput(ns("SkippedInfoPanel")),
      uiOutput(ns("EncapsulateScreens_ui"))
    ),
     absolutePanel(id = "initial_panel",
       draggable = TRUE,
       fluidRow(
         column(width = 4, shinyjs::disabled(
         actionButton(ns("prevBtn"),
           tl_h_prev_icon,
           class = PrevNextBtnClass,
           style = btn_css_style
         )
       )),
         column(width = 4, mod_modalDialog_ui(id = ns("rstBtn"))),
           column(width = 4, actionButton(ns("nextBtn"),
         tl_h_next_icon,
         class = PrevNextBtnClass,
         style = btn_css_style
       )),
       top = 0,
       left = 0,
       width = 200,
       height = 200,
       style = "background-color: orange;
    z-index = 20000;
    opacity: 0.85;
    padding: 0px 0px 200px 0px;
    margin: 0px 0px 0px 0px;
    padding-bottom: 2mm;
    padding-top: 1mm;",
       )
     )
    
)
    
}
