#' @title Default vars
#' @name default_vars
#' @examples NULL
#' @return NA
#'


#' @rdname default_vars
#' @export
default.funcs <- function() {
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
        keepDatasets = "MagellanNTK::keepDatasets"
    )
}

#' @rdname default_vars
#' @export
default.base.URL <- function() {
    system.file("app/md", package = "MagellanNTK")
}

#' @rdname default_vars
#' @export
default.workflow <- function() {
    list(
        name = "PipelineDemo_Process1",
        path = system.file("workflow/PipelineDemo", package = "MagellanNTK")
    )
}


#' @rdname default_vars
#' @description
#' left_panel = left_sidebar + width_sidebar
#' top_sidebar = top_panel
#' width_sidebar = width_process_btns
#' @export
default.layout <- list(
    top_process_sidebar = NULL,
    left_process_sidebar = NULL,
    width_process_sidebar = NULL,
    bgcolor_process_sidebar = "yellow",
    top_process_timeline = NULL,
  
    # decalage à droite de la timeline des process
    left_process_timeline = 100,
  
  # Permet de decaler le contenu de la sidebar générale vers la droite
  padding_left_nav_process_ui = 100,
  
    width_process_timeline = NULL,
    height_process_timeline = NULL,
    bgcolor_process_timeline = "orange",
    top_process_content = 85,
    
  # decalage du panneau general des process vers la droite
    left_process_content = 360,
  
    padding_top_process_sidebar = 5,
    padding_right_nav_process_ui = 10,
  
  
  
    #width_process_content = "100vh",
  width_process_content = "75vw",
  bgcolor_process_content = "transparent",
    top_process_panel = NULL,
    left_process_panel = NULL,
    width_process_panel = "100%",
    bgcolor_process_panel = "transparent",
    top_process_btns = NULL,
    left_process_btns = NULL,
    width_process_btns = NULL,
    height_process_btns = NULL,
    bgcolor_process_btns = "transparent",
    top_pipeline_sidebar = 0,
    left_pipeline_sidebar = 0,
  # Largeur de la sidebar generale qui contient le timeline des process 
  # et leurs parametres
    width_pipeline_sidebar = 350,
  
    heigth_pipeline_sidebar = 100,
    bgcolor_pipeline_sidebar = "lightblue",
    top_pipeline_timeline = 0,
    left_pipeline_timeline = 75,
    width_pipeline_timeline = 250,
    heigth_pipeline_timeline = 100,
    bgcolor_pipeline_timeline = "lightgrey",
  
  
  edaBackgroundColor = "red"
)
