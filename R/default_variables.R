#' @title Default vars
#' @name default_vars
#' 



#' @rdname default_vars
#' @export
default.funcs <- function()
  list(
    convert_dataset = "MagellanNTK::convert_dataset",
    open_dataset = "MagellanNTK::open_dataset",
    open_demoDataset = "MagellanNTK::open_demoDataset",
    view_dataset = "MagellanNTK::view_dataset",
    download_dataset = "MagellanNTK::download_dataset",
    export_dataset = "MagellanNTK::export_dataset",
    build_report = "MagellanNTK::build_report",
    infos_dataset = "MagellanNTK::infos_dataset",
    addDatasets = "MagellanNTK::addDatasets",
    keepDatasets = "MagellanNTK::keepDatasets")

#' @rdname default_vars
#' @export
default.base.URL <- function()
  system.file('app/md', package = 'MagellanNTK')

#' @rdname default_vars
#' @export
default.workflow  <- function()
  list(
  name = 'PipelineDemo_Process1',
  path = system.file("workflow/PipelineDemo", package = "MagellanNTK")
)


#' @rdname default_vars
#' @description
#' left_panel = left_sidebar + width_sidebar
#' top_sidebar = top_panel
#' width_sidebar = width_process_btns
#' @export
default.layout <- list(
  top_process_sidebar = 90,
  left_process_sidebar = 89,
  width_process_sidebar = 200,
  bgcolor_process_sidebar = 'lightblue',
  
  top_process_timeline = 86,
  left_process_timeline = 0,
  bgcolor_process_timeline = 'lightblue',
  
  top_process_content = 10,
  left_process_content = 200,
  left_process_content = 100,
  bgcolor_process_content = 'yellow',
  
  
  top_process_panel = 100,
  left_process_panel = 250,
  width_process_panel = '100%',
  bgcolor_process_panel = 'white',
  
  top_process_btns = 80,
  left_process_btns = 113,
  width_process_btns = 200,
  height_process_btns = 50,
  
  top_pipeline_sidebar = 30,
  left_pipeline_sidebar = 75,
  width_pipeline_sidebar = 200,
  bgcolor_pipeline_sidebar = 'lightblue'
  
)