
#' @title Sidebar functions
#' @description xxx
#' @name sidebars
#' 
#' @examples
#' NULL
#' 
NULL





#' @rdname sidebars
#' @export
Insert_Dev_Sidebar <- function(){
  # dashboardSidebar(
  #tags$style(".sidebar-menu li a { height: 40px; color: grey;}"), 
  
  sidebarMenu(id = "sb_dev",
    #tags$style(".sidebar-menu li a { height: 40px; color: grey;}"), 
    minified = TRUE, collapsed = TRUE,
    #style = "position: fixed; overflow: visible;",
    # inactiveClass for import menus inactivation 
    # tags$head(tags$style(".inactiveLink {pointer-events: none; background-color: grey;}")),
    
    # Menus and submenus in sidebar
    #br(),
    menuItem("Home", 
      tabName = "Home", 
      icon = icon("home"),
      selected = TRUE),
    #hr(),
    # menuItem("Data Manager",
    #          tabName = "dataManager",
    #          icon = icon("folder"),
    #          badgeLabel = "new", 
    #          badgeColor = "green"),
    menuItem(
      h4('Dataset', style="color: lightgrey;"),
      menuSubItem(
        "Open (qf)",
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "openDataset",
        # ,badgeLabel = "new"
        # ,badgeColor = "green"
      )
      # ,menuItem("Demo dataset",
      #   tabName = "demoDataset",
      #   icon = icon("folder")
      #   # ,badgeLabel = "new"
      #   # ,badgeColor = "green"
      #   )
      ,menuSubItem(
        "Import", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "convertDataset"),
      menuSubItem(
        "Save As", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "SaveAs"),
      menuSubItem(
        "Build report (Beta)", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "BuildReport")
    ),
    #hr(),
    menuItem(
      'Workflow',
      icon = icon("home"),
      menuSubItem(
        "Load", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "openWorkflow"),
      menuSubItem(
        "Run", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "workflow"),
      menuSubItem(
        "Manual", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "Manual"),
      menuSubItem(
        "FAQ", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "faq"),
      menuSubItem(
        "Release Notes", 
        icon = img(src="www/logo-simple.png", width = 20),
        tabName = "releaseNotes")
    ),
    #hr(),
    menuItem(
      'Vizualize data',
      icon = icon("home"),
      
      menuSubItem("Info", 
        tabName = "infosDataset", 
        icon = icon("info")
        # ,badgeLabel = "new"
        # ,badgeColor = "green"
      ),
      menuSubItem("EDA", 
        tabName = "eda", 
        icon = icon("cogs")
        # ,badgeLabel = "new"
        # ,badgeColor = "green"
      )
    ),
    #hr(),
    menuItem(
      'Help', 
      icon = icon("question")
      
      
      #menuSubItem("Useful Links", tabName = "usefulLinks")
      #menuSubItem("Bug Report", tabName = "bugReport")
      # ,menuSubItem("Check for Updates", 
      #             tabName = "checkUpdates", 
      #             icon = icon("wrench"))
    )
  )
  #)
}



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