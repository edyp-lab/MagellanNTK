#' @title Load dataset shiny module
#'
#' @description  A shiny Module to load a dataset.
#' @name Save_Dataset
#'
#' @param id A `character()` as the id of the Shiny module
#' @param data xxx
#'
#' @examples
#' if (interactive()) {
#'     shiny::runApp(Save_Dataset(lldata))
#' }
#'
#' @return NA
#'
NULL


#' @rdname Save_Dataset
#' @importFrom shiny downloadLink
#'
#' @export
#'
Save_Dataset_ui <- function(id) {
    ns <- NS(id)
    shiny::downloadLink(ns("downloadData"), "Download")
}



#' @importFrom shiny downloadHandler moduleServer
#' @return NA
#'
#' @rdname Save_Dataset
#'
#' @export
#'
Save_Dataset_server <- function(id, data) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        # rv <- reactiveValues(
        #   dataIn = NULL,
        #   dataOut = NULL)
        #
        output$downloadData <- downloadHandler(
            filename = function() {
                # paste('data-', input$files, "-", Sys.Date(), '.pdf', sep='')
                "temp.RData"
            },
            content = function(file) {
                # file.copy(paste0(input$files, ".pdf"), file)
                saveRDS(data(), file = "temp.RData")
            }
        )
    })
}




#' @importFrom shiny fluidPage shinyApp
#'
#' @return NA
#'
#' @rdname Save_Dataset
#'
#' @export
#'
Save_Dataset <- function(data) {
    ui <- Save_Dataset_ui(id = "saveDataset")

    server <- function(input, output, session) {
        Save_Dataset_server(id = "saveDataset", reactive({
            data
        }))
    }

    app <- shiny::shinyApp(ui, server)
}
