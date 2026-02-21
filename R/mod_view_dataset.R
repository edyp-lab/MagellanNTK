#' @title mod_open_demo_dataset_ui and mod_open_demo_dataset_server
#'
#' @description  A shiny Module.
#'
#' @param id A `character()` as the id of the Shiny module
#' @param dataIn An instance of the class `MultiAssayExperiment`
#' @param ... Additional parameters
#'
#' @name view_dataset
#'
#' @return A shiny App
#'
#' @examples
#' if (interactive()) {
#' data(lldata123)
#' shiny::runApp(view_dataset(lldata))
#' }
#'
NULL




#' @export
#' @rdname view_dataset
#' @importFrom shiny NS tagList h3
#' @return NA
#'
view_dataset_ui <- function(id) {
    ns <- NS(id)
      tagList(
        h3("This is the default module infos_dataset of MagellanNTK. It can be customized."),
        uiOutput(ns("choose_SE_ui")),
        plotOutput(ns("plot_ui"))
      )
}


#' @rdname view_dataset
#'
#' @export
#' @importFrom shiny moduleServer reactiveValues reactive
#' @importFrom graphics hist
#'
view_dataset_server <- function(
        id,
        dataIn = NULL,
        ...) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns
        
        rv <- reactiveValues(
          dataIn = NULL
        )
        
        observeEvent(req(inherits(dataIn(), "MultiAssayExperiment")), {
          rv$dataIn <- dataIn()
        })
        
        output$choose_SE_ui <- renderUI({
          req(rv$dataIn)
          
          radioButtons(ns("selectInputSE"),
            "Select an assay",
            choices = names(MultiAssayExperiment::experiments(rv$dataIn))
          )
        })
        
        
        output$plot_ui <- renderPlot({
          req(rv$dataIn)
          req(input$selectInputSE != "None")
          .se <- rv$dataIn[[input$selectInputSE]]
          req(.se)
          
          plot(graphics::hist(assay(.se))$density, type = 'l')
        })
        

    })
}



#' @export
#' @rdname view_dataset
#' @importFrom shiny shinyApp reactiveValues reactive
#'
view_dataset <- function(dataIn) {
    ui <- view_dataset_ui("modviewDataset")


    server <- function(input, output, session) {
        rv <- reactiveValues(
            dataIn = NULL
        )

        rv$dataIn <- view_dataset_server("modviewDataset",
            dataIn = reactive({dataIn})
        )
    }

    app <- shinyApp(ui = ui, server = server)
}
