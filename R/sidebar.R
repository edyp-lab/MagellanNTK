#' @title Sidebar functions
#' @description These functions content the UI code for the main sidebar in the
#' interface of MagellanNTK
#' @name sidebars
#'
#' @examples
#' NULL
#'
#' @importFrom shiny icon
#' 
#' @return Shiny UI component
#'
NULL



#' @rdname sidebars
#' @export
Insert_User_Sidebar <- function() {
  bs4SidebarMenu(
      bs4SidebarMenuItem(
        p("Home", class = "sidebarMenuItem"),
        tabName = "Home",
        icon = icon("home")
      ),
      bs4SidebarMenuItem(
        p("Dataset", class = "sidebarMenuItem"),
        icon = icon("home"),
        bs4SidebarMenuSubItem(
          p("Open file", class = "sidebarMenuSubItem"),
          tabName = "openDataset",
          icon = icon("gear")
        ),
        bs4SidebarMenuSubItem(
          p("Import", class = "sidebarMenuSubItem"),
          tabName = "convertDataset",
          icon = icon("gear")
        ),
        bs4SidebarMenuSubItem(
          p("Save As", class = "sidebarMenuSubItem"),
          tabName = "SaveAs",
          icon = icon("gear")
        )
      ),
      bs4SidebarMenuItem(
        p("Workflow", class = "sidebarMenuItem"),
        icon = icon("home"),
        # bs4SidebarMenuSubItem(
        #   p("Load", class = "sidebarMenuSubItem"),
        #   tabName = "openWorkflow",
        #   icon = icon("gear")
        # ),
        bs4SidebarMenuSubItem(
          p("Run", class = "sidebarMenuSubItem"),
          tabName = "workflow",
          icon = icon("gear")
        ),
        bs4SidebarMenuSubItem(
          p("Manual", class = "sidebarMenuSubItem"),
          tabName = "Manual",
          icon = icon("gear")
        ),
        bs4SidebarMenuSubItem(
          p("FAQ", class = "sidebarMenuSubItem"),
          tabName = "faq",
          icon = icon("gear")
        ),
        bs4SidebarMenuSubItem(
          p("Release Notes", class = "sidebarMenuSubItem"),
          tabName = "releaseNotes",
          icon = icon("gear")
        )
      )
    )
  
}
