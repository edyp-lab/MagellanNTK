#' @title Load dataset shiny module
#'
#' @description  A shiny Module to load a dataset.
#' @name Save_Dataset
#'
#' @param id A `character()` as the id of the Shiny module
#' @param data The object to be saved
#'
#' @examples
#' if (interactive()) {
#'     shiny::runApp(Save_Dataset(lldata))
#' }
#'
#' @return A shiny app
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
#'
#' @rdname Save_Dataset
#'
#' @export
#'
Save_Dataset_server <- function(id, data) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

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
