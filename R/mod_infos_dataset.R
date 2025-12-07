#' @title infos_dataset_ui and infos_dataset_server
#'
#' @description A shiny Module.
#'
#' @param id xxx
#' @param dataIn xxx
#'
#' @name infos_dataset
#'
#' @examples
#' if (interactive()) {
#'     shiny::runApp(infos_dataset(lldata))
#' }
#'
#' @return NA
#'
NULL




#' @export
#' @rdname infos_dataset
#' @importFrom shiny NS tagList uiOutput fluidRow h3 br column
#'
infos_dataset_ui <- function(id) {
    ns <- NS(id)
    tagList(
        h3(style = "color: blue;", "Info dataset"),
        uiOutput(ns("title")),
        uiOutput(ns("choose_SE_ui")),
        uiOutput(ns("show_SE_ui"))
    )
}


#' @rdname infos_dataset
#'
#' @export
#' @importFrom BiocGenerics get
#' @importFrom utils data
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#' @importFrom shiny moduleServer observe req reactive selectInput renderUI
#'
#'
infos_dataset_server <- function(
        id,
        dataIn = reactive({
            NULL
        })) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        output$choose_SE_ui <- renderUI({
            req(dataIn())
            selectInput(ns("selectInputSE"),
                "Select a dataset for further information",
                choices = c("None", names(dataIn()))
            )
        })


        output$show_SE_ui <- renderUI({
            req(input$selectInputSE != "None")
            req(dataIn())
            p(input$selectInputSE)
        })
    })
}




###################################################################
##                                                               ##
##                                                               ##
###################################################################
#' @export
#' @importFrom shiny shinyApp fluidPage
#' @rdname infos_dataset
#'
infos_dataset <- function(dataIn) {
    ui <- fluidPage(
        infos_dataset_ui("infos")
    )


    server <- function(input, output, session) {
        infos_dataset_server("infos", dataIn = reactive({
            dataIn
        }))
    }

    app <- shinyApp(ui = ui, server = server)
}
