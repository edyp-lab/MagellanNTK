#' @title Shiny example module `Process`
#'
#' @description
#' This module contains the configuration information for the corresponding
#' pipeline. It is called by the nav_pipeline module of the package MagellanNTK
#' This documentation is for developers who want to create their own
#' pipelines nor processes to be managed with `MagellanNTK`.
#'
#' @param id xxx
#' @param path xxx
#' @param dataIn xxx
#' @param usermod Available values are 'superdev', 'dev', 'superuser', 'user'
#' @param verbose xxx
#'
#' @name workflow
#'
#' @author Samuel Wieczorek
#'
#' @importFrom utils data
#' @importFrom shiny NS tagList actionButton reactive moduleServer reactiveVal
#' renderUI observeEvent shinyApp
#'
#' @return NA
#'
#' @examples
#' if (interactive()) {
#'     library(MagellanNTK)
#'     library(shiny)
#'     data(lldata)
#'     data(lldata)
#'     path <- system.file("workflow/PipelineDemo", package = "MagellanNTK")
#'     files <- list.files(file.path(path, "R"), full.names = TRUE)
#'     for (f in files) {
#'         source(f, local = FALSE, chdir = TRUE)
#'     }
#'
#'
#'     # Nothing happens when dataIn is NULL
#'     pipe_workflowApp("PipelineDemo", path, dataIn = NULL)
#'
#'     pipe_workflowApp("PipelineDemo", path, dataIn = lldata)
#'
#'     pipe_workflowApp("PipelineDemo", dataIn = data.frame())
#'
#'     pipe_workflowApp("PipelineDemo", path, dataIn = lldata)
#'
#'     pipe_workflowApp("PipelineB", path, tl.layout = c("v", "h"))
#'
#'     pipe_workflowApp("PipelineDemo", path,
#'         dataIn = sub_R25,
#'         tl.layout = c("v", "h")
#'     )
#'
#'
#'     # Nothing happens when dataIn is NULL
#'     proc_workflowApp("PipelineDemo_Process1", path, dataIn = NULL)
#'
#'     proc_workflowApp("PipelineDemo_Process1", path, dataIn = sub_R25)
#'
#'     proc_workflowApp("PipelineDemo_Process1", path, dataIn = data.frame(), tl.layout = "v")
#'
#'     proc_workflowApp("PipelineDemo", path, dataIn = sub_R25, tl.layout = c("v", "h"))
#'
#'     proc_workflowApp("PipelineDemo", path, dataIn = sub_R25, tl.layout = c("v", "h"))
#' }
#'
NULL


#' @export
#' @rdname workflow
#'
pipe_workflow_ui <- function(id) {
    ns <- NS(id)
    tagList(
        nav_pipeline_ui(ns(id)),
        uiOutput(ns("debugInfos_ui"))
    )
}



#' @export
#' @rdname workflow
#'
pipe_workflow_server <- function(
        id,
        path = NULL,
        dataIn = reactive({
            NULL
        }),
        usermod = "dev",
        verbose = FALSE) {
    if (is.null(path)) {
        message("'path' is not correctly configured. Abort...")
        return(NULL)
    }

    source_shinyApp_files()
    source_wf_files(path)

    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        dataOut <- reactiveVal()

        output$debugInfos_ui <- renderUI({
            req(usermod == "dev")
            Debug_Infos_server(
                id = "debug_infos",
                title = "Infos from shiny app",
                rv.dataIn = reactive({
                    dataIn
                }),
                dataOut = reactive({
                    rv$dataOut$dataOut()
                })
            )
            Debug_Infos_ui("debug_infos")
        })

        output$save_dataset_ui <- renderUI({
            req(c(dataOut(), dataOut()$dataOut()$value))

            dl_ui(ns("saveDataset"))
            dl_server(
                id = "saveDataset",
                dataIn = reactive({
                    dataOut()$dataOut()$value
                })
            )
        })


        observeEvent(path, {
            session$userData$workflow.path <- path
            session$userData$funcs <- readConfigFile(path)$funcs
        })


        observeEvent(dataIn, {
            dataOut(
                nav_pipeline_server(
                    id = id,
                    dataIn = reactive({
                        dataIn
                    }),
                    verbose = verbose,
                    usermod = usermod
                )
            )
        })

        return(reactive({
            dataOut()
        }))
    })
}




#' @rdname workflow
#' @export
pipe_workflowApp <- function(
        id,
        path = NULL,
        dataIn = NULL,
        usermod = "dev",
        verbose = FALSE) {
    ui <- pipe_workflow_ui(id)

    server <- function(input, output, session) {
        res <- pipe_workflow_server(
            id,
            path = path,
            dataIn = dataIn
        )

        observeEvent(req(res()$dataOut()$trigger), {
            print(res()$dataOut()$value)
        })
    }

    shiny::shinyApp(ui, server)
}







#' @export
#' @rdname workflow
#'
proc_workflow_ui <- function(id) {
    ns <- NS(id)
    tagList(
        nav_process_ui(ns(id)),
        uiOutput(ns("debugInfos_ui"))
    )
}



#' @export
#' @rdname workflow
#'
proc_workflow_server <- function(
        id,
        path = NULL,
        dataIn = reactive({
            NULL
        }),
        usermod = "dev",
        verbose = FALSE) {
    if (is.null(path)) {
        message("'path' is not correctly configured. Abort...")
        return(NULL)
    }

    addResourcePath("www", system.file("www", package = "MagellanNTK"))

    source_shinyApp_files()
    source_wf_files(path)

    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        dataOut <- reactiveVal()

        output$debugInfos_ui <- renderUI({
            req(usermod == "dev")
            Debug_Infos_server(
                id = "debug_infos",
                title = "Infos from shiny app",
                rv.dataIn = reactive({
                    dataIn
                }),
                dataOut = reactive({
                    rv$dataOut$dataOut()
                })
            )
            Debug_Infos_ui("debug_infos")
        })

        output$save_dataset_ui <- renderUI({
            req(c(dataOut(), dataOut()$dataOut()$value))

            dl_ui(ns("saveDataset"))
            dl_server(
                id = "saveDataset",
                dataIn = reactive({
                    dataOut()$dataOut()$value
                })
            )
        })


        observeEvent(path, {
            session$userData$workflow.path <- path
            session$userData$funcs <- readConfigFile(path)$funcs
        })


        observeEvent(dataIn, {
            dataOut(
                nav_process_server(
                    id = id,
                    dataIn = reactive({
                        dataIn
                    }),
                    verbose = verbose,
                    usermod = usermod,
                    remoteReset = reactive({
                        NULL
                    })
                )
            )
        })

        return(reactive({
            dataOut()
        }))
    })
}




#' @rdname workflow
#' @export
proc_workflowApp <- function(
        id,
        path = NULL,
        dataIn = NULL,
        usermod = "dev",
        verbose = FALSE) {
    ui <- proc_workflow_ui(id)

    server <- function(input, output, session) {
        res <- proc_workflow_server(
            id,
            path = path,
            dataIn = dataIn
        )

        observeEvent(req(res()$dataOut()$trigger), {
            print(res()$dataOut()$value)
        })
    }

    shiny::shinyApp(ui, server)
}
