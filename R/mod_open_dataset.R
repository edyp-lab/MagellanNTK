#' @title Change the default functions in `MagellanNTK`
#'
#' @description This module allows to change
#'
#' @param id A `character()` as the id of the Shiny module
#' @param class xxx
#' @param demo_package xxx
#' @param extension The extension file allowed
#' @param remoteReset An `integer` which acts as a remote command to reset the 
#' module. Its value is incremented on a external event and it is used to 
#' trigger an event in this module
#' @param is.enabled A `boolean`. This variable is used as a remote command to specify
#' if the corresponding module is enabled/disabled in the calling module of
#' upper level.
#' For example, if this module is disabled, then this variable is set to TRUE. Then,
#' all the widgets will be disabled. If not, the enabling/disabling of widgets
#' is deciding by this module.
#'
#' @name generic_mod_open_dataset
#'
#' @examples
#' if (interactive()) {
#' shiny::runApp(open_dataset(extension = "rdata"))
#' }
#'
#' @return A Shiny app
#'
NULL




#' @export
#' @rdname generic_mod_open_dataset
#' @importFrom shiny NS tagList
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#'
open_dataset_ui <- function(id) {
    ns <- NS(id)
    tagList(
        shinyjs::useShinyjs(),
            uiOutput(ns('chooseSource_UI')),
            uiOutput(ns("customDataset_UI")),
            uiOutput(ns("packageDataset_UI"))
        )
}


