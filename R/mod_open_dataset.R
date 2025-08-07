#' @title Change the default functions in `MagellanNTK`
#'
#' @description This module allows to change
#'
#' @param id xxx
#' @param class xxx
#' @param extension xxx
#' @param demo_package xxx
#'
#' @name generic_mod_open_dataset
#'
#' @examples
#' \dontrun{
#' shiny::runApp(open_dataset(class = "QFeatures", extension = ".qf"))
#' shiny::runApp(open_dataset(class = "QFeatures", extension = ".qf", demo_package = "DaparToolshedData"))
#' }
#'
NULL




#' @export
#' @rdname generic_mod_open_dataset
#' @importFrom shiny NS tagList
#' @importFrom shinyjs useShinyjs
#'
open_dataset_ui <- function(id) {
    ns <- NS(id)
    tagList(
        h3(style = "color: blue;", "Open dataset (default)"),
        shinyjs::useShinyjs(),
        tagList(
            selectInput(ns("chooseSource"), "Dataset source",
                choices = c(
                    "Custom dataset" = "customDataset",
                    "package dataset" = "packageDataset"
                ),
                width = "200px"
            ),
            uiOutput(ns("customDataset_UI")),
            uiOutput(ns("packageDataset_UI")),
            uiOutput(ns("load_btn_UI"))
        )
        # uiOutput(ns('datasetInfos_UI'))
    )
}


#' @rdname generic_mod_open_dataset
#'
#' @export
#' @importFrom BiocGenerics get
#' @importFrom utils data
#' @importFrom shinyjs info
#'
open_dataset_server <- function(
        id,
        class = NULL,
        extension = NULL,
        demo_package = NULL) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        rv.open <- reactiveValues(
            dataRead = NULL,
            name = "default.name",
            packages = NULL
        )

        dataOut <- reactiveValues(
            trigger = NULL,
            name = NULL,
            dataset = NULL
        )


        observeEvent(id, {
            req(class)
            req(extension)
        })


        output$packageDataset_UI <- renderUI({
            req(input$chooseSource == "packageDataset")
            wellPanel(
                uiOutput(ns("choosePkg")),
                uiOutput(ns("chooseDemoDataset")),
                uiOutput(ns("linktoDemoPdf"))
            )
        })


        output$customDataset_UI <- renderUI({
            req(input$chooseSource == "customDataset")
            req(extension)

            wellPanel(
                fileInput(ns("file"), "Open file",
                    accept = extension, multiple = FALSE, width = "400px"
                )
            )
        })


        output$load_btn_UI <- renderUI({
            shinyjs::disabled(
                actionButton(ns("load_dataset_btn"), "Load",
                    class = PrevNextBtnClass
                )
            )
        })

        output$choosePkg <- renderUI({
            req(input$chooseSource == "packageDataset")

            withProgress(message = "", detail = "", value = 0.5, {
                incProgress(0.5, detail = paste0("Searching for ", class, " datasets"))
                rv.open$packages <- GetListDatasets(class, demo_package)
            })


            req(rv.open$packages)

            selectizeInput(ns("pkg"), "Choose package",
                choices = rv.open$packages[, "Package"],
                width = "200px"
            )
        })


        ## function for demo mode
        output$chooseDemoDataset <- renderUI({
            req(input$chooseSource == "packageDataset")
            req(input$pkg)
            pkgs.require(input$pkg)

            req(rv.open$packages)

            ind <- which(rv.open$packages[, "Package"] == input$pkg)

            selectInput(ns("demoDataset"),
                "Demo dataset",
                choices = rv.open$packages[ind, "Item"],
                selected = character(0),
                width = "200px"
            )
        })



        observe({
            cond1 <- input$chooseSource == "customDataset" && !is.null(input$file$datapath)
            cond2 <- input$chooseSource == "packageDataset" && !is.null(input$pkg) && input$pkg != ""

            shinyjs::toggleState("load_dataset_btn", condition = cond1 || cond2)
        }) # End observeEvent


        output$linktoDemoPdf <- renderUI({
            req(input$demoDataset)
            req(input$chooseSource == "packageDataset")
        })


        observeEvent(input$file$datapath, {
            if (!inherits(readRDS(input$file$datapath), class)) {
                errorModal("test")
                print("erreur")
            }
        })
        # Part of open custom dataset
        ## -- Open a MSnset File --------------------------------------------
        observeEvent(input$load_dataset_btn, ignoreInit = TRUE, {
            if (input$chooseSource == "packageDataset") {
                req(input$demoDataset != "None")
                utils::data(list = input$demoDataset, package = input$pkg)
                rv.open$name <- input$demoDataset
                rv.open$dataRead <- BiocGenerics::get(input$demoDataset)
            } else if (input$chooseSource == "customDataset") {
                input$file
                rv.open$dataRead <- NULL
                tryCatch(
                    {
                        # Try with readRDS()
                        rv.open$name <- input$file$name
                        rv.open$dataRead <- readRDS(input$file$datapath)
                    },
                    warning = function(w) {
                        return(NULL)
                    },
                    error = function(e) {
                        return(NULL)
                    }
                )

                if (is.null(rv.open$dataRead)) {
                    rv.open$dataRead <- tryCatch(
                        {
                            load(file = input$file$datapath)
                            rv.open$name <- unlist(strsplit(input$file$name, split = ".", fixed = TRUE))[1]
                            get(rv.open$name)
                        },
                        warning = function(w) {
                            return(NULL)
                        },
                        error = function(e) {
                            return(NULL)
                        }
                    )
                }
            }

            dataOut$dataset <- rv.open$dataRead
            dataOut$trigger <- MagellanNTK::Timestamp()
            dataOut$name <- rv.open$name
        })
        reactive({
            dataOut
        })
    })
}



#' @export
#' @rdname generic_mod_open_dataset
#'
#'
open_dataset <- function(
        class = NULL,
        extension = NULL,
        demo_package = NULL) {
    ui <- fluidPage(
        open_dataset_ui("demo")
    )


    server <- function(input, output, session) {
        rv <- reactiveValues(
            obj = NULL
        )

        rv$obj <- open_dataset_server("demo",
            class = class,
            extension = extension,
            demo_package = demo_package
        )

        observeEvent(rv$obj()$trigger, {
            print(rv$obj()$name)
            print(rv$obj()$dataset)
        })
    }

    app <- shinyApp(ui = ui, server = server)
}
