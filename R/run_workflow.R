#' @title Shiny example module `Process`
#'
#' @description
#' This module contains the configuration information for the corresponding
#' pipeline. It is called by the nav_pipeline module of the package MagellanNTK
#' This documentation is for developers who want to create their own
#' pipelines nor processes to be managed with `MagellanNTK`.
#'
#' @param id A `character()` as the id of the Shiny module
#' @param path A `character()` which is the path to the directory which 
#' contains the files and directories of the pipeline.
#' @param dataIn xxx
#' @param usermod A character to specifies the running mode of MagellanNTK. 
#' * user (default) : xxx
#' * dev: xxx
#' @param verbose A `boolean` to indicate whether to turn off (FALSE) or ON (TRUE)
#' the verbose mode for logs.
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
#'         dataIn = lldata,
#'         tl.layout = c("v", "h")
#'     )
#'
#'
#'     # Nothing happens when dataIn is NULL
#'     proc_workflowApp("PipelineDemo_Process1", path, dataIn = NULL)
#'
#'     proc_workflowApp("PipelineDemo_Process1", path, dataIn = lldata)
#'
#'     proc_workflowApp("PipelineDemo_Process1", path, dataIn = data.frame(), tl.layout = "v")
#'
#'     proc_workflowApp("PipelineDemo", path, dataIn = lldata, tl.layout = c("v", "h"))
#'
#'     proc_workflowApp("PipelineDemo", path, dataIn = lldata, tl.layout = c("v", "h"))
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
        dataIn = reactive({NULL}),
        usermod = "user",
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

        output$save_dataset_ui <- renderUI({
            req(c(dataOut(), dataOut()$dataOut()$value))

          download_dataset_ui(ns("saveDataset"))
            download_dataset_server(
                id = "saveDataset",
                dataIn = reactive({dataOut()$dataOut()$value})
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
                    dataIn = reactive({dataIn}),
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
        usermod = "user",
        verbose = FALSE) {
    ui <- pipe_workflow_ui(id)

    server <- function(input, output, session) {
        res <- pipe_workflow_server(
            id,
            path = path,
            dataIn = dataIn
        )

        observeEvent(req(res()$dataOut()$trigger), {

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
        nav_process_ui(ns(id))
    )
}



#' @export
#' @rdname workflow
#'
proc_workflow_server <- function(
        id,
        path = NULL,
        dataIn = reactive({NULL}),
        usermod = "user",
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
        session$userData$usermod <- usermod
        
        output$save_dataset_ui <- renderUI({
            req(c(dataOut(), dataOut()$dataOut()$value))

          download_dataset_ui(ns("saveDataset"))
          download_dataset_server(
                id = "saveDataset",
                dataIn = reactive({dataOut()$dataOut()$value})
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
                    dataIn = reactive({dataIn}),
                    verbose = verbose,
                    usermod = usermod,
                    remoteReset = reactive({0})
                )
            )
        })

        return(reactive({dataOut()}))
    })
}




#' @rdname workflow
#' @export
proc_workflowApp <- function(
        id,
        path = NULL,
        dataIn = NULL,
        usermod = "user",
        verbose = FALSE) {
    ui <- proc_workflow_ui(id)

    server <- function(input, output, session) {
        res <- proc_workflow_server(
            id,
            path = path,
            dataIn = dataIn
        )

        observeEvent(req(res()$dataOut()$trigger), {

        })
    }

    shiny::shinyApp(ui, server)
}
