# ouvre une fenetre, parametre renseigne quoi afficher dans la fenetre

#' @title Predefined modal
#'
#' @description Displays of formatted modal-dialog with 'Cancel' and 
#' 'Ok' buttons.
#' 
#' @param id A `character(1)` which is the id of the instance of the module
#' @param title A `character(1)`
#' @param width A `character(1)` indicating the size of the modal window. Can 
#' be "s" for small (the default), "m" for medium, or "l" for large.
#' @param uiContent The content of the modal dialog.
#' @param external_mod xxx
#' @param external_mod_args xxx
#' @param typeWidget = 'button',
#' @param styleWidget = NULL,
#' @param classWidget = NULL
#' 
#' @importFrom shinyjqui jqui_draggable
#' 
#' @name mod_modalDialog
#' 
#' @return A Shiny modal-dialog
#' 
#' @examples
#' \dontrun{
#' 
#' ########################################################
#' ##
#' # Example with a simple static HTML
#' ##
#' ########################################################
#' 
#' shiny::runApp(mod_modalDialog(title = "test modalDialog", uiContent = p("test")))
#' 
#' ########################################################
#' ##
#' ##   Example with a simple Shiny module without any return value
#' ##
#' ########################################################
#' 
#' simple_mod_ui <- function(id){
#' # create the namespace from the id
#' ns <- NS(id)
#' fluidPage(
#' actionButton(ns("test"), "Test")
#' )
#' }
#' 
#' 
#' simple_mod_server <- function(id){ #height auto
#'   
#'   moduleServer(id, function(input, output, session){
#'     ns <- session$ns
#'     
#'     # reactiveValues object for storing current data set.
#'     dataOut <- reactiveVal(NULL)
#'     
#'     observeEvent(input$test, {
#'       dataOut(paste0('Clicked ', input$test, ' times.'))
#'     })
#'     
#'     
#'     return(reactive({dataOut()}))
#'   })
#' }
#' 
#' 
#' shiny::runApp(mod_modalDialog(title = "test modalDialog", uiContent = p("test")))
#' 
#' 
#' ########################################################
#' ##
#' ## Example with a more complex Shiny module with a return value
#' ##
#' ########################################################
#' 
#' funcs <- list(convert_dataset = "DaparToolshed::convert_dataset",
#' open_dataset = "MagellanNTK::open_dataset",
#' open_demoDataset = "MagellanNTK::open_demoDataset",
#' infos_dataset = "MagellanNTK::infos_dataset",
#' export_dataset = "MagellanNTK::export_dataset",
#' addDatasets = "MagellanNTK::addDatasets",
#' keepDatasets = "MagellanNTK::keepDatasets"
#' )
#' 
#' 
#' shiny::runApp(
#' mod_modalDialog(
#' title = "test modalDialog",
#' external_mod = 'mod_load_package',
#' external_mod_args = list(funcs = funcs)))
#' }
#' 
NULL

#'
#' @rdname mod_modalDialog
#'
#' @export
#'
mod_modalDialog_ui <- function(id){
  # create the namespace from the id
  ns <- NS(id)
  uiOutput(ns('dialog_UI'))
}


#' @export
#'
#' @rdname mod_modalDialog
#' 
#' @importFrom shiny moduleServer reactiveValues renderUI actionButton actionLink 
#' observeEvent showModal modalDialog modalButton reactive
#' @import shinyBS
#' @import shinyjqui
#'
mod_modalDialog_server <- function(id,
  title = NULL,
  typeWidget = 'button',
  styleWidget = NULL,
  classWidget = NULL,
  width = NULL,
  uiContent = NULL,
  external_mod = NULL,
  external_mod_args = list()){ #height auto
  
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    
    # reactiveValues object for storing current data set.
    rv <- reactiveValues(
      dataOut = NULL,
      tmp = NULL
      )
    
    output$dialog_UI <- renderUI({
      if (!is.null(uiContent) && !is.null(external_mod)){
        warning('uiContent and external_mod cannot be both instantiated at the same time.')
        return(NULL)
      } 
      
      
      if (typeWidget == 'button')
        actionButton(ns("show"), title,
          class = 'btn-danger',
          style = "font-size:60%"
        )
      else if (typeWidget == 'link')
       actionLink(ns("show"), title)
    })
    

    # # Show modal when button is clicked.
    observeEvent(input$show, {
      if (is.null(width)) {
        width <- "small"
      }
      tagList(
       tags$head(tags$style(paste0(".modal-dialog { width:", width, " }"))),
        tags$head(tags$style(".modal-dialog {z-index: 1000;}")),
        tags$head(tags$style(".modal-dialog {width: fit-content !important;}")),
        showModal(
          modalDialog(
            if (!is.null(uiContent))
              uiContent
            else
              do.call(paste0(external_mod, '_ui'), list(id = ns('test'))),
            footer = tagList(
              modalButton("Cancel"),
              actionButton(ns("ok"), "Ok") # wrapped in ns()
              )
            )
          )
      )

    })

    session$userData$clicks_observer <- observe({
      req(external_mod)
      args <- list(id = 'test')
      if (length(external_mod_args))
        args <- append(args, external_mod_args)

      rv$tmp <- do.call(paste0(external_mod, '_server'), args)
    })

    # When OK button is pressed, attempt to load the data set. If successful,
    # remove the modal. If not show another modal, but this time with a failure
    # message.
    observeEvent(input$ok, {

      if (!is.null(external_mod))
        rv$dataOut <- rv$tmp()
      else
        rv$dataOut <- Timestamp()


      removeModal()
      RemoveModule()
    })


    remove_shiny_inputs <- function(id, .input) {
      invisible(
        lapply(grep(id, names(.input), value = TRUE), function(i) {
          .subset2(.input, "impl")$.values$remove(i)
        })
      )
    }

    RemoveModule <- reactive({
      removeUI(selector = "#module_content")
      remove_shiny_inputs("my_module", input)
      session$userData$clicks_observer$destroy()
    })

    return(reactive({rv$dataOut}))
  })
}



######################################################################
# Example
########################################################################



#' @export
#' @rdname mod_modalDialog
#' @importFrom shiny fluidPage reactiveValues observeEvent reactive shinyApp
#' 
mod_modalDialog <- function(title,
  typeWidget = 'button',
  uiContent = NULL,
  external_mod = NULL,
  external_mod_args = list()
  ){
  
  ui <- fluidPage(
    wellPanel(
      mod_modalDialog_ui(id = "tbl")
    )
    )

server <- function(input, output) {
  
  rv <- reactiveValues(
    dataOut = NULL
    )
  
   res <- mod_modalDialog_server(
     id = "tbl",
     title = title,
     typeWidget = typeWidget,
     uiContent = uiContent,
     external_mod = external_mod,
     external_mod_args = external_mod_args
   )


  
  observeEvent(req(res()), {
    rv$dataOut <- res()
    print(rv$dataOut)
  })
  
  return(reactive({rv$dataOut}))
}

app <- shinyApp(ui = ui, server = server)

}
