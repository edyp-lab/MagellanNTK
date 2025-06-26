
#' @title Sidebar functions
#' @description xxx
#' @name sidebars
#' 
#' @examples
#' NULL
#' 
NULL


#' 
#' 
#' 
#' #' @rdname sidebars
#' #' @export
#' Insert_Dev_Sidebar <- function(){
#'   
#'   sidebarMenu(
#'     id = "sidebarmenu",
#'     menuItem(
#'       "Item 1",
#'       tabName = "item1",
#'       icon = icon("sliders")
#'     ),
#'     menuItem(
#'       "Item 2",
#'       tabName = "item2",
#'       icon = icon("id-card"),
#'       menuSubItem(
#'         text = 'toto1',
#'         tabName = 'titi1'
#'       ),
#'       menuSubItem(
#'         text = 'toto2',
#'         tabName = 'titi2'
#'       )
#'     )
#'   )
#'   
#'   
#'   # sidebarMenu(id = "sb_dev",
#'   #   #tags$style(".sidebar-menu li a { height: 40px; color: grey;}"), 
#'   #   minified = TRUE, collapsed = TRUE,
#'   #   menuItem("Home", 
#'   #     tabName = "Home", 
#'   #     icon = icon("home"),
#'   #     selected = TRUE),
#'   #   menuItem(
#'   #     h4('Dataset', style="color: lightgrey;"),
#'   #     menuSubItem(
#'   #       "Open (qf)",
#'   #       icon = img(src="www/logo-simple.png", width = 20),
#'   #       tabName = "openDataset"
#'   #     ),
#'   #   menuSubItem(
#'   #       "Import", 
#'   #       icon = img(src="www/logo-simple.png", width = 20),
#'   #       tabName = "convertDataset"),
#'   #     menuSubItem(
#'   #       "Save As", 
#'   #       icon = img(src="www/logo-simple.png", width = 20),
#'   #       tabName = "SaveAs"),
#'   #     menuSubItem(
#'   #       "Build report (Beta)", 
#'   #       icon = img(src="www/logo-simple.png", width = 20),
#'   #       tabName = "BuildReport")
#'   #   ),
#'   #   menuItem(
#'   #     'Workflow',
#'   #     icon = icon("home"),
#'   #     menuSubItem(
#'   #       "Load", 
#'   #       icon = img(src="www/logo-simple.png", width = 20),
#'   #       tabName = "openWorkflow"),
#'   #     menuSubItem(
#'   #       "Run", 
#'   #       icon = img(src="www/logo-simple.png", width = 20),
#'   #       tabName = "workflow"),
#'   #     menuSubItem(
#'   #       "Manual", 
#'   #       icon = img(src="www/logo-simple.png", width = 20),
#'   #       tabName = "Manual"),
#'   #     menuSubItem(
#'   #       "FAQ", 
#'   #       icon = img(src="www/logo-simple.png", width = 20),
#'   #       tabName = "faq"),
#'   #     menuSubItem(
#'   #       "Release Notes", 
#'   #       icon = img(src="www/logo-simple.png", width = 20),
#'   #       tabName = "releaseNotes")
#'   #   ),
#'   #   menuItem(
#'   #     'Vizualize data',
#'   #     icon = icon("home"),
#'   #     
#'   #     menuSubItem("Info", 
#'   #       tabName = "infosDataset", 
#'   #       icon = icon("info")
#'   #     ),
#'   #     menuSubItem("EDA", 
#'   #       tabName = "eda", 
#'   #       icon = icon("cogs")
#'   #     )
#'   #   )
#'   #   )
#' }
#' 


#' @rdname sidebars
#' @export
Insert_User_Sidebar <- function(){
  #dashboardSidebar(
  #tags$style(".sidebar-menu li a { height: 40px; color: grey;}"), 
  #minified = TRUE, collapsed = TRUE,
  sidebarMenu(id = "sb_user",
    #tags$style(".sidebar-menu li a { height: 40px; color: grey;}"), 
    
    #style = "position: fixed; overflow: visible;",
    # inactiveClass for import menus inactivation 
    # tags$head(tags$style(".inactiveLink {pointer-events: none; background-color: grey;}")),
    
    # Menus and submenus in sidebar
    
    menuItem("Home", 
      tabName = "Home", 
      icon = icon("home"), 
      startExpanded = TRUE),
    menuItem(
      "Dataset", 
      menuSubItem("Open file", 
        tabName = "openDataset",
        icon = img(src="www/logo-simple.png", width = 20)
      ),
      menuSubItem("Save As", 
        tabName = "SaveAs",
        icon = img(src="www/logo-simple.png", width = 20)
      ),
      menuSubItem("Import data", 
        tabName = "convertDataset",
        icon = img(src="www/logo-simple.png", width = 20)
      ),
      menuSubItem("Build report (Beta)", 
        tabName = "BuildReport",
        icon = img(src="www/logo-simple.png", width = 20)
      )
    ),
    menuItem(
      "Workflow", 
      menuSubItem("Run", 
        tabName = "workflow",
        icon = icon("cogs")
      ),
      menuSubItem("Manual", 
        tabName = "Manual",
        icon = img(src="www/logo-simple.png", width = 20)
      ),
      menuSubItem("FAQ", 
        tabName = "faq",
        icon = img(src="www/logo-simple.png", width = 20)
      ),
      menuSubItem("Release Notes", 
        tabName = "releaseNotes",
        icon = img(src="www/logo-simple.png", width = 20)
      )
    ),
    menuItem("Vizualize data", 
      menuSubItem("Info", 
        tabName = "infosDataset",
        icon = icon("cogs")
      ),
      menuSubItem("EDA", 
        tabName = "eda",
        icon = img(src="www/logo-simple.png", width = 20)
      )
    )
    
  )
  
}