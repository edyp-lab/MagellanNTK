#' @title   format_DT_ui and format_DT_server
#'
#' @description
#'
#' A shiny Module.
#'
#'
#' @param id shiny id
#' @param dataIn xxx
#' @param hidden Default is reactive({NULL}),
#' @param withDLBtns Default is FALSE,
#' @param showRownames Default is FALSE,
#' @param dom Default is 'Bt',
#' @param max.rows Default is 20,
#' @param hc_style Default is reactive({NULL}),
#' @param remoteReset Default is reactive({0}),
#' @param is.enabled Default is TRUE
#'
#' @name format_DT
#'
#' @examples
#' \dontrun{
#' library(SummarizedExperiment)
#' data(lldata)
#' obj <- assay(lldata[[1]])
#' shiny::runApp(format_DT(obj))
#'
#'
#' #
#' # Compute style from within main tab
#' #
#' data(Exp1_R25_prot, package = "DaparToolshedData")
#' obj <- data.frame(colData(Exp1_R25_prot))
#'
#' style <- list(
#'     cols = colnames(obj),
#'     vals = colnames(obj)[2],
#'     unique = unique(obj$Condition),
#'     pal = RColorBrewer::brewer.pal(3, "Dark2")[1:2]
#' )
#' shiny::runApp(format_DT(obj, hc_style = style))
#'
#'
#'
#' #
#' # Compute style from within third party tab
#' #
#' obj <- as.data.frame(matrix(1:30, byrow = TRUE, nrow = 6))
#' colnames(obj) <- paste0("col", 1:5)
#'
#' mask <- as.data.frame(matrix(rep(LETTERS[1:5], 6), byrow = TRUE, nrow = 6))
#'
#'
#' style <- list(
#'     cols = colnames(obj),
#'     vals = colnames(mask),
#'     unique = unique(mask),
#'     pal = RColorBrewer::brewer.pal(5, "Dark2")[1:5]
#' )
#'
#' shiny::runApp(format_DT(obj,
#'     hidden = mask,
#'     hc_style = style
#' ))
#' }
#'
#' @return NA
#'
NULL



#' @importFrom shiny NS tagList
#' @importFrom DT dataTableOutput
#' @export
#' @rdname format_DT
#'
format_DT_ui <- function(id) {
    ns <- NS(id)
    tagList(
        shinyjs::useShinyjs(),
        DT::dataTableOutput(ns("StaticDataTable"))
    )
}

#'
#' @export
#'
#' @importFrom htmlwidgets JS
#' @importFrom DT dataTableOutput dataTableProxy replaceData formatStyle styleEqual renderDataTable datatable
#'
#' @rdname format_DT
format_DT_server <- function(
        id,
        dataIn = reactive({
            NULL
        }),
        hidden = reactive({
            NULL
        }),
        withDLBtns = FALSE,
        showRownames = FALSE,
        dom = "Bt",
        max.rows = 20,
        hc_style = reactive({
            NULL
        }),
        remoteReset = reactive({
            0
        }),
        is.enabled = reactive({
            TRUE
        })) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        rv.infos <- reactiveValues(
            obj = NULL
        )


        proxy <- DT::dataTableProxy(session$ns("StaticDataTable"), session)

        observe({
            req(dataIn())
            rv.infos$obj <- dataIn()
            if (!is.null(hidden())) {
                rv.infos$obj <- cbind(dataIn(), hidden())
            }


            DT::replaceData(proxy, rv.infos$obj, resetPaging = FALSE)
        })

        initComplete <- function() {
            return(htmlwidgets::JS(
                "function(settings, json) {",
                "$(this.api().table().header()).css({'background-color': 'darkgrey', 'color': 'black'});",
                "}"
            ))
        }



        GetColumnDefs <- reactive({
            # .jscode <- DT::JS("$.fn.dataTable.render.ellipsis( 60 )")

            # if (!is.null(hidden())) {
            #    tgt.seq <- seq.int(from = ncol(obj()), to = ncol(obj()) + ncol(hidden()) -1)
            #   list(
            #     list(targets = '_all', className = "dt-center", render = .jscode)
            #     ,list(targets = tgt.seq, visible = FALSE)
            #   )
            # } else {
            #   list(list(targets = '_all', className = "dt-center", render = .jscode))
            # }

            if (!is.null(hidden())) {
                tgt.seq <- seq.int(from = ncol(dataIn()), to = ncol(dataIn()) + ncol(hidden()) - 1)
                list(
                    list(targets = "_all", className = "dt-center"),
                    list(targets = tgt.seq, visible = FALSE)
                )
            } else {
                list(list(targets = "_all", className = "dt-center"))
            }
        })


        output$StaticDataTable <- DT::renderDataTable(server = TRUE, {
            req(length(rv.infos$obj) > 0)
            # .jscode <- DT::JS("$.fn.dataTable.render.ellipsis( 30 )")
            dt <- DT::datatable(
                rv.infos$obj,
                escape = FALSE,
                extensions = c("Scroller"),
                rownames = showRownames,
                plugins = "ellipsis",
                options = list(
                    initComplete = initComplete(),
                    dom = dom,
                    autoWidth = TRUE,
                    columnDefs = GetColumnDefs(),
                    deferRender = TRUE,
                    bLengthChange = TRUE,
                    lengthChange = TRUE,
                    paging = TRUE,
                    pageLength = max.rows
                )
            )


            if (!is.null(hc_style())) {
                dt <- dt %>%
                    DT::formatStyle(
                        columns = hc_style()$cols,
                        valueColumns = hc_style()$vals,
                        target = "cell",
                        backgroundColor = DT::styleEqual(hc_style()$unique, hc_style()$pal)
                    )
            }


            dt
        })
    })
}




#' @export
#' @rdname format_DT
#'
format_DT <- function(
        dataIn,
        hidden = NULL,
        withDLBtns = FALSE,
        showRownames = FALSE,
        dom = "Bt",
        hc_style = NULL,
        remoteReset = NULL,
        is.enabled = TRUE) {
    stopifnot(inherits(dataIn, "data.frame"))
    ui <- format_DT_ui("dt")

    server <- function(input, output, session) {
        format_DT_server("dt",
            dataIn = reactive({
                dataIn
            }),
            hidden = reactive({
                hidden
            }),
            withDLBtns = withDLBtns,
            showRownames = showRownames,
            dom = dom,
            hc_style = reactive({
                hc_style
            }),
            remoteReset = reactive({
                remoteReset
            }),
            is.enabled = reactive({
                is.enabled
            })
        )
    }

    app <- shinyApp(ui = ui, server = server)
}
