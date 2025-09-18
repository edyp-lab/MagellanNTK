#' @title Sidebar functions
#' @description xxx
#' @name sidebars
#'
#' @examples
#' NULL
#'
#' @return NA
#'
NULL



#' @rdname sidebars
#' @importFrom shiny icon
#' @export
Insert_User_Sidebar <- function() {
  bs4SidebarMenu(
      bs4SidebarMenuItem(
        p("Home", style = "color: white;"),
        tabName = "Home",
        icon = icon("home")
      ),
      bs4SidebarMenuItem(
        p("Dataset", style = "color: white;"),
        icon = icon("home"),
        bs4SidebarMenuSubItem(
          p("Open (qf)", style = "color: white;"),
          tabName = "openDataset",
          icon = icon("gear")
        ),
        bs4SidebarMenuSubItem(
          p("Import", style = "color: white;"),
          tabName = "convertDataset",
          icon = icon("gear")
        ),
        bs4SidebarMenuSubItem(
          p("Save As", style = "color: white;"),
          tabName = "SaveAs",
          icon = icon("gear")
        ),
        bs4SidebarMenuSubItem(
          p("Build report (Beta)", style = "color: white;"),
          tabName = "BuildReport",
          icon = icon("gear")
        )
      ),
      bs4SidebarMenuItem(
        p("Workflow", style = "color: white;"),
        icon = icon("home"),
        bs4SidebarMenuSubItem(
          p("Load", style = "color: white;"),
          tabName = "openWorkflow",
          icon = icon("gear")
        ),
        bs4SidebarMenuSubItem(
          p("Run", style = "color: white;"),
          tabName = "workflow",
          icon = icon("gear")
        ),
        bs4SidebarMenuSubItem(
          p("Manual", style = "color: white;"),
          tabName = "Manual",
          icon = icon("gear")
        ),
        bs4SidebarMenuSubItem(
          p("FAQ", style = "color: white;"),
          tabName = "faq",
          icon = icon("gear")
        ),
        bs4SidebarMenuSubItem(
          p("Release Notes", style = "color: white;"),
          tabName = "releaseNotes",
          icon = icon("gear")
        )
      )
      # bs4SidebarMenuItem(
      #       p("Vizualize data", style = "color: white;"),
      #       tabName = "eda",
      #       icon = icon("home")
      #   )
    )
  
}
