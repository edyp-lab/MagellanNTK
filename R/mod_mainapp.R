#' @title  mod_main_page_ui and mod_loading_page_server
#' 
#' @description  A shiny Module.
#' 
#' @name mod_main_page
#' 
#' 
#' @param id shiny id
#' @param obj xxx
#' @param session xxx
#' @param workflow.name = reactive({NULL}),
#' @param workflow.path = reactive({NULL}),
#' @param verbose = FALSE,
#' @param usermod = 'dev'
#'
#' 
#' 
#' @examples
#' \dontrun{
#' shiny::runApp(mainapp())
#' }
#' 
#' 
NULL


#' @importFrom shiny NS tagList span uiOutput 
#' @import shinyjs
#' @import shinyEffects
#' @import waiter
#' 
#' @rdname mod_main_page
#'
#' @export 
#' 
mainapp_ui <- function(id, session){
  ns <- NS(id)
  
  tagList(
    dashboardPage(
      preloader = list(html = tagList(spin_1(), "Loading ..."), color = "#343a40"),
      options = list(
        fixed = TRUE),
      
      header = dashboardHeader(
        disable = TRUE
      ),
      sidebar = dashboardSidebar(
        id = ns('mySidebar'),
        style = "padding-top: 50px;",
        
        expandOnHover = TRUE,
        collapsed = TRUE,
         
        sidebarMenu(
          menuItem(
            p("Home", style = "color: white;"),
            tabName = "Home",
            icon = icon("home")
          ),
          menuItem(
            p('Dataset', style = "color: white;"),
            icon = icon("home"),
            menuSubItem(
              p("Open (qf)", style = "color: white;"),
              tabName = "openDataset",
              icon = icon("gear")
            ),
            menuSubItem(
              p("Import", style = "color: white;"),
              tabName = "convertDataset",
              icon = icon("gear")
            ),
            menuSubItem(
              p("Save As", style = "color: white;"),
              tabName = "SaveAs",
              icon = icon("gear")
            ),
            menuSubItem(
              p("Build report (Beta)", style = "color: white;"),
              tabName = "BuildReport",
              icon = icon("gear")
            )
          ),
          menuItem(
            p('Workflow', style = "color: white;"),
            icon = icon("home"),
            menuSubItem(
              p("Load", style = "color: white;"),
              tabName = "openWorkflow",
              icon = icon("gear")
            ),
            menuSubItem(
              p("Run", style = "color: white;"),
              tabName = "workflow",
              icon = icon("gear")
            ),
            menuSubItem(
              p("Manual", style = "color: white;"),
              tabName = "Manual",
              icon = icon("gear")
            ),
            menuSubItem(
              p("FAQ", style = "color: white;"),
              tabName = "faq",
              icon = icon("gear")
            ),
            menuSubItem(
              p("Release Notes", style = "color: white;"),
              tabName = "releaseNotes",
              icon = icon("gear")
            )
          ),
          menuItem(
            p('Vizualize data', style = "color: white;"),
            icon = icon("home"),
            menuSubItem(
              p("Info", style = "color: white;"),
              tabName = "infosDataset",
              icon = icon("gear")
            ),
            menuSubItem(
              p("EDA", style = "color: white;"),
              tabName = "eda",
              icon = icon("gear")
            )
          )
        )
      ),
      
      body = dashboardBody(
        style = "padding: 0px; background-color: purple; margin: 0px;",
        #style = "padding: 0px; overflow-y: auto;",
        includeCSS(file.path(system.file('www/css', package = 'MagellanNTK'),'MagellanNTK.css')),
        
        absolutePanel(
          actionButton(
            inputId = ns("toggleSidebarBar"),
            label = icon('bars', width = 20),
            class = PrevNextBtnClass
          ),
          top = 0,
          left = 20,
          draggable = FALSE,
          style = "z-index: 9999"
        ),
        tabItems(
          
          tabItem(
            tabName = "Home",
            icon = 'home',
            class = "active",
            mod_homepage_ui(ns('home'))),
          tabItem(
            tabName = "openDataset",
            icon = 'home',
            uiOutput(ns('open_dataset_UI'))
          ),
          
          tabItem(
            tabName = "convertDataset",
            icon = 'home',
            uiOutput(ns('open_convert_dataset_UI'))),
          
          tabItem(
            tabName = "SaveAs",
            icon = 'home',
            uiOutput(ns('SaveAs_UI'))),
          
          tabItem(
            tabName = "infosDataset",
            icon = 'home',
            uiOutput(ns('InfosDataset_UI'))),
          
          tabItem(tabName = "eda",
            uiOutput(ns('EDA_UI'))),
          
          tabItem(tabName = "tools",
            uiOutput(ns('tools_UI'))),
          
          tabItem(tabName = "BuildReport",
            icon = 'home',
            uiOutput(ns('BuildReport_UI'))),
          
          tabItem(tabName = "openWorkflow",
            uiOutput(ns('open_workflow_UI'))),
          
          tabItem(tabName = "workflow",
            icon = 'home',
            uiOutput(ns('workflow_UI'))),
          
          
          tabItem(tabName = "releaseNotes",
            uiOutput(ns('ReleaseNotes_UI'))),
          
          tabItem(tabName = "faq",
            insert_md_ui(ns('FAQ_MD'))),
          tabItem(tabName = "Manual",
            uiOutput(ns('manual_UI')))
        )
      )
    )
  )
}




