#' @title Default variables used in MagellanNTK
#'
#' @name default_vars
#'
#' @return NA
#'
#' @examples NULL
#'
NULL

#' @rdname default_vars
#'
#' @export
#'
default_funcs <- function() {
  list(
    open_dataset = "MagellanNTK::open_dataset",
    view_dataset = "MagellanNTK::view_dataset",
    download_dataset = "MagellanNTK::download_dataset",
    build_report = "MagellanNTK::build_report",
    infos_dataset = "MagellanNTK::infos_dataset",
    history_dataset = "MagellanNTK::history_dataset",
    addDatasets = "MagellanNTK::addDatasets",
    keepDatasets = "MagellanNTK::keepDatasets",
    InitializeHistory = "MagellanNTK::InitializeHistory",
    Add2History = "MagellanNTK::Add2History",
    GetHistory = "MagellanNTK::GetHistory",
    SetHistory = "MagellanNTK::SetHistory"
  )
}

#' @rdname default_vars
#'
#' @export
#'
default_base_URL <- function() {
  system.file("www/md", package = "MagellanNTK")
}

#' @rdname default_vars
#' @export
default_workflow <- function() {
  list(
    name = "PipelineDemo_Preprocessing",
    path = system.file("workflow/PipelineDemo", package = "MagellanNTK")
  )
}

#' @rdname default_vars
#'
#' @description
#' left_panel = left_sidebar + width_sidebar
#' top_sidebar = top_panel
#' width_sidebar = width_process_btns
#'
#' @export
#'
default_layout <- list(
  top_process_sidebar = NULL,
  left_process_sidebar = NULL,
  width_process_sidebar = NULL,

  # Rightward shift in the process timeline
  left_process_timeline = 100,

  # space above the process parameters
  top_process_timeline = 10,

  # space below the process parameters
  bottom_process_timeline = 10,

  # Moves the content of the main sidebar to the right
  padding_left_nav_process_ui = 100,
  width_process_timeline = NULL,
  height_process_timeline = NULL,
  top_process_content = 85,
  top_process_content_standalone = 50,

  # Shift the general process panel to the right
  left_process_content = 360,
  left_process_content_standalone = 360,

  # space above the process timeline
  padding_top_process_sidebar = 10,

  # space below the process timeline
  padding_bottom_process_sidebar = 10,

  # space to the left of the process timeline
  padding_left_process_sidebar = 100,
  padding_right_nav_process_ui = 10,

  # space above the process timeline
  padding_top_nav_process_ui = 10,
  width_process_content = "75vw",
  width_process_content_standalone = "75vw",
  top_process_panel = NULL,
  left_process_panel = NULL,
  width_process_panel = "100%",
  top_process_btns = NULL,
  left_process_btns = NULL,
  width_process_btns = NULL,
  height_process_btns = NULL,
  top_pipeline_sidebar = 0,
  left_pipeline_sidebar = 0,
  # Width of the main sidebar containing the process timeline
  # and its parameters
  width_pipeline_sidebar = 350,
  line_width = 0.5,
  line_color = "gray",
  heigth_pipeline_sidebar = 100,
  top_pipeline_timeline = 0,
  left_pipeline_timeline = 260,
  width_pipeline_timeline = "100%",
  height_pipeline_timeline = 75
)

#' @rdname default_vars
#'
#' @param mode A `character()` to specifies the running mode of MagellanNTK:
#' 'user' (default) or 'dev'.
#'
#' @export
#'
default_theme <- function(mode) {
  if (is.null(mode)) {
    mode <- "user"
  }
  if (!(mode %in% c("user", "dev"))) {
    mode <- "user"
  }
  theme <- NULL
  theme <- switch(mode,
    dev = list(
      bgcolor_process_sidebar = "yellow",
      bgcolor_process_timeline = "orange",
      bgcolor_process_content = "transparent",
      bgcolor_process_panel = "transparent",
      bgcolor_process_btns = "transparent",
      bgcolor_pipeline_sidebar = "lightblue",
      bgcolor_pipeline_timeline = "lightgrey",
      edaBackgroundColor = "red"
    ),
    user = list(
      # #F0FFFF Azure
      bgcolor_process_sidebar = "lightgrey",
      bgcolor_process_timeline = "lightgrey",
      bgcolor_process_content = "transparent",
      bgcolor_process_panel = "transparent",
      bgcolor_process_btns = "lightgrey",

      # color of the process sidebar
      bgcolor_pipeline_sidebar = "lightgrey",
      bgcolor_pipeline_timeline = "lightgrey",
      bgcolor_content_wrapper = "white"
    )
  )

  return(theme)
}
