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
#' @importFrom shinydashboard tabItem tabItems dashboardBody
#' @importFrom shinydashboardPlus dashboardSidebar dashboardPage dashboardHeader 
#' @import shinyEffects
#' @import waiter
#' 
#' @rdname mod_main_page
#'
#' @export 
#' 
mainapp_ui <- function(id, session){
  ns <- NS(id)
  
  
  # tags$head(tags$style(".sidebar {
  #   background: #F4F4F4;
  #     height: 100vh;
  #   left: 0;
  #   overflow-x: hidden;
  #   overflow-y: clip;
  #   position: absolute;
  #   top: 0;
  #   width: 360px;"))
  #div(id = "header",
  tags$body(
    #class = "skin-blue sidebar-mini control-sidebar-open",
    #style = tags$style("padding-right: 0px;"),
    options = list(sidebarExpandOnHover = TRUE),
    
    shinydashboardPlus::dashboardPage(
      preloader = list(html = tagList(spin_1(), "Loading ..."), color = "#343a40"),
      options = list(sidebarExpandOnHover = TRUE,
        fixed = TRUE),
      
      md = FALSE,
      skin = "blue",
      
      # 
      # tags$head(
      #   .path <- file.path(system.file('app/www/css', package = 'MagellanNTK'),'prostar.css'),
      #   includeCSS(.path),
      #   .path_sass <- file.path(system.file('app/www/css', package = 'MagellanNTK'),'sass-size.scss'),
      #   tags$head(tags$style(sass::sass(
      #     sass::sass_file(.path_sass),
      #     sass::sass_options(output_style = "expanded")
      #   )))
      #   ),
      
      #skin = shinythemes::shinytheme("cerulean"),
      
      # https://stackoverflow.com/questions/31711307/how-to-change-color-in-shiny-dashboard
      # orangeProstar <- "#E97D5E"
      # gradient greenblue header
      # greenblue links <- #2fa4e7
      # darker greenblue hover links <- #157ab5
      # darker greenblue titles <- #317eac
      # small titles <- #9999
      # darkest greenblue button reset+next+selected menu
      # color background arrow : #88b7d5 (bleu gris clair)
      # lightgrey #dddd
      # grey #ccc
      # bleu ceruleen #2EA8B1
      # jaune clair 'mark' #FCF8E3
      # green #468847
      # darker green #356635
      
      ##
      ## Header
      ## 
      # header = shinydashboardPlus::dashboardHeader(
      #   fixed = TRUE,
      #   title = dashboardthemes::shinyDashboardLogo(theme = "blue_gradient",
      #                                               boldText = "Prostar",
      #                                               badgeText = "v2"),
      #   leftUi = tagList(
      #   actionButton('browser', 'Console'),
      #   a(href="http://www.prostar-proteomics.org/"
      #       # img(src=base64enc::dataURI(
      #       #   file=system.file('ProstarApp/www/images', 'LogoProstarComplet.png', package='ProstarDev'), 
      #       #   mime="image/png"))
      #       ),
      #    a(href="https://github.com/edyp-lab/Prostar2",
      #       icon("github"),
      #       title="GitHub")
      #   )
      # ),
      header = shinydashboardPlus::dashboardHeader(
        fixed = TRUE,
        # titleWidth = "245px",
        # title = absolutePanel(
        #    fixed = TRUE,
        #    height = '100px',
        #    dashboardthemes::shinyDashboardLogo(theme = "blue_gradient",
        #                                        boldText = "Prostar",
        #                                        badgeText = "v2")
        #    ),
        # leftUi = tagList(
        #   tags$style(".skin-blue .main-header .navbar {background-color: rgb(20,97,117);}"),
        #   actionButton('browser', 'Console'),
        #   a(href="http://www.prostar-proteomics.org/"
        #     #       # img(src=base64enc::dataURI(
        #     #       #   file=system.file('ProstarApp/www/images', 'LogoProstarComplet.png', package='ProstarDev'), 
        #     #       #   mime="image/png"))
        #            ),
        #   a(href="https://github.com/edyp-lab/Prostar2",
        #     icon("github"),
        #     title="GitHub")
        # 
        # )
        title = 
          tagList(
            span(class = "logo-lg", 
              uiOutput(ns('left_UI')))
            
          ),
        leftUi = tagList(
          uiOutput(ns('WF_Name_UI')),
          uiOutput(ns('Dataset_Name_UI')),
          uiOutput(ns('browser_UI'))
        )
        
      ),
      sidebar = dashboardSidebar(
        
        uiOutput(ns('sidebar')),
        collapsed = TRUE
      ),
      #uiOutput(ns('sidebar')),
      # controlbar = shinydashboardPlus::dashboardControlbar(
      #   skin = "dark",
      #   shinydashboardPlus::controlbarMenu(
      #     shinydashboardPlus::controlbarItem(
      #       title = "Configure",
      #       icon = icon("desktop"),
      #       active = TRUE,
      #       actionLink(ns('browser'), 'Console'),
      #       mod_modalDialog_ui(ns('loadPkg_modal'))
      #     ),
      #     shinydashboardPlus::controlbarItem(
      #       icon = icon("paint-brush"),
      #       title = "Settings",
      #       mod_settings_ui(ns('global_settings'))
      #     )
      #     ,shinydashboardPlus::controlbarItem(
      #       icon = icon("paint-brush"),
      #       title = "Skin",
      #       shinydashboardPlus::skinSelector()
      #     )
      #   )
      #   ),
      body = dashboardBody(
        # some styling
        tags$head(
          
          tags$style(".content-wrapper {padding-right: 0px;}"),
          
          # .path <- file.path(system.file('app/www/css', package = 'MagellanNTK'),'prostar.css'),
          # includeCSS(.path),
          # .path_sass <- file.path(system.file('app/www/css', package = 'MagellanNTK'),'sass-size.scss'),
          # tags$style(sass::sass(
          #   sass::sass_file(.path_sass),
          #   sass::sass_options(output_style = "expanded")
          # )),
          
          # tags$style(
          #   rel = "stylesheet",
          #   type = "text/css",
          #   href = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/qtcreator_dark.min.css"
          # ),
          # tags$script(
          #   src = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js"
          # ),
          tags$script(
            "$(function() {
            $('.sidebar-toggle').on('click', function() {
              $('.skinSelector-widget').toggle();
            });
          });
          "
          )
        ),
        options(style = "padding-right: 0px;"),
        div(style="margin-top: 40px;", 
          # body content
          shinydashboard::tabItems(
            
            shinydashboard::tabItem(
              tabName = "Home", 
              icon = 'home',
              class = "active", 
              mod_homepage_ui(ns('home'))),
            #tabItem(tabName = "dataManager", 
            #uiOutput(ns('dataManager_UI'))),
            shinydashboard::tabItem(
              tabName = "openDataset",
              icon = 'home',
              uiOutput(ns('open_dataset_UI'))
            ),
            
            shinydashboard::tabItem(
              tabName = "convertDataset",
              icon = 'home',
              uiOutput(ns('open_convert_dataset_UI'))),
            
            shinydashboard::tabItem(
              tabName = "SaveAs", 
              icon = 'home',
              uiOutput(ns('SaveAs_UI'))),
            
            shinydashboard::tabItem(
              tabName = "infosDataset", 
              icon = 'home',
              uiOutput(ns('InfosDataset_UI'))),
            
            shinydashboard::tabItem(tabName = "eda", 
              uiOutput(ns('EDA_UI'))),
            
            shinydashboard::tabItem(tabName = "tools", 
              uiOutput(ns('tools_UI'))),
            
            shinydashboard::tabItem(tabName = "BuildReport", 
              icon = 'home',
              uiOutput(ns('BuildReport_UI'))),
            
            shinydashboard::tabItem(tabName = "openWorkflow", 
              uiOutput(ns('open_workflow_UI'))),
            
            shinydashboard::tabItem(tabName = "workflow", 
              icon = 'home',
              uiOutput(ns('workflow_UI'))),
            
            
            #tabItem(tabName = "globalSettings", mod_settings_ui(ns('global_settings'))),
            shinydashboard::tabItem(tabName = "releaseNotes", 
              uiOutput(ns('ReleaseNotes_UI'))),
            # tabItem(tabName = "checkUpdates", 
            #   mod_check_updates_ui(ns('check_updates'))),
            # shinydashboard::tabItem(tabName = "usefulLinks", 
            #   insert_md_ui(ns('links_MD'))),
            shinydashboard::tabItem(tabName = "faq", 
              insert_md_ui(ns('FAQ_MD'))),
            shinydashboard::tabItem(tabName = "Manual", 
              uiOutput(ns('manual_UI')))
            # shinydashboard::tabItem(tabName = "bugReport", 
            #   mod_bug_report_ui(ns("bug_report"))),
          )
          
        ))
      # )
    )
  )
}




