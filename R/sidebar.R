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
