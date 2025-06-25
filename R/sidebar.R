
#' @title Sidebar functions
#' @description xxx
#' @name sidebars
#' 
#' @examples
#' NULL
#' 
NULL





#' @importFrom shinydashboard sidebarMenu menuItem menuSubItem
#' @rdname sidebars
#' @export
Insert_Dev_Sidebar <- function(){
  # dashboardSidebar(
  #tags$style(".sidebar-menu li a { height: 40px; color: grey;}"), 
  
  shinydashboard::sidebarMenu(id = "sb_dev",
    #tags$style(".sidebar-menu li a { height: 40px; color: grey;}"), 
    minified = TRUE, collapsed = TRUE,
    #style = "position: fixed; overflow: visible;",
    # inactiveClass for import menus inactivation 
    # tags$head(tags$style(".inactiveLink {pointer-events: none; background-color: grey;}")),
    
    # Menus and submenus in sidebar
    #br(),
    shinydashboard::menuItem("Home", 
      tabName = "Home", 
      icon = icon("home"),
      selected = TRUE),
    #hr(),
    # shinydashboard::menuItem("Data Manager",
    #          tabName = "dataManager",
    #          icon = icon("folder"),
    #          badgeLabel = "new", 
    #          badgeColor = "green"),
    shinydashboard::menuItem(
      h4('Dataset', style="color: lightgrey;"),
      shinydashboard::menuSubItem(
        "Open (qf)",
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "openDataset",
        # ,badgeLabel = "new"
        # ,badgeColor = "green"
      )
      # ,shinydashboard::menuItem("Demo dataset",
      #   tabName = "demoDataset",
      #   icon = icon("folder")
      #   # ,badgeLabel = "new"
      #   # ,badgeColor = "green"
      #   )
      ,shinydashboard::menuSubItem(
        "Import", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "convertDataset"),
      shinydashboard::menuSubItem(
        "Save As", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "SaveAs"),
      shinydashboard::menuSubItem(
        "Build report (Beta)", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "BuildReport")
    ),
    #hr(),
    shinydashboard::menuItem(
      'Workflow',
      icon = icon("home"),
      shinydashboard::menuSubItem(
        "Load", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "openWorkflow"),
      shinydashboard::menuSubItem(
        "Run", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "workflow"),
      shinydashboard::menuSubItem(
        "Manual", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "Manual"),
      shinydashboard::menuSubItem(
        "FAQ", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "faq"),
      shinydashboard::menuSubItem(
        "Release Notes", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "releaseNotes")
    ),
    #hr(),
    shinydashboard::menuItem(
      'Vizualize data',
      icon = icon("home"),
      
      shinydashboard::menuSubItem("Info", 
        tabName = "infosDataset", 
        icon = icon("info")
        # ,badgeLabel = "new"
        # ,badgeColor = "green"
      ),
      shinydashboard::menuSubItem("EDA", 
        tabName = "eda", 
        icon = icon("cogs")
        # ,badgeLabel = "new"
        # ,badgeColor = "green"
      )
    ),
    #hr(),
    shinydashboard::menuItem(
      'Help', 
      icon = icon("question")
      
      
      #shinydashboard::menuSubItem("Useful Links", tabName = "usefulLinks")
      #shinydashboard::menuSubItem("Bug Report", tabName = "bugReport")
      # ,shinydashboard::menuSubItem("Check for Updates", 
      #             tabName = "checkUpdates", 
      #             icon = icon("wrench"))
    )
  )
  #)
}



#' @importFrom shinydashboard sidebarMenu menuItem menuSubItem
#' @rdname sidebars
#' @export
Insert_User_Sidebar <- function(){
  #dashboardSidebar(
  #tags$style(".sidebar-menu li a { height: 40px; color: grey;}"), 
  #minified = TRUE, collapsed = TRUE,
  shinydashboard::sidebarMenu(id = "sb_user",
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