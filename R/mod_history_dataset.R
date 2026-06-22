#' @title   history_dataset_ui and history_dataset_server
#'
#' @description A shiny Module which show th content of the slot 'history'
#' in the metadata() of the last SE of the dataset
#'
#' @param id A `character()` as the id of the Shiny module
#' @param dataIn An instance of the class `MultiAssayExperiment`.
#'
#' @return A shiny app
#'
#' @name history_dataset
#'
#' @examples
#' if (interactive()) {
#'   data(lldata)
#'   shiny::runApp(history_dataset(lldata))
#' }
#'
NULL

#' @rdname history_dataset
#'
#' @importFrom shiny NS tagList
#'
#' @export
#'
history_dataset_ui <- function(id) {
  ns <- NS(id)
  div(
    style = "height: 600px",
    p("Default implementation of this content."),
    MagellanNTK::format_DT_ui(ns("history"))
  )
}

#' @rdname history_dataset
#'
#' @keywords internal
#'
#' @importFrom SummarizedExperiment rowData assay colData
#' @importFrom S4Vectors metadata
#' @importFrom MultiAssayExperiment experiments
#'
#' @export
#'
history_dataset_server <- function(
  id,
  dataIn = reactive({
    NULL
  }),
  remoteReset = reactive({
    0
  }),
  is.enabled = reactive({
    TRUE
  })
) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    rv <- reactiveValues(
      dataIn = NULL
    )
    observeEvent(req(inherits(dataIn(), "MultiAssayExperiment")), {
      rv$dataIn <- dataIn()
    })

    Get_MAE_History <- reactive({
      req(rv$dataIn)

      .name <- names(rv$dataIn)[length(rv$dataIn)]
      df <- as.data.frame(GetHistory(rv$dataIn, .name))
      return(df)
    })

    MagellanNTK::format_DT_server("history",
      dataIn = reactive({
        Get_MAE_History()
      })
    )
  })
}

#' @rdname history_dataset
#'
#' @export
#'
history_dataset <- function(obj) {
  ui <- fluidPage(history_dataset_ui("mod_info"))

  server <- function(input, output, session) {
    history_dataset_server("mod_info",
      dataIn = reactive({
        obj
      })
    )
  }

  app <- shiny::shinyApp(ui, server)
}
