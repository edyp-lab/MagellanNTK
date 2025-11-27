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
    
    # decalage à droite de la timeline des process
    left_process_timeline = 100,
  
  # espace au-dessus des parametres des process
  top_process_timeline = 10,
  
  # espace en-dessous des parametres des process
  bottom_process_timeline = 10,
  
  # Permet de decaler le contenu de la sidebar générale vers la droite
  padding_left_nav_process_ui = 100,
  
    width_process_timeline = NULL,
    height_process_timeline = NULL,
    top_process_content = 85,
    
  # decalage du panneau general des process vers la droite
    left_process_content = 360,
  
    # espace au-dessus la timeline des process
    padding_top_process_sidebar = 10,
  
  # espace en-dessous la timeline des process
  padding_bottom_process_sidebar = 10,
  
  # espace à gauche de la timeline des process
  padding_left_process_sidebar = 100,
  
  
    padding_right_nav_process_ui = 10,
  
  # espace au-dessus de la timeline des process
  padding_top_nav_process_ui = 10,
  
    #width_process_content = "100vh",
  width_process_content = "75vw",

    top_process_panel = NULL,
    left_process_panel = NULL,
    width_process_panel = "100%",

    top_process_btns = NULL,
    left_process_btns = NULL,
    width_process_btns = NULL,
    height_process_btns = NULL,

    top_pipeline_sidebar = 0,
    left_pipeline_sidebar = 0,
  # Largeur de la sidebar generale qui contient le timeline des process 
  # et leurs parametres
    width_pipeline_sidebar = 350,
  
    line_width = 0.5,
  line_color = 'Gainsboro',
    heigth_pipeline_sidebar = 100,

    top_pipeline_timeline = 0,
    left_pipeline_timeline = 260,
    width_pipeline_timeline = "100%",
    height_pipeline_timeline = 75
)


#' @rdname default_vars
#' @param mode xxx
#' @description
#' left_panel = left_sidebar + width_sidebar
#' top_sidebar = top_panel
#' width_sidebar = width_process_btns
#' @export
default.theme <- function(mode){
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
      bgcolor_process_sidebar = "white",
      bgcolor_process_timeline = "white",
      bgcolor_process_content = "transparent",
      bgcolor_process_panel = "transparent",
      bgcolor_process_btns = "white",
      
      #couleur de la sidebar des process
      bgcolor_pipeline_sidebar = "white",
      
      bgcolor_pipeline_timeline = "white",
      edaBackgroundColor = "red"
    )
  )
  return(theme)
}

