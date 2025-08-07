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
    bgcolor_process_sidebar = "transparent",
    top_process_timeline = NULL,
    left_process_timeline = NULL,
    width_process_timeline = NULL,
    height_process_timeline = NULL,
    bgcolor_process_timeline = "transparent",
    top_process_content = 76,
    left_process_content = 255,
    width_process_content = "100vh",
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
    left_pipeline_sidebar = 75,
    width_pipeline_sidebar = 250,
    heigth_pipeline_sidebar = 100,
    bgcolor_pipeline_sidebar = "lightblue",
    top_pipeline_timeline = 0,
    left_pipeline_timeline = 75,
    width_pipeline_timeline = 250,
    heigth_pipeline_timeline = 100,
    bgcolor_pipeline_timeline = "transparent"
)
