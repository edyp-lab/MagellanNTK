#' @title launch_magellan UI Function
#'
#' @description A shiny Module.
#' 
#' @param id A `character()` as the id of the Shiny module
#'
#' @examples
#' if (interactive()) {
#'     shiny::runApp(mod_launch_magellan())
#' }
#'
#' @name mod_launch_magellan
#'
#' @importFrom shiny NS tagList
#'
#' @return NA
NULL


#' launch_magellan Server Function
#'
#' @rdname mod_launch_magellan
#' @export
#' 
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#'
mod_launch_magellan_ui <- function(id) {
    ns <- NS(id)
    tagList(
        div(
            # div(style="display:inline-block; vertical-align: middle; padding-right: 20px;",
            #   choose_pipeline_ui(ns("pipe"))
            # ),
            div(
                # style="display:inline-block; vertical-align: middle; padding-right: 20px;",
                shinyjs::hidden(div(
                    id = ns("div_demoDataset"),
                  open_dataset_ui(ns("rl"))
                ))
            ),
            div(
                style = "display:inline-block; vertical-align: middle; padding-right: 20px;",
                shinyjs::hidden(actionButton(ns("load_dataset_btn"), "Load dataset", class = actionBtnClass))
            )
        )
        # uiOutput(ns('show'))
    )
}

#' launch_magellan Server Function
#'
#' @rdname mod_launch_magellan
mod_launch_magellan_server <- function(id) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        rv <- reactiveValues(
            demoData = NULL,
            pipeline = NULL,
            pipeline.name = NULL,
            dataIn = NULL
        )

        rv$demoData <- open_dataset_server("rl")

        # rv$pipeline.name <- choose_pipeline_server('pipe',
        #                                                package = 'MSPipelines')

        observe({
            shinyjs::toggle("div_demoDataset", condition = !is.null(rv$pipeline.name()) && rv$pipeline.name() != "None")
            shinyjs::toggle("load_dataset_btn", condition = !is.null(rv$demoData()))
        })

        observeEvent(req(rv$pipeline.name() != "None"), {

            obj <- base::get(rv$pipeline.name())
            rv$pipeline <- do.call(obj$new, list("App"))
            # rv$pipeline <- Protein$new('App')
            rv$dataOut <- rv$pipeline$server(dataIn = reactive({
                rv$dataIn
            }))
        })

        observeEvent(req(input$load_dataset_btn), ignoreNULL = TRUE, {
            rv$dataIn <- rv$demoData()
        })

        output$show <- renderUI({
            req(rv$pipeline)
            rv$pipeline$ui()
        })

        list(
            server = reactive({
                rv$dataOut
            }),
            ui = reactive({
                req(rv$pipeline)
                rv$pipeline$ui()
            })
        )
    })
}


#' @export
#' @rdname mod_launch_magellan
#'
#'
mod_launch_magellan <- function() {
    ui <- mod_launch_magellan_ui("demo")

    server <- function(input, output, session) {
        mod_launch_magellan_server()
    }

    app <- shinyApp(ui = ui, server = server)
}