#' @importFrom shiny reactive moduleServer reactiveValues observeEvent req
#' renderUI tagList h4 observeEvent actionButton h3 observe wellPanel helpText
#' @import shinyjs
#' @importFrom shinydashboardPlus dashboardSidebar dashboardPage dashboardHeader 
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
        dev = Insert_Dev_Sidebar(),
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
    
    
    #
    # Code for convert tool
    #
    observe({
      req(rv.core$funcs$funcs$convert_dataset)
      rv.core$result_convert <- call.func(
        fname = paste0(rv.core$funcs$funcs$convert_dataset, '_server'),
        args = list(id = 'Convert'))
    })
    
    
    
    output$open_convert_dataset_UI <- renderUI({
      req(rv.core$funcs$funcs$convert_dataset)
      
      call.func(
        fname = paste0(rv.core$funcs$funcs$convert_dataset, '_ui'),
        args = list(id = ns('Convert')))
    })
    
    observeEvent(rv.core$result_convert()$dataOut()$value,
      ignoreInit = TRUE, ignoreNULL = TRUE,{
      if(verbose)
        cat('Data converted')
      
      req(rv.core$result_convert()$dataOut()$value)
      
      rv.core$current.obj <- rv.core$result_convert()$dataOut()$value$data
      rv.core$current.obj.name <- rv.core$result_convert()$dataOut()$value$name
      rv.core$processed.obj <- rv.core$current.obj
      rv.core$resetWF <- rv.core$resetWF + 1
    })
    
    
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
        actionButton(ns('resetWF'), 'Reset whole Workflow'),
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