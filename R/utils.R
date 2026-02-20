#' @title Loads packages
#' 
#' @description Checks if a package is available to load it
#' 
#' @param ll.deps A `character()` vector which contains packages names
#' 
#' @examples 
#' NULL
#' 
#' @export
#' 
#' @author Samuel Wieczorek
#' 
pkgs.require <- function(ll.deps){
  
  if (!requireNamespace('BiocManager', quietly = TRUE)) {
    stop(paste0("Please run install.packages('BiocManager')"))
  }
  
  lapply(ll.deps, function(x) {
    if (!requireNamespace(x, quietly = TRUE)) {
      stop(paste0("Please install ", x, ": BiocManager::install('", x, "')"))
    }
  })
}



#' @title Read pipelines configuration files
#'
#' @description Read the configuration file of a pipeline and extract formatted 
#' (as a list) information
#'
#' @param path A `character()` which is the path to the directory which 
#' contains the files and directories of the pipeline.
#' @param usermod A `character()` to specifies the running mode of MagellanNTK: 
#' 'user' (default) or 'dev'. For more details, please refer to the document 
#' 'Inside MagellanNTK'
#' @examples
#' path <- system.file("workflow/PipelineDemo", package = "MagellanNTK")
#' readConfigFile(path)
#'
#' @export
#' @return A list containing the following items:
#' value <- list(
#' * funcs = tmp,
#' * verbose = get_data(lines, "verbose") == "enabled",
#' * UI_view_debugger: a `boolean` to show (TRUE) of hide (FALSE) the debugger interface
#' * UI_view_open_pipeline: a `boolean` to show (TRUE) of hide (FALSE) the UI to open a pipeline
#' * UI_view_convert_dataset a `boolean` to show (TRUE) of hide (FALSE) the UI for convert/import a dataset
#' * UI_view_change_Look_Feel a `boolean` to show (TRUE) of hide (FALSE) the UI to change the L&F
#' * UI_view_change_core_funcs a `boolean` to show (TRUE) of hide (FALSE) the UI to change the generic functions
#' * extension A `character()` which specifies the extension file allowed to be processed
#' in the pipeline,
#' * class A `character()` which specifies the class of the dataset to be processed
#' in the pipeline,
#' * package  A `character()` which specifies the package which owns the pipeline
#' * demo_package A `character()` which specifies a particular package to search
#' * URL_manual The path to the Rmd file containing the user manual of the 
#' pipeline. It can be a path to a file on the computer or a link to a file 
#' over internet.
#' * URL_ReleaseNotes The path to the Rmd file containing release notes about 
#' the pipeline. It can be a path to a file on the computer or a link to a file 
#' over internet.
#'
#' @importFrom stringr str_locate_all
#'
readConfigFile <- function(
        path,
        usermod = "user") {
    config.file <- normalizePath(file.path(path, "config.txt"))
    if (!file.exists(config.file)) {
        stop("file does not exist")
    }

    prepare_data <- function(lines, pattern) {
        record <- lines[grepl(paste0(pattern, ":"), lines)]
        if (length(record) == 1) {
            ll <- unlist(strsplit(record, split = ": ", fixed = TRUE))
            as.character(paste0(ll[2], "::", ll[1]))
        } else {
            NULL
        }
    }


    get_data <- function(lines, pattern) {
        indice <- which(grepl(paste0(pattern, ":"), lines))
        .ind <- NULL
        for (i in indice) {
            locate <- unlist(stringr::str_locate_all(pattern = pattern, lines[i]))
            start <- locate[1]
            end <- locate[2]
            if (start == 1 && end == nchar(pattern)) {
                .ind <- i
            }
        }
        record <- lines[.ind]
        if (length(record) == 1) {
            ll <- unlist(strsplit(record, split = ": ", fixed = TRUE))
            as.character(ll[2])
        } else {
            NULL
        }
    }



    lines <- readLines(config.file)

    funcs <- lapply(default.funcs(), function(x) NULL)


    tmp <- lapply(
        names(funcs),
        function(x) prepare_data(lines, x)
    )
    names(tmp) <- names(funcs)


    if (usermod == "dev") {
        value <- list(
            funcs = tmp,
            verbose = TRUE,
            UI_view_debugger = TRUE,
            UI_view_open_pipeline = FALSE,
            UI_view_convert_dataset = TRUE,
            UI_view_change_Look_Feel = TRUE,
            UI_view_change_core_funcs = FALSE,
            extension = get_data(lines, "extension"),
            class = get_data(lines, "class"),
            package = get_data(lines, "package"),
            demo_package = get_data(lines, "demo_package"),
            URL_manual = get_data(lines, "URL_manual"),
            URL_ReleaseNotes = get_data(lines, "URL_ReleaseNotes")
        )
    } else {
        value <- list(
            funcs = tmp,
            verbose = get_data(lines, "verbose") == "enabled",
            UI_view_debugger = get_data(lines, "debugger") == "disabled",
            UI_view_open_pipeline = get_data(lines, "Open_pipeline") == "disabled",
            UI_view_convert_dataset = get_data(lines, "convert_dataset") == "enabled",
            UI_view_change_Look_Feel = get_data(lines, "change_Look_Feel") == "enabled",
            UI_view_change_core_funcs = get_data(lines, "change_core_funcs") == "disabled",
            extension = get_data(lines, "extension"),
            class = get_data(lines, "class"),
            package = get_data(lines, "package"),
            demo_package = get_data(lines, "demo_package"),
            URL_manual = get_data(lines, "URL_manual"),
            URL_ReleaseNotes = get_data(lines, "URL_ReleaseNotes")
        )
    }


    return(value)
}




#' @title Get datasets from packages which owns datasets of a given class
#'
#' @param class A `character()` which is the class of the datasets one looking for
#' @param demo_package A `character()` which specifies a particular package to search
#'
#' @export
#' @examples
#' foo1 <- GetListDatasets()
#'
#' @return A `vector` in which items are the name of datasets which inherits
#' the class given in parameter
#'
GetListDatasets <- function(class = NULL, demo_package = NULL) {

    if (is.null(demo_package)) {
        ll.datasets <- NULL

        x <- data(package = .packages(all.available = TRUE))$results
        dat <- x[which(x[, "Item"] != ""), c("Package", "Item")]
        ll.datasets <- dat

        if (!is.null(class)) {
            df <- data.frame()

            for (i in seq(nrow(dat))) {
                pkg <- dat[i, "Package"]
                dataset <- dat[i, "Item"]
                tryCatch(
                    {
                        do.call(data, list(dataset, package = pkg, envir = environment()))
                        is.qf <- inherits(eval(str2expression(dataset)), class)
                        if (is.qf) {
                            df <- rbind(df, dat[i, ])
                        }
                        do.call(rm, args = list(list = dataset, envir = environment()))
                    },
                    warning = function(w) NULL,
                    error = function(e) NULL
                )
            }
            colnames(df) <- c("Package", "Item")

            ll.datasets <- df
        }
    } else {
        x <- data(package = demo_package)$results
        ll.datasets <- x[which(x[, "Item"] != ""), c("Package", "Item")]
    }

    return(ll.datasets)
}


#' @title Source workflow files
#'
#' @description This function goes into the 'R' directory of the file structure
#' of a pipeline and load into memory the source code of the R scripts (which contains 
#' the interfaces of the process)
#'
#' @param dirpath A `character()` which is the path to the directory which 
#' contains the files and directories of the pipeline.
#' @param verbose A `boolean` to indicate whether to turn off (FALSE) or ON (TRUE)
#' the verbose mode for logs.
#'
#' @examples
#' path <- system.file("workflow/PipelineDemo", package = "MagellanNTK")
#' source_wf_files(path)
#'
#' @export
#' @return NA
#'
source_wf_files <- function(
        dirpath,
        verbose = FALSE) {
    R.dirpath <- file.path(dirpath, "R")
    files <- list.files(R.dirpath, full.names = FALSE)
    for (f in files) {
        source(file.path(R.dirpath, f), local = FALSE, chdir = FALSE)
    }


    # if config.txt exists, update some funcs
    config.file <- normalizePath(file.path(dirpath, "config.txt"))
    file.exists(config.file)
}



#' @title Source ui.R, server.R ang global.R files
#'
#' @description Loads the source code of basic Shiny app files
#'
#' @examples
#' if (interactive()) {
#' source_shinyApp_files()
#' }
#'
#' @export
#' @return NA
#' 
#' 
source_shinyApp_files <- function() {
    # Checks if app can be found
    file_path_global <- system.file("app/global.R", package = "MagellanNTK")
    if (!nzchar(file_path_global)) {
        stop("Shiny app not found")
    }

    # Source add files
    ui <- server <- NULL # avoid NOTE about undefined globals
    source(file_path_global, local = FALSE)
}


#' @title Substring test
#' @param pattern A `character()`
#' @param target The `character()` to look for into the pattern
#'
#' @return A boolean
#' @export
#' @examples
#' is.substr('cde', 'abcdefghi')
#' 
is.substr <- function(pattern, target) {
    length(grep(pattern, target, fixed = TRUE)) > 0
}



#' @title Checks if a Shiny module is loaded
#' @description This function checks if the ui() and server() parts of a
#' Shiny module are available in the global environment.
#' @param base_name The name of the module (without '_ui' nor '_server' suffixes)
#'
#' @return A boolean
#' @export
#' @examples
#' path <- system.file("workflow/PipelineDemo", package = "MagellanNTK")
#' source_wf_files(path) 
#' module.exists('PipelineDemo_Process2')
#' 
module.exists <- function(base_name) {
    server.exists <- exists(paste0(base_name, "_server"),
        envir = .GlobalEnv, mode = "function"
    )
    ui.exists <- exists(paste0(base_name, "_ui"),
        envir = .GlobalEnv, mode = "function"
    )

    return(server.exists && ui.exists)
}




#' @title Hide/show a widget w.r.t a condition.
#'
#' @description
#' Wrapper for the `toggleWidget()` function of the package `shinyjs`
#'
#' @param widget The id of a `Shiny` widget
#' @param condition A `logical()` to hide/show the widget.
#'
#' @return NA
#'
#' @author Samuel Wieczorek
#'
#' @export
#' 
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show 
#' disabled inlineCSS extendShinyjs
#'
#' @examples
#' NULL
toggleWidget <- function(widget, condition) {
    tagList(
        shinyjs::useShinyjs(),
        if (isTRUE(condition)) {
            widget
        } else {
            shinyjs::disabled(widget)
        }
    )
}




#' @title
#' Timestamp in UNIX format.
#'
#' @description
#' Returns the date and time in timestamp UNIX format.
#'
#' @return A `integer()`.
#' @export
#' @examples
#' NULL
Timestamp <- function() {
  options(digits = 20,
    digits.secs = 6)
    as.numeric(Sys.time())
}




#' @title
#' Datasets processing
#'
#' @description
#' This manual page describes manipulation methods using [list] objects. In
# 'the following functions, if `object` is of class `list`, and optional array
#' index or name `i` can be specified to define the array (by name of
#' index) on which to operate.
#'
#' The following functions are currently available:
#'
#' - `keepDatasets(object, range)` keep datasets in object which
#' are in range
#'
#' - `addDatasets(object, dataset, name)` add the 'dataset' to the
#' object (of type list)
#'
#' - `Save(object, file)` stores the object to a .RData file
#'
#' @details
#' The object must be of type list. Thetwo functions are implemented here for
# 'a simple list. For other dataset classes, their implementation must be part
#' of the package which uses MagellanNTK
#'
#' @param object An object of class `list`.
#'
#' @param range A interval of integers
#'
#' @param dataset `character()` providing the base with respect to which
#'     logarithms are computed. Default is log2.
#'
#' @param name A `character()` naming the new array name.
#'
#' @return An processed object of the same class as `object`.
#'
#' @aliases keepDatasets keepDatasets,list-method
#' @aliases addDatasets addDatasets,list-method
#'
#' @name dataset-processing
#'
#' @importFrom methods setMethod new
#'
#' @examples
#' NULL
NULL