#' @rdname generic_mod_open_dataset
#'
#' @export
#' @importFrom BiocGenerics get
#' @importFrom utils data
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#' @import shiny
#'
open_dataset_server <- function(
        id,
  class = NULL,
  demo_package = NULL,
        extension = NULL,
  remoteReset = reactive({NULL}),
  is.enabled = reactive({TRUE})) {
  
  widgets.default.values <- list(
    chooseSource = "customDataset",
    file = character(0),
    load_dataset_btn = 0,
    pkg = "None",
    demoDataset = "None"
  )
  
  rv.custom.default.values <- list(
    remoteReset = NULL,
    dataRead = NULL,
    name = "default.name",
    packages = "MagellanNTK"
  )
  
  dataOut <- reactiveValues(
    trigger = MagellanNTK::Timestamp(),
    name = NULL,
    dataset = NULL
  )
  
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        core <- paste0(
          MagellanNTK::Get_Code_Declare_widgets(names(widgets.default.values)),
          MagellanNTK::Get_Code_for_ObserveEvent_widgets(names(widgets.default.values)),
          MagellanNTK::Get_Code_for_rv_reactiveValues(),
          MagellanNTK::Get_Code_Declare_rv_custom(names(rv.custom.default.values)),
          #MagellanNTK::Get_Code_for_dataOut(),
          #MagellanNTK::Get_Code_for_remoteReset(widgets = TRUE, custom = TRUE, dataIn = 'NULL'),
          sep = "\n"
        )
        eval(str2expression(core))
        
        
        observeEvent(remoteReset(), ignoreInit = TRUE, ignoreNULL = TRUE, {
          
        lapply(names(rv.widgets), function(x){
          rv.widgets[[x]] <- widgets.default.values[[x]]
        })
          
          # lapply(names(rv.custom), function(x){
          #   rv.custom[[x]] <- rv.custom.default.values[[x]]
          # })
          
           rv.custom$dataRead <- NULL
           rv.custom$remoteReset <- remoteReset()
          # rv.widgets$file <- NULL
           dataOut$trigger <- MagellanNTK::Timestamp()
           dataOut$name <- NULL
           dataOut$dataset <- NULL
          
})

        
        
        output$chooseSource_UI <- renderUI({
          widget <- selectInput(ns("chooseSource"), "Dataset source",
            choices = c(
              "Custom dataset" = "customDataset",
              "package dataset" = "packageDataset"
            ),
            selected = rv.widgets$chooseSource,
            width = "200px"
          )
          
          MagellanNTK::toggleWidget(widget, is.enabled())
          
        })
        
        
        
        output$customDataset_UI <- renderUI({
          req(rv.widgets$chooseSource == "customDataset")
          rv.custom$remoteReset
          
          widget <- fileInput(ns("file"), "Open file",
            accept = extension, 
            multiple = FALSE, 
            width = "400px"
          )
          
          MagellanNTK::toggleWidget(widget, is.enabled())
        })
        
        
        isEmptyNumeric <- function(x) {
          return(identical(x, numeric(0)))
        }

        output$packageDataset_UI <- renderUI({
            req(rv.widgets$chooseSource == "packageDataset")
            tagList(
                uiOutput(ns("choosePkg")),
                uiOutput(ns("chooseDemoDataset"))
            )
        })


        ## function for demo mode
        output$chooseDemoDataset <- renderUI({
            req(rv.widgets$chooseSource == "packageDataset")
          d <- data(package='MagellanNTK')
            widget <- selectInput(ns("demoDataset"),
                "Demo dataset",
                choices = c('None', unname(d$results[,'Item'])),
                selected = character(0),
                width = "200px"
            )
            MagellanNTK::toggleWidget(widget, is.enabled())
        })



        observe({
            req(rv.widgets$chooseSource)
          req(rv.widgets$pkg)
          req(rv.widgets$file)
          
          cond1 <- rv.widgets$chooseSource == "customDataset" && !is.null(rv.widgets$file$datapath)
            cond2 <- rv.widgets$chooseSource == "packageDataset" && !is.null(rv.widgets$pkg) && rv.widgets$pkg != ""

            shinyjs::toggleState("load_dataset_btn", condition = cond1 || cond2)
        })


        observeEvent( input$file, {

          rv.widgets$file <- input$file
          rv.custom$dataRead <- NULL
          tryCatch({
            # Try with readRDS()
            rv.custom$name <- rv.widgets$file$name
            rv.custom$dataRead <- readRDS(rv.widgets$file$datapath)
          },
            warning = function(w) {return(NULL)},
            error = function(e) {return(NULL)}
          )
          
          if (is.null(rv.custom$dataRead)) {
            rv.custom$dataRead <- tryCatch(
              {
                load(file = rv.widgets$file$datapath)
                rv.custom$name <- unlist(strsplit(rv.widgets$file$name, split = ".", fixed = TRUE))[1]
                get(rv.custom$name)
              },
              warning = function(w) {return(NULL)},
              error = function(e) {return(NULL)}
            )
          }
          dataOut$dataset <- rv.custom$dataRead
          dataOut$trigger <- MagellanNTK::Timestamp()
          dataOut$name <- rv.custom$name
          
        })
        
        
        
        # Part of open custom dataset
        ## -- Open a  File --------------------------------------------
        observeEvent(req(rv.widgets$demoDataset != "None"), ignoreInit = FALSE, {

          utils::data(list = rv.widgets$demoDataset, package = "MagellanNTK")
                rv.custom$name <- rv.widgets$demoDataset
                rv.custom$dataRead <- BiocGenerics::get(rv.widgets$demoDataset)
          #rv.custom$remoteReset <- rv.custom$remoteReset + 1

            dataOut$dataset <- rv.custom$dataRead
            dataOut$trigger <- MagellanNTK::Timestamp()
            dataOut$name <- rv.custom$name
        })


        # # Part of open custom dataset
        # ## -- Open a  File --------------------------------------------
        # observeEvent(input$load_dataset_btn, ignoreInit = FALSE, {
        #   
        # 
        #     if (rv.widgets$chooseSource == "packageDataset") {
        #         req(rv.widgets$demoDataset != "None")
        #         utils::data(list = rv.widgets$demoDataset, package = rv.widgets$pkg)
        #         rv.custom$name <- rv.widgets$demoDataset
        #         rv.custom$dataRead <- BiocGenerics::get(rv.widgets$demoDataset)
        #     } else if (rv.widgets$chooseSource == "customDataset") {
        #       rv.widgets$file
        #       rv.custom$dataRead <- NULL
        #         tryCatch({
        #               # Try with readRDS()
        #               rv.custom$name <- rv.widgets$file$name
        #               rv.custom$dataRead <- readRDS(rv.widgets$file$datapath)
        #             },
        #             warning = function(w) {return(NULL)},
        #             error = function(e) {return(NULL)}
        #         )
        # 
        #         if (is.null(rv.custom$dataRead)) {
        #           rv.custom$dataRead <- tryCatch(
        #                 {
        #                     load(file = rv.widgets$file$datapath)
        #                   rv.custom$name <- unlist(strsplit(rv.widgets$file$name, split = ".", fixed = TRUE))[1]
        #                     get(rv.custom$name)
        #                 },
        #                 warning = function(w) {return(NULL)},
        #                 error = function(e) {return(NULL)}
        #             )
        #         }
        #     }
        #   
        #   output$msgFileLoaded <- renderUI({
        #     req(rv.custom$dataRead)
        #       h3(paste0('the file has been loaded'))
        #   })
        #   
        #   
        #   #rv.custom$remoteReset <- rv.custom$remoteReset + 1
        #   
        #     dataOut$dataset <- rv.custom$dataRead
        #     dataOut$trigger <- MagellanNTK::Timestamp()
        #     dataOut$name <- rv.custom$name
        # })
        # 
        
        return(reactive({dataOut}))

    })
}



#' @export
#' @rdname generic_mod_open_dataset
#'
#'
open_dataset <- function(
        extension = NULL) {
    ui <- fluidPage(
        tagList(
          open_dataset_ui("demo"),
          actionButton('reset', 'reset'),
          uiOutput('Description_infos_dataset_UI')
        )
    )


    server <- function(input, output, session) {
        rv <- reactiveValues(
            obj = NULL
        )

        rv$obj <- open_dataset_server("demo",
            extension = extension,
          remoteReset = reactive({input$reset})
        )

        
        output$Description_infos_dataset_UI <- renderUI({
          req(rv$obj()$dataset)
          
          infos_dataset_server(
            id = "Description_infosdataset",
            dataIn = reactive({rv$obj()$dataset})
          )
          
          infos_dataset_ui(id = "Description_infosdataset")
        })
        

    }

    app <- shinyApp(ui = ui, server = server)
}
