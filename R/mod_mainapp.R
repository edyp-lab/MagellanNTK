#' @title  mod_main_page_ui and mod_loading_page_server
#'
#' @description  A shiny Module.
#'
#' @name mod_main_page
#'
#'
#' @param id shiny id
#' @param dataIn xxx
#' @param data.name The name of the dataset. Default is 'myDataset'
#' @param session xxx
#' @param workflow.name Default is NULL,
#' @param workflow.path Default is NULL,
#' @param verbose = FALSE,
#' @param usermod = 'dev'
#'
#'
#'
#' @examples
#' if (interactive()) {
#'     shiny::runApp(mainapp())
#' }
#'
#' @return NA
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

    bs4Dash::dashboardPage(
         preloader = list(html = tagList(spin_1(), "Loading ..."), color = "#343a40"),
        # options = list(
        #     fixed = TRUE,
        #     sidebarExpandOnHover = TRUE
        # ),
        header = bs4DashNavbar(
            disable = TRUE
        ),
        sidebar = bs4DashSidebar(
          id = ns("mySidebar"),
          style = "padding-top: 0px;",
          width = size,
          # expandOnHover = TRUE,
          collapsed = TRUE,
          actionButton(inputId = ns("toggleSidebarBar"),
            label = icon("bars", width = 20),
            class = PrevNextBtnClass
          ),
          actionButton(ns("btn_eda"), label = "EDA"),
          #actionButton(ns('resetWF'), 'resetWF'),
          Insert_User_Sidebar()
          ),
        body = bs4DashBody(
          shinyjs::useShinyjs(),

             # style = "padding: 0px; overflow-y: auto;",
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
#'
#' @rdname mod_main_page
#' @export
#'
mainapp_server <- function(id,
    dataIn = reactive({NULL}),
    data.name = reactive({"myDataset"}),
    workflow.name = reactive({NULL}),
    workflow.path = reactive({NULL}),
    verbose = FALSE,
    usermod = "dev") {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        # observeEvent(input$toggleSidebarBar, {
        #     updateSidebar("mySidebar", session = session)
        # })


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
            tmp.funcs = reactive({
                NULL
            }),
            filepath = file.path(system.file("app/md",
                package = "MagellanNTK"
            ), "Presentation.Rmd")
        )


        observeEvent(id,
            {
                if (usermod == "dev") {
                    options(shiny.fullstacktrace = TRUE)
                }

                options(shiny.maxRequestSize = 1024^3)


                rv.core$current.obj <- dataIn()
                rv.core$processed.obj <- dataIn()
                if (!is.null(rv.core$current.obj)) {
                    #rv.core$current.obj.name <- metadata(rv.core$current.obj)$file
                    rv.core$current.obj.name <- data.name()
                }

                rv.core$workflow.path <- workflow.path()
                rv.core$workflow.name <- workflow.name()
                session$userData$workflow.path <- workflow.path()
                session$userData$workflow.name <- workflow.name()
                session$userData$usermod <- usermod
                session$userData$verbose <- verbose
                session$userData$funcs <- rv.core$funcs


                req(session$userData$workflow.path)
                req(session$userData$workflow.name)

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



        output$sidebar <- renderUI({
            req(usermod)

            switch(usermod,
                dev = {
                    


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


        # output$browser_UI <- renderUI({
        #   req(session$userData$usermod == 'dev')
        #   actionButton(ns('browser'), 'Console')
        # })

        # observeEvent(input$browser,{browser()})

        #observe({browser()})
        
        
        observeEvent(input$ReloadProstar, {
            shinyjs::js$reset()
        })

        rv.core$tmp.funcs <- mod_modalDialog_server("loadPkg_modal",
            title = "Default core functions",
            external_mod = "mod_load_package",
            external_mod_args = list(funcs = reactive({
                rv.core$funcs
            }))
        )


        observeEvent(req(rv.core$tmp.funcs()), {
            lapply(
                names(rv.core$tmp.funcs()),
                function(x) {
                    pkg.name <- gsub(paste0("::", x), "", rv.core$tmp.funcs()[[x]])
                    call.func(
                        "require",
                        list(
                            package = pkg.name,
                            character.only = TRUE
                        )
                    )
                    # require(pkg.name, character.only = TRUE)
                }
            )
            rv.core$funcs$funcs <- rv.core$tmp.funcs()
            session$userData$funcs <- rv.core$tmp.funcs()
        })




        output$BuildReport_UI <- renderUI({
            req(rv.core$funcs$funcs$build_report)

            call.func(
                fname = paste0(rv.core$funcs$funcs$build_report, "_server"),
                args = list(
                    id = "build_report",
                    dataIn = reactive({rv.core$processed.obj})
                )
            )

            call.func(
                fname = paste0(rv.core$funcs$funcs$build_report, "_ui"),
                args = list(id = ns("build_report"))
            )
        })

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
                    id = "open_dataset",
                    class = rv.core$funcs$class,
                    extension = rv.core$funcs$extension,
                    demo_package = rv.core$funcs$demo_package
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
                if (verbose) {
                    cat("new dataset loaded\n")
                }

                req(rv.core$result_open_dataset()$dataset)
                
                rv.core$current.obj <- rv.core$result_open_dataset()$dataset
                rv.core$current.obj.name <- rv.core$result_open_dataset()$name
                rv.core$processed.obj <- rv.core$current.obj
                rv.core$resetWF <- MagellanNTK::Timestamp()

            }
        )

        observe({
          req(rv.core$funcs$funcs$convert_dataset)
        rv.core$result_convert <- call.func(
          fname = paste0(rv.core$funcs$funcs$convert_dataset, "_server"),
          args = list(
            id = "Convert",
            #remoteReset = reactive({rv.core$resetWF}))
          remoteReset = reactive({NULL}))
        )
        })
        
        ###### Code for the convert dataset module ######
        output$open_convert_dataset_UI <- renderUI({
          req(rv.core$funcs$funcs$convert_dataset)
          
          # It is mandatory to select a pipeline first to allows the load
          # of a custom convert function
          if (is.null(rv.core$workflow.name)){
            h3('Please open a pipeline first')
          } else {
            
            call.func(
              fname = paste0(rv.core$funcs$funcs$convert_dataset, "_ui"),
              args = list(id = ns("Convert"))
            )
          }
          
        })
        
        
        
        observe_result_convert <- observeEvent(rv.core$result_convert()$dataOut()$trigger,{
            req(rv.core$result_convert()$dataOut()$value)
           
           rv.core$current.obj <- rv.core$result_convert()$dataOut()$value$data
            rv.core$current.obj.name <- rv.core$result_convert()$dataOut()$value$name
            rv.core$processed.obj <- rv.core$current.obj
            rv.core$resetWF <- MagellanNTK::Timestamp()
          })
        

        observe_result_open_workflow <- observeEvent(req(rv.core$result_open_workflow()), {

          rv.core$workflow.name <- rv.core$result_open_workflow()$wf_name
            session$userData$workflow.name <- rv.core$result_open_workflow()$wf_name

            rv.core$workflow.path <- rv.core$result_open_workflow()$path
            session$userData$workflow.path <- rv.core$result_open_workflow()$path

            # Load the package which contains the workflow
            call.func("library", list(rv.core$result_open_workflow()$pkg))
            source_wf_files(session$userData$workflow.path)
        })

        output$open_workflow_UI <- renderUI({
            # Get workflow directory
            rv.core$result_open_workflow <- open_workflow_server("wf")
            tagList(
              div(id = ns("chunk"), style = "width: 100px; height: 100px;" ),
              open_workflow_ui(ns("wf"))
            )
        })


        observe({
              rv.core$result_run_workflow <- nav_pipeline_server(
                    id = rv.core$workflow.name,
                    dataIn = reactive({rv.core$current.obj}),
                    verbose = verbose,
                    usermod = usermod,
                    remoteReset = reactive({rv.core$resetWF})
                    )
            }
        )


        # Workflow code
        output$workflow_UI <- renderUI({
            req(rv.core$workflow.name)
            tagList(
                # tags$style("z-index: 999 !important;"),
                nav_pipeline_ui(ns(basename(rv.core$workflow.name)))
            )
        })

        observe_result_run_workflow <- observeEvent(rv.core$result_run_workflow$dataOut()$value, {
          rv.core$processed.obj <- rv.core$result_run_workflow$dataOut()$value
        })


        # observeEvent(req(input$resetWF), {
        #     rv.core$resetWF <- MagellanNTK::Timestamp()
        # })

        output$tools_UI <- renderUI({
            h3("tools")
        })


        observeEvent(input$btn_eda, {
          req(rv.core$funcs$funcs)
          req(rv.core$processed.obj)

          do.call(
            eval(parse(text = paste0(rv.core$funcs$funcs$infos_dataset, "_server"))),
            list(
              id = "eda1",
              dataIn = reactive({rv.core$processed.obj})
            )
          )
          
          do.call(
            eval(parse(text = paste0(rv.core$funcs$funcs$view_dataset, "_server"))),
            list(
              id = "eda2",
              dataIn = reactive({rv.core$processed.obj})
            )
          )

            showModal(
            shinyjqui::jqui_draggable(
              modalDialog(
                  shiny::tabsetPanel(
                    id = ns("tabcard"),
               
               shiny::tabPanel(
                 title = h3("Infos", style = "margin-right: 30px;"), 
                 do.call(
                 eval(parse(text = paste0(rv.core$funcs$funcs$infos_dataset, "_ui"))),
                 list(id = ns("eda1"))
               )
                 ),
                  shiny::tabPanel(
                   title = h3("EDA"),
                   do.call(
                     eval(parse(text = paste0(rv.core$funcs$funcs$view_dataset, "_ui"))),
                     list(id = ns("eda2"))
                   )
                  )
                 ),
            title = "EDA", 
            size = "l"
          ))
          )
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

            # mod_settings_server("global_settings", obj = reactive({Exp1_R25_prot}))

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
mainapp <- function(usermod = "dev") {
    ui <- fluidPage(
        mainapp_ui("main")
    )

    server <- function(input, output, session) {
        # mainapp_server("main", funcs = funcs)
        mainapp_server("main", usermod = usermod)
    }


    app <- shiny::shinyApp(ui, server)
}