#' @importFrom shiny reactive moduleServer reactiveValues observeEvent req
#' renderUI tagList h4 observeEvent actionButton h3 observe wellPanel helpText
#' @import shinyjs
#' @import shinyEffects
#' 
#' @rdname mod_main_page
#' @export
#' 
mainapp_server <- function(id,
  dataIn = reactive({NULL}),
  workflow.name = reactive({NULL}),
  workflow.path = reactive({NULL}),
  verbose = FALSE,
  usermod = 'dev'){
  
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    
    observeEvent(input$toggleSidebarBar, {
      updateSidebar("mySidebar", session = session)
    })
    
    rv.core <- reactiveValues(
      dataIn = NULL,
      result_convert = reactive({NULL}),
      
      result_open_dataset = reactive({NULL}),
      result_open_workflow = reactive({NULL}),
      result_run_workflow = reactive({NULL}),
      current.obj = NULL,
      current.obj.name = NULL,
      
      resetWF = 0,
      
      workflow.name = NULL,
      workflow.path = NULL,
      
      funcs = list(funcs = default.funcs()),
      tmp.funcs = reactive({NULL}),
      
      filepath = file.path(system.file('app/md', 
        package = 'MagellanNTK'),'Presentation.Rmd')
    )
    
    
    observeEvent(id, {
      
      if(usermod == 'dev')
        options(shiny.fullstacktrace = TRUE)
      
      options(shiny.maxRequestSize = 1024^3)
      
      # rv.core$current.obj <- dataIn()
      # if (!is.null(dataIn()))
      #   rv.core$current.obj.name <- 'myDataset'
      
      rv.core$current.obj <- dataIn()
      rv.core$processed.obj <- dataIn()
      if (!is.null(rv.core$current.obj))
        rv.core$current.obj.name <- metadata(rv.core$current.obj)$file
      
      rv.core$workflow.path <- workflow.path()
      rv.core$workflow.name <- workflow.name()
      session$userData$workflow.path <- workflow.path()
      session$userData$workflow.name <- workflow.name()
      session$userData$usermod <- usermod
      session$userData$verbose <- verbose
      session$userData$funcs <- rv.core$funcs
      
      
      req(session$userData$workflow.path)
      req(session$userData$workflow.name)
      
      rv.core$filepath <- file.path(session$userData$workflow.path, 'md',
        paste0(session$userData$workflow.name, '.md'))
      
      rv.core$funcs <- readConfigFile(rv.core$workflow.path)
      
      for (f in names(rv.core$funcs$funcs)){
        if(is.null(rv.core$funcs$funcs[[f]]))
          rv.core$funcs$funcs[[f]] <- default.funcs()[[f]]
      }
      session$userData$funcs <- rv.core$funcs$funcs
      
      rv.core$resetWF <- rv.core$resetWF + 1
    }, priority = 1000)
    
    
    observeEvent(req(rv.core$workflow.path), {
      rv.core$funcs <- readConfigFile(rv.core$workflow.path)
      
      for (f in names(rv.core$funcs$funcs)){
        if(is.null(rv.core$funcs$funcs[[f]]))
          rv.core$funcs$funcs[[f]] <- default.funcs()[[f]]
      }
      session$userData$funcs <- rv.core$funcs$funcs
      source_wf_files(session$userData$workflow.path)
    })
    
    
    
    output$sidebar <- renderUI({
      req(usermod)
      
      switch(usermod,
        dev = {
          sidebarMenu(
            id = "sidebarmenu",
            menuItem(
              "Item 1",
              tabName = "item1",
              icon = icon("sliders")
            ),
            menuItem(
              "Item 2",
              tabName = "item2",
              icon = icon("id-card"),
              menuSubItem(
                text = 'toto1',
                tabName = 'titi1'
              ),
              menuSubItem(
                text = 'toto2',
                tabName = 'titi2'
              )
            )
          )
          
          
          # sidebarMenu(id = "sb_dev",
          #   #tags$style(".sidebar-menu li a { height: 40px; color: grey;}"), 
          #   minified = TRUE, collapsed = TRUE,
          #   menuItem("Home", 
          #     tabName = "Home", 
          #     icon = icon("home"),
          #     selected = TRUE),
          #   menuItem(
          #     h4('Dataset', style="color: lightgrey;"),
          #     menuSubItem(
          #       "Open (qf)",
          #       icon = img(src="www/logo-simple.png", width = 20),
          #       tabName = "openDataset"
          #     ),
          #   menuSubItem(
          #       "Import", 
          #       icon = img(src="www/logo-simple.png", width = 20),
          #       tabName = "convertDataset"),
          #     menuSubItem(
          #       "Save As", 
          #       icon = img(src="www/logo-simple.png", width = 20),
          #       tabName = "SaveAs"),
          #     menuSubItem(
          #       "Build report (Beta)", 
          #       icon = img(src="www/logo-simple.png", width = 20),
          #       tabName = "BuildReport")
          #   ),
          #   menuItem(
          #     'Workflow',
          #     icon = icon("home"),
          #     menuSubItem(
          #       "Load", 
          #       icon = img(src="www/logo-simple.png", width = 20),
          #       tabName = "openWorkflow"),
          #     menuSubItem(
          #       "Run", 
          #       icon = img(src="www/logo-simple.png", width = 20),
          #       tabName = "workflow"),
          #     menuSubItem(
          #       "Manual", 
          #       icon = img(src="www/logo-simple.png", width = 20),
          #       tabName = "Manual"),
          #     menuSubItem(
          #       "FAQ", 
          #       icon = img(src="www/logo-simple.png", width = 20),
          #       tabName = "faq"),
          #     menuSubItem(
          #       "Release Notes", 
          #       icon = img(src="www/logo-simple.png", width = 20),
          #       tabName = "releaseNotes")
          #   ),
          #   menuItem(
          #     'Vizualize data',
          #     icon = icon("home"),
          #     
          #     menuSubItem("Info", 
          #       tabName = "infosDataset", 
          #       icon = icon("info")
          #     ),
          #     menuSubItem("EDA", 
          #       tabName = "eda", 
          #       icon = icon("cogs")
          #     )
          #   )
          #   )
        },
        user = Insert_User_Sidebar()
      )
    })
    
    output$left_UI <- renderUI({
      
      .txt <- if (is.null(rv.core$funcs$package)){
        "MagellanNTK"
      } else
        rv.core$funcs$package
      
      tagList(
        h4(style = "font-weight: bold;",
          paste0(.txt, ' ', GetPackageVersion(.txt)) 
        )
      )
    })
    
    
    output$WF_Name_UI <- renderUI({
      req(rv.core$workflow.name)
      h4(paste0('Workflow: ', rv.core$workflow.name), style = 'background-color: lightgrey;')
    })
    
    output$Dataset_Name_UI <- renderUI({
      req(rv.core$current.obj.name)
      h4(paste0('Dataset: ', rv.core$current.obj.name), style = 'background-color: lightgrey;')
    })
    
    
    # output$browser_UI <- renderUI({
    #   req(session$userData$usermod == 'dev')
    #   actionButton(ns('browser'), 'Console')
    # })
    
    #observeEvent(input$browser,{browser()})
    observeEvent(input$ReloadProstar, { js$reset()})
    
    rv.core$tmp.funcs <- mod_modalDialog_server('loadPkg_modal', 
      title = "Default core functions",
      external_mod = 'mod_load_package',
      external_mod_args = list(funcs = reactive({rv.core$funcs}))
    )
    
    
    observeEvent(req(rv.core$tmp.funcs()), {
      lapply(names(rv.core$tmp.funcs()), 
        function(x) {
          pkg.name <- gsub(paste0('::',x), '', rv.core$tmp.funcs()[[x]])
          require(pkg.name, character.only = TRUE)
        })
      rv.core$funcs$funcs <- rv.core$tmp.funcs()
      session$userData$funcs <- rv.core$tmp.funcs()
    })
    

    
    output$open_convert_dataset_UI <- renderUI({
      req(rv.core$funcs$funcs$convert_dataset)
      
      rv.core$result_convert <- call.func(
        fname = paste0(rv.core$funcs$funcs$convert_dataset, '_server'),
        args = list(id = 'Convert'))

      call.func(
        fname = paste0(rv.core$funcs$funcs$convert_dataset, '_ui'),
        args = list(id = ns('Convert')))
    })
    
    # observeEvent(req(rv.core$result_convert$dataOut()),
    #   ignoreInit = TRUE, ignoreNULL = TRUE,{
    #     if(verbose)
    #       cat('Data converted')
    #     req(rv.core$result_convert$dataOut()$value)
    #     rv.core$current.obj <- rv.core$result_convert$dataOut()$value$data
    #     rv.core$current.obj.name <- rv.core$result_convert$dataOut()$value$name
    #     rv.core$processed.obj <- rv.core$current.obj
    #     rv.core$resetWF <- rv.core$resetWF + 1
    #   })
    
    
    output$BuildReport_UI <- renderUI({
      
      req(rv.core$funcs$funcs$build_report)
      
      call.func(
        fname = paste0(rv.core$funcs$funcs$build_report, '_server'),
        args = list(
          id = 'build_report',
          dataIn = reactive({rv.core$processed.obj}))
      )
      
      call.func(fname = paste0(rv.core$funcs$funcs$build_report, '_ui'),
        args = list(id = ns('build_report')))
    })
    
    output$SaveAs_UI <- renderUI({
      
      req(rv.core$funcs$funcs$download_dataset)
      call.func(
        fname = paste0(rv.core$funcs$funcs$download_dataset, '_server'),
        args = list(
          id = 'download_dataset',
          dataIn = reactive({rv.core$processed.obj}))
      )
      
      call.func(fname = paste0(rv.core$funcs$funcs$download_dataset, '_ui'),
        args = list(id = ns('download_dataset')))
    })
    
    
    
    output$open_dataset_UI <- renderUI({
      req(rv.core$funcs$funcs$open_dataset)
      
      rv.core$result_open_dataset <- call.func(
        fname = paste0(rv.core$funcs$funcs$open_dataset, '_server'),
        args = list(id = 'open_dataset',
          class = rv.core$funcs$class,
          extension = rv.core$funcs$extension,
          demo_package = rv.core$funcs$demo_package)
      )
      
      call.func(fname = paste0(rv.core$funcs$funcs$open_dataset, '_ui'),
        args = list(id = ns('open_dataset')))
    })
    
    
    
    
    observeEvent(rv.core$result_open_dataset()$trigger, 
      ignoreInit = TRUE, ignoreNULL = TRUE,{
        if (verbose)
          cat('new dataset loaded\n')
        
        req(rv.core$result_open_dataset()$dataset)
        rv.core$resetWF <- rv.core$resetWF + 1
        
        rv.core$current.obj <- rv.core$result_open_dataset()$dataset
        rv.core$current.obj.name <- rv.core$result_open_dataset()$name
        rv.core$processed.obj <- rv.core$current.obj
      })
    
    
    
    
    observeEvent(req(rv.core$result_open_workflow()),{
      
      rv.core$workflow.name <- rv.core$result_open_workflow()$wf_name
      session$userData$workflow.name <- rv.core$result_open_workflow()$wf_name
      
      rv.core$workflow.path <- rv.core$result_open_workflow()$path
      session$userData$workflow.path <- rv.core$result_open_workflow()$path
      
      # Load the package which contains the workflow
      call.func('library', list(rv.core$result_open_workflow()$pkg))
      source_wf_files(session$userData$workflow.path)
    })
    
    output$open_workflow_UI <- renderUI({
      
      # Get workflow directory
      rv.core$result_open_workflow <- open_workflow_server("wf")
      open_workflow_ui(ns("wf"))
    })
    
    
    observe({
      rv.core$result_run_workflow <- nav_pipeline_server(
        id = rv.core$workflow.name,
        dataIn = reactive({rv.core$current.obj}),
        verbose = verbose,
        usermod = usermod,
        remoteReset = reactive({rv.core$resetWF})
        # wholeReset = reactive({
        #   !is.null(rv.core$result_open_dataset()$name)
        #   + !is.null(rv.core$result_convert()$dataOut()$value$name) })
      )
    }, priority = 1000)
    
    
    # Workflow code
    output$workflow_UI <- renderUI({
      req(rv.core$workflow.name)
      tagList(
        #tags$style("z-index: 999 !important;"),
        nav_pipeline_ui(ns(basename(rv.core$workflow.name)))
      )
    })
    
    observeEvent(rv.core$result_run_workflow$dataOut()$value, {
      rv.core$processed.obj <- rv.core$result_run_workflow$dataOut()$value
    })
    
    
    observeEvent(req(input$resetWF), {rv.core$resetWF <- input$resetWF})
    
    output$tools_UI <- renderUI({
      h3('tools')
    })
    
    
    
    output$InfosDataset_UI <- renderUI({
      req(rv.core$funcs$funcs)
      
      call.func(
        fname = paste0(rv.core$funcs$funcs$infos_dataset, '_server'),
        args = list(
          id = 'infos_dataset',
          dataIn = reactive({rv.core$processed.obj})))
      
      call.func(
        fname = paste0(rv.core$funcs$funcs$infos_dataset, '_ui'),
        args = list(id = ns('infos_dataset')))
    })
    
    
    output$EDA_UI <- renderUI({
      req(rv.core$funcs$funcs)
      
      call.func(
        fname = paste0(rv.core$funcs$funcs$view_dataset, '_server'),
        args = list(id = 'view_dataset',
          dataIn = reactive({rv.core$processed.obj}),
          useModal = FALSE,
          verbose = TRUE))
      
      call.func(
        fname = paste0(rv.core$funcs$funcs$view_dataset, '_ui'),
        args = list(id = ns('view_dataset')))
    })
    
    
    observe({
      req(rv.core$filepath)
      mod_homepage_server('home', rv.core$filepath)
    })
    
    
    
    output$manual_UI <- renderUI({
      req(rv.core$funcs$URL_manual)
      wellPanel(
        helpText(
          a("Click Here to Download Survey",     
            href = rv.core$funcs$URL_manual,
            target="_blank")
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
      
      #mod_settings_server("global_settings", obj = reactive({Exp1_R25_prot}))
      
      #mod_check_updates_server("check_updates")
      # insert_md_server("links_MD", 
      #   file.path(rv.core$workflow.path, 'md', "links.md"))
      # 
      insert_md_server("FAQ_MD", 
        file.path(rv.core$workflow.path, 'md', "FAQ.md"))
      #mod_bug_report_server("bug_report")
      #
    })
  })
  
}





#' @export
#' @rdname mod_main_page
#' @importFrom shiny fluidPage shinyApp
#' 
mainapp <- function(usermod = 'dev'){
  
  ui <- fluidPage(
    mainapp_ui("main")
  )
  
  server <- function(input, output, session) {
    
    #mainapp_server("main", funcs = funcs)
    mainapp_server("main", usermod = usermod)
  }
  
  
  app <- shiny::shinyApp(ui, server)
}