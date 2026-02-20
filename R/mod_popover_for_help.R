#' @title Opens a small tooltip info over a widget.
#' @description Actually, this module does not work because we do not allow
#' the use of the package `shinyBS` package (conflicts with BS versions).
#' In the future, one will fix this module with native functions in the package 
#' `bs4Dash` (https://bs4dash.rinterface.com/reference/tooltip).
#'
#' @param id A `character()` as the id of the Shiny module
#' @param title The title of the tooltip window
#' @param content The main text of the tooltip window
#'
#' @name mod_popover_for_help
#'
#' @examples
#' if (interactive()) {
#'     shiny::runApp(popover_for_help("myTitle", "myContent"))
#' }
#'
#' @return A shiny App
#' 
#' @importFrom shiny renderUI req moduleServer
#'
NULL


#' @rdname mod_popover_for_help
#'
#' @export
#' @importFrom shiny NS tagList div uiOutput
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#'
mod_popover_for_help_ui <- function(id) {
    ns <- NS(id)
    tagList(
        shinyjs::useShinyjs(),
        shinyjs::inlineCSS(pop_css),
        div(
            div(
                # edit1
                style = "display:inline-block; vertical-align: middle; padding-bottom: 5px;",
                uiOutput(ns("write_title_ui"))
            ),
            div(
                style = "display:inline-block; vertical-align: middle;padding-bottom: 5px;",
                uiOutput(ns("dot")),
                uiOutput(ns("show_Pop"))
            )
        )
    )
}



#' @rdname mod_popover_for_help
#'
#' @export
#'
mod_popover_for_help_server <- function(id, title, content) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        output$write_title_ui <- renderUI({
            HTML(paste0("<strong><font size=\"4\">", title, "</font></strong>"))
        })

        output$dot <- renderUI({
            tags$button(tags$sup("[?]"), class = "custom_tooltip")
        })

        # output$show_Pop <- renderUI({
        #     req(content)
        #     shinyBS::bsTooltip(ns("dot"), content, trigger = "hover")
        # })
    })
}


pop_css <- "button.custom_tooltip {
    background:none;
    color: #2EA8B1;
    border:none;
    padding-left:1ch;
    font: inherit;
    /*border is optional*/
        /*border-bottom:1px solid #444;*/
    cursor: pointer;
    font-weight: bold;
    display: inline-block;
    padding:0;
}

button.Prostar_tooltip_white {
    background:none;
    color: white;
    border:none;
    padding-left:1ch;
    font: inherit;
    /*border is optional*/
        /*border-bottom:1px solid #444;*/
    cursor: pointer;
    font-weight: bold;
    display: inline-block;
    padding:0;
}

.input-color {
    position: relative;
}
.input-color input {
    padding-left: 15px;
    border: 0px;
    background: transparent;
}
.input-color .color-box {
    width: 15px;
    height: 15px;
    display: inline-block;
    background-color: #ccc;
    position: absolute;
    left: 5px;
    top: 5px;

}"


#' @rdname mod_popover_for_help
#'
#' @export
#' @importFrom shiny fluidPage tagList textOutput reactiveValues observeEvent
#' shinyApp
#'
popover_for_help <- function(title, content) {
    ui <- fluidPage(
        mod_popover_for_help_ui("settings")
    )

    server <- function(input, output, session) {
        mod_popover_for_help_server("settings",
            title = title,
            content = content
        )
    }

    app <- shiny::shinyApp(ui, server)
}
