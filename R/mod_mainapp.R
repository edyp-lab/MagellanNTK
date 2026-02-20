#' @title  mod_main_page_ui and mod_loading_page_server
#'
#' @description  A shiny Module.
#'
#' @name mod_main_page
#'
#'
#' @param id A `character()` as the id of the Shiny module
#' @param session shiny internal
#' @param workflow.path A `character()` which is the path to the directory which 
#' contains the files and directories of the pipeline.
#' @param workflow.name A `character()` which is the name of the pipeline to
#' launch and run whithin the framework of MagellanNTK. It designs the name of 
#' a directory which contains the files and directories of the pipeline.
#' @param verbose A `boolean` to indicate whether to turn off (FALSE) or ON (TRUE)
#' the verbose mode for logs.
#' @param usermod A `character()` to specifies the running mode of MagellanNTK: 
#' 'user' (default) or 'dev'. For more details, please refer to the document 
#' 'Inside MagellanNTK'
#' @param size The width of the sidebar.in pixels
#'
#'
#'
#' @examples
#' if (interactive()) {
#'     shiny::runApp(mainapp())
#' }
#'
#' @return A shiny App
#'
NULL


#' @importFrom shiny NS tagList span uiOutput icon
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#' @import shinyEffects
#' @import waiter
#' @importFrom bs4Dash dashboardPage bs4DashNavbar bs4DashSidebar bs4SidebarMenu bs4SidebarMenuSubItem bs4SidebarMenuItem bs4DashBody
#'
#' @rdname mod_main_page
#'
#' @export
#'
mainapp_ui <- function(id, session, size = '300px') {
  ns <- NS(id)
  includeCSS(file.path(system.file("www/css", package = "MagellanNTK"), "MagellanNTK.css"))
  addResourcePath("www", system.file("app/images", package = "MagellanNTK"))
  bs4Dash::dashboardPage(
    
    preloader = list(html = tagList(spin_1(), "Loading ..."), color = "#343a40"),
    
    header = bs4Dash::bs4DashNavbar(
      disable = TRUE
    ),
    sidebar = bs4Dash::bs4DashSidebar(
      Insert_User_Sidebar(),
      id = ns("mySidebar"),
      style = "padding-top: 0px;",
      width = size,
      collapsed = TRUE,
      minified = TRUE
    ),
    controlbar= bs4Dash::bs4DashControlbar(),
    
    body = bs4Dash::bs4DashBody(
      # options = list(
      #   fixed = TRUE,
      #   sidebarExpandOnHover = FALSE   # ⬅️ Désactive l’expansion au survol,
      # ),
      tags$head(tags$style(HTML(
        paste0('
               .content-wrapper, .right-side {
               background-color: ', 
          'white' , ';
               }')))),
      includeCSS(file.path(system.file("www/css", package = "MagellanNTK"), "MagellanNTK.css")),
      bs4Dash::tabItems(
        bs4Dash::tabItem(
          tabName = "Home",
          icon = "home",
          class = "active",
          mod_homepage_ui(ns("home"))
        ),
        bs4Dash::tabItem(
          tabName = "openDataset",
          icon = "home",
          uiOutput(ns("open_dataset_UI"))
        ),
        bs4Dash::tabItem(
          tabName = "convertDataset",
          icon = "home",
          uiOutput(ns("open_convert_dataset_UI"))
        ),
        bs4Dash::tabItem(
          tabName = "SaveAs",
          icon = "home",
          uiOutput(ns("SaveAs_UI"))
        ),
        bs4Dash::tabItem(
          tabName = "tools",
          uiOutput(ns("tools_UI"))
        ),
        bs4Dash::tabItem(
          tabName = "BuildReport",
          icon = "home",
          uiOutput(ns("BuildReport_UI"))
        ),
        bs4Dash::tabItem(
          tabName = "openWorkflow",
          uiOutput(ns("open_workflow_UI"))
        ),
        bs4Dash::tabItem(
          tabName = "workflow",
          icon = "home",
          uiOutput(ns("workflow_UI"))
        ),
        bs4Dash::tabItem(
          tabName = "releaseNotes",
          uiOutput(ns("ReleaseNotes_UI"))
        ),
        bs4Dash::tabItem(
          tabName = "faq",
          insert_md_ui(ns("FAQ_MD"))
        ),
        bs4Dash::tabItem(
          tabName = "Manual",
          uiOutput(ns("manual_UI"))
        )
      )
    )
  )
  # )
}




#' @importFrom shiny reactive moduleServer reactiveValues observeEvent req
#' renderUI tagList h4 observeEvent actionButton h3 observe wellPanel helpText
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs js
#' @import shinyEffects
#' @importFrom S4Vectors metadata
#' @importFrom bs4Dash updateSidebar
#'
#' @rdname mod_main_page
#' @export
#'
mainapp_server <- function(id,
  workflow.name = reactive({NULL}),
  workflow.path = reactive({NULL}),
  verbose = FALSE,
  usermod = "user") {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    observeEvent(input$toggleSidebarBar, {
      #tags$style(".main-sidebar:hover {width: 150px !important;}")
      bs4Dash::updateSidebar("mySidebar", session = session)
    })
    
    rv.core <- reactiveValues(
      result_convert = reactive({NULL}),
      result_open_dataset = reactive({NULL}),
      result_open_workflow = reactive({NULL}),
      result_run_workflow = reactive({NULL}),
      current.obj = NULL,
      processed.obj = NULL,
      current.obj.name = NULL,
      resetWF = 0,
      workflow.name = NULL,
      workflow.path = NULL,
      funcs = list(funcs = default.funcs()),
      tmp.funcs = reactive({
        NULL
      }),
      filepath = file.path(system.file("app/md",
        package = "MagellanNTK"
      ), "Presentation.Rmd")
    )
    
    
    observeEvent(id,{
      
      req(workflow.name())
      req(workflow.path())
      
        if (usermod == "dev") {
          options(shiny.fullstacktrace = TRUE)
        }
        
        options(shiny.maxRequestSize = 1024^3)

        rv.core$workflow.path <- workflow.path()
        rv.core$workflow.name <- workflow.name()
        
        session$userData$workflow.path <- workflow.path()
        session$userData$workflow.name <- workflow.name()
        session$userData$usermod <- usermod
        session$userData$verbose <- verbose
        session$userData$funcs <- rv.core$funcs
        
        if (workflow.path() == workflow.name())
          session$userData$runmode <- 'pipeline'
        else
          session$userData$runmode <- 'process'
        
        if (session$userData$runmode == 'process'){
          rv.core$process.name <- unlist(strsplit(rv.core$workflow.name, '_'))[2]
          rv.core$pipeline.name <- unlist(strsplit(rv.core$workflow.name, '_'))[1]
        }
        
        if (session$userData$runmode == 'pipeline'){
          rv.core$process.name <- NULL
          rv.core$pipeline.name <- rv.core$workflow.name
        }

        
        
        req(session$userData$workflow.path)
        req(session$userData$workflow.name)
        
        wf_conf <- do.call(
          paste0(rv.core$workflow.name, '_conf'),
          list()
        )
        
        session$userData$wf_config <- wf_conf
        session$userData$wf_mode <- wf_conf@mode
          
          rv.core$filepath <- file.path(
            session$userData$workflow.path, "md",
            paste0(session$userData$workflow.name, ".Rmd")
          )
        
        rv.core$funcs <- readConfigFile(rv.core$workflow.path)
        
        for (f in names(rv.core$funcs$funcs)) {
          if (is.null(rv.core$funcs$funcs[[f]])) {
            rv.core$funcs$funcs[[f]] <- default.funcs()[[f]]
          }
        }
        session$userData$funcs <- rv.core$funcs$funcs
        
        # Reset of all workflow
        rv.core$resetWF <- MagellanNTK::Timestamp()
      },
      priority = 1000
    )
    
    observeEvent(req(rv.core$workflow.path), {
      rv.core$funcs <- readConfigFile(rv.core$workflow.path)
      
      for (f in names(rv.core$funcs$funcs)) {
        if (is.null(rv.core$funcs$funcs[[f]])) {
          rv.core$funcs$funcs[[f]] <- default.funcs()[[f]]
        }
      }
      session$userData$funcs <- rv.core$funcs$funcs
      source_wf_files(session$userData$workflow.path)
      rv.core$resetWF <- MagellanNTK::Timestamp()
    })
    
    
    
    output$Insert_User_Sidebar_UI <- renderUI({
      req(usermod)
      
      switch(usermod,
        dev = {  },
        user = Insert_User_Sidebar()
      )
    })
    
    output$left_UI <- renderUI({
      .txt <- if (is.null(rv.core$funcs$package)) {
        "MagellanNTK"
      } else {
        rv.core$funcs$package
      }
      
      tagList(
        h4(
          style = "font-weight: bold;",
          paste0(.txt, " ", GetPackageVersion(.txt))
        )
      )
    })
    
    
    output$WF_Name_UI <- renderUI({
      req(rv.core$workflow.name)
      
      h4(paste0("Workflow: ", rv.core$workflow.name), style = "background-color: lightgrey;")
    })
    
    output$Dataset_Name_UI <- renderUI({
      req(rv.core$current.obj.name)
      
      h4(paste0("Dataset: ", rv.core$current.obj.name), style = "background-color: lightgrey;")
    })
    

    observeEvent(input$ReloadProstar, {
      shinyjs::js$reset()
    })
    
    
    # output$BuildReport_UI <- renderUI({
    #   req(rv.core$funcs$funcs$build_report)
    #   
    #   call.func(
    #     fname = paste0(rv.core$funcs$funcs$build_report, "_server"),
    #     args = list(
    #       id = "build_report",
    #       dataIn = reactive({rv.core$processed.obj})
    #     )
    #   )
    #   
    #   call.func(
    #     fname = paste0(rv.core$funcs$funcs$build_report, "_ui"),
    #     args = list(id = ns("build_report"))
    #   )
    # })
    
    output$SaveAs_UI <- renderUI({
      req(rv.core$funcs$funcs$download_dataset)
      call.func(
        fname = paste0(rv.core$funcs$funcs$download_dataset, "_server"),
        args = list(
          id = "download_dataset",
          dataIn = reactive({rv.core$processed.obj})
        )
      )
      
      call.func(
        fname = paste0(rv.core$funcs$funcs$download_dataset, "_ui"),
        args = list(id = ns("download_dataset"))
      )
    })
    
    
    
    output$open_dataset_UI <- renderUI({
      req(rv.core$funcs$funcs$open_dataset)
      
      # It is mandatory to select a pipeline first to allows the load
      # of a custom convert function
      if (is.null(rv.core$workflow.name)){
        h3('Please open a pipeline first')
      } else {
        rv.core$result_open_dataset <- call.func(
          fname = paste0(rv.core$funcs$funcs$open_dataset, "_server"),
          args = list(
            id = "open_dataset"
          )
        )
        
        call.func(
          fname = paste0(rv.core$funcs$funcs$open_dataset, "_ui"),
          args = list(id = ns("open_dataset"))
        )
      }
    })
    
    
    
    
    observe_result_open_dataset <- observeEvent(rv.core$result_open_dataset()$trigger,
      ignoreInit = TRUE,
      ignoreNULL = TRUE,
      {
        req(rv.core$result_open_dataset()$dataset)
  
        rv.core$current.obj <- rv.core$result_open_dataset()$dataset
        rv.core$current.obj.name <- rv.core$result_open_dataset()$name
        rv.core$processed.obj <- rv.core$current.obj
        rv.core$resetWF <- MagellanNTK::Timestamp()
        
      }
    )
    
     
    observe({
      
      rv.core$result_convert <- nav_single_process_server(
        id = paste0(unlist(strsplit(rv.core$workflow.name, '_'))[1], '_Convert'),
        dataIn = reactive({NULL}),
        verbose = verbose,
        usermod = usermod,
        sendDataIfReset = FALSE
      )
    })


    ###### Code for the convert dataset module ######
    output$open_convert_dataset_UI <- renderUI({
      nav_single_process_ui(ns(paste0(unlist(strsplit(rv.core$workflow.name, '_'))[1], '_Convert')))
    })


    observe_result_convert <- observeEvent(req(rv.core$result_convert$dataOut()$trigger), {
      req(rv.core$result_convert$dataOut()$value)

      rv.core$current.obj <- rv.core$result_convert$dataOut()$value
      rv.core$current.obj.name <- rv.core$result_convert$dataOut()$name
      rv.core$processed.obj <- rv.core$current.obj
      rv.core$resetWF <- MagellanNTK::Timestamp()
    })

    observe({
      req(session$userData$wf_mode)

      switch(session$userData$wf_mode, 
        pipeline = {
          rv.core$result_run_workflow <- nav_pipeline_server(
            id = rv.core$workflow.name,
            dataIn = reactive({rv.core$current.obj}),
            verbose = verbose,
            usermod = usermod,
            remoteReset = reactive({rv.core$resetWF})
          )
        },
        process = {
  
          rv.core$result_run_workflow <- nav_single_process_server(
            id = rv.core$workflow.name,
            dataIn = reactive({rv.core$current.obj}),
            verbose = verbose,
            usermod = usermod)
        }
      )
    }
    #}
    )
    
    
    # Workflow code
    output$workflow_UI <- renderUI({
      req(session$userData$wf_mode)
      req(rv.core$workflow.name)
      tagList(
        switch(session$userData$wf_mode, 
          pipeline = nav_pipeline_ui(ns(basename(rv.core$workflow.name))),
          process = nav_single_process_ui(ns(basename(rv.core$workflow.name)))
        )
      )
    })
    
    observe_result_run_workflow <- observeEvent(rv.core$result_run_workflow$dataOut()$value, {
      rv.core$processed.obj <- rv.core$result_run_workflow$dataOut()$value
    })
    
    
    output$tools_UI <- renderUI({
      h3("tools")
    })
    
    
    observe({
      req(rv.core$filepath)
      mod_homepage_server("home", 
        mdfile = rv.core$filepath,
        dataset = reactive({rv.core$current.obj}))
    })
    
    
    
    output$manual_UI <- renderUI({
      req(rv.core$funcs$URL_manual)
      wellPanel(
        helpText(
          a("Click Here to Download Survey",
            href = rv.core$funcs$URL_manual,
            target = "_blank"
          )
        )
      )
    })
    
    
    output$ReleaseNotes_UI <- renderUI({
      req(rv.core$funcs$URL_ReleaseNotes)
      
      MagellanNTK::mod_release_notes_server("rl", rv.core$funcs$URL_ReleaseNotes)
      
      MagellanNTK::mod_release_notes_ui(ns("rl"))
    })
    
    
    observe({
      # insert_md_server("usermanual",
      #   file.path(rv.core$workflow.path, 'md', "FAQ.md"))
      #
      
      # mod_check_updates_server("check_updates")
      # insert_md_server("links_MD",
      #   file.path(rv.core$workflow.path, 'md', "links.md"))
      #
      insert_md_server(
        "FAQ_MD",
        file.path(rv.core$workflow.path, "md", "FAQ.Rmd")
      )
      # mod_bug_report_server("bug_report")
      #
    })
  })
}





#' @export
#' @rdname mod_main_page
#' @importFrom shiny fluidPage shinyApp
#'
mainapp <- function(usermod = "user") {
  ui <- fluidPage(
    mainapp_ui("main")
  )
  
  server <- function(input, output, session) {
    # mainapp_server("main", funcs = funcs)
    mainapp_server("main", usermod = usermod)
  }
  
  
  app <- shiny::shinyApp(ui, server)
}
