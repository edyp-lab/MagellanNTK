
#' @title xxx
#' @description xxx
#' 
#' @param test xxx
#' 
#' @examples
#' NULL
#' 
#' 
#' @export
#' 
is.validated <- function(test){
  return (test == stepStatus$VALIDATED)
}

#' @title Find the packages of a function
#' 
#' @description 
#' This code is extracted from https://sebastiansauer.github.io/finds_funs/
#' 
#' @param f name of function for which the package(s) are to be identified.
#' 
#' @import tidyverse
#' 
#' @examples
#' \dontrun{
#' find_funs('filter')
#' }
#' 
#' @importFrom dplyr filter select
#' @return 
#' A dataframe with two columns:
# `package_name`: packages(s) which the function is part of (chr)
# `builtin_package`:  whether the package comes with standard R 
#  (a 'builtin'  package)
#  
#' 
#' @export
#' 
#' 
find_funs <- function(f) {
  
  
  # search for help in list of installed packages
  help_installed <- help.search(f, agrep = TRUE)
  
  # extract package name from help file
  pckg_hits <- help_installed$matches[,"Package"]
  
  if (length(pckg_hits) == 0) pckg_hits <- "No_results_found"
  
  
  # get list of built-in packages
  
  pckgs <- installed.packages()  %>% as_tibble
  pckgs %>%
    dplyr::filter(Priority %in% c("base","recommended")) %>%
    dplyr::select(Package) %>%
    distinct -> builtin_pckgs_df
  
  # check for each element of 'pckg hit' whether its built-in and loaded (via match). Then print results.
  
  results <- tibble(
    package_name = pckg_hits,
    builtin_pckage = match(pckg_hits, builtin_pckgs_df$Package, nomatch = 0) > 0,
    loaded = match(paste("package:",pckg_hits, sep = ""), search(), nomatch = 0) > 0
  )
  
  return(results)
  
}




#' @title Read pipelines configuration files
#' 
#' @description xxx
#' 
#' @param path xxx
#' @param usermod xxxxx
#' 
#' @examples
#' \dontrun{
#' path <- system.file("workflow/PipelineDemo", package = 'MagellanNTK')
#' readConfigFile(path)
#' }
#' 
#' @export
#' 
#' @importFrom stringr str_locate_all
#'
readConfigFile <- function(path,
  usermod = 'dev'){
  config.file <- normalizePath(file.path(path, 'config.txt'))
  if(!file.exists(config.file))
    stop('file does not exist')
  
  prepare_data <- function(lines, pattern){
    record <- lines[grepl(paste0(pattern, ":"), lines)]
    if(length(record) == 1){
      ll <- unlist(strsplit(record, split = ': ', fixed = TRUE))
      as.character(paste0(ll[2], '::', ll[1]))}
    else NULL
  }
  
  
  get_data <- function(lines, pattern){
    indice <- which(grepl(paste0(pattern, ":"), lines))
    .ind <- NULL
    for (i in indice){
      locate <- unlist(stringr::str_locate_all(pattern =pattern, lines[i]))
      start <- locate[1]
      end <- locate[2]
      if (start == 1 && end == nchar(pattern))
        .ind <- i
    }
    record <- lines[.ind]
    if(length(record) == 1){
      ll <- unlist(strsplit(record, split = ': ', fixed = TRUE))
      as.character(ll[2])
      }
    else NULL
  }
  
  
  
  lines <- readLines(config.file)
  
  funcs <- lapply(default.funcs(), function(x) NULL)
  
  
  tmp <- lapply(names(funcs), 
    function(x) prepare_data(lines, x))
  names(tmp) <- names(funcs)
 
  
  if (usermod == 'dev')
    value <- list(
      funcs = tmp,
      
      verbose = TRUE,
      
      UI_view_debugger = TRUE,
      UI_view_open_pipeline = FALSE,
      UI_view_convert_dataset = TRUE,
      UI_view_change_Look_Feel = TRUE,
      UI_view_change_core_funcs = FALSE,
      
      extension = get_data(lines, 'extension'),
      class = get_data(lines, 'class'),
      package = get_data(lines, 'package'),
      demo_package = get_data(lines, 'demo_package'),
      
      URL_manual = get_data(lines, 'URL_manual'),
      
      URL_ReleaseNotes = get_data(lines, 'URL_ReleaseNotes')
    )
  else 
    
  value <- list(
      funcs = tmp,
      
      verbose = get_data(lines, 'verbose') == 'enabled',
      
      UI_view_debugger = get_data(lines, 'debugger') == 'disabled',
      UI_view_open_pipeline = get_data(lines, 'Open_pipeline') == 'disabled',
      UI_view_convert_dataset = get_data(lines, 'convert_dataset') == 'enabled',
      UI_view_change_Look_Feel = get_data(lines, 'change_Look_Feel') == 'enabled',
      UI_view_change_core_funcs = get_data(lines, 'change_core_funcs') == 'disabled',
      
      extension = get_data(lines, 'extension'),
      class = get_data(lines, 'class'),
      package = get_data(lines, 'package'),
      demo_package = get_data(lines, 'demo_package'),
      
      
      URL_manual = get_data(lines, 'URL_manual'),
      URL_ReleaseNotes = get_data(lines, 'URL_ReleaseNotes')
    )


  return(value)
}




#' @title Get filtered datasets
#' 
#' @param class xxx
#' @param demo_package xxx
#' 
#' @export
#' @examples
#' foo1 <- GetListDatasets()
#' 
#' 
GetListDatasets <- function(class = NULL, demo_package = NULL){

  print(paste0("demo_package: ", demo_package))
  if (is.null(demo_package)){
  ll.datasets <- NULL
  
  x <- data(package = .packages(all.available = TRUE))$results
  dat <- x[which(x[,'Item'] != ''), c('Package', 'Item')]
  ll.datasets <- dat
  
  if (!is.null(class)){
  df <- data.frame()

  for(i in seq(nrow(dat))){
    pkg <- dat[i, 'Package']
    dataset <- dat[i, 'Item']
    tryCatch({
  
      do.call(data, list(dataset, package = pkg, envir = environment()))
      is.qf <- inherits(eval(str2expression(dataset)), class)
      if(is.qf)
        df <- rbind(df, dat[i, ])
      do.call(rm, args=list(list = dataset, envir = environment()))
    },
      warning = function(w) NULL,
      error = function(e) NULL
    )
  }
  colnames(df) <- c('Package', 'Item')

  ll.datasets <- df
  }
  } else {
    x <- data(package = demo_package)$results
    ll.datasets <- x[which(x[,'Item'] != ''), c('Package', 'Item')]
  }
  
  return(ll.datasets)
}


#' @title Source workflow files
#' 
#' @description xxx
#' 
#' @param dirpath xxx
#' @param verbose A boolean
#' 
#' @examples
#' path <- system.file("workflow/PipelineDemo", package = 'MagellanNTK')
#' source_wf_files(path)
#' 
#' @export
#'
source_wf_files <- function(dirpath, 
  verbose = FALSE){
R.dirpath <- file.path(dirpath, 'R')
files <- list.files(R.dirpath, full.names = FALSE)
for(f in files){
  if(verbose)
    cat('sourcing ', file.path(R.dirpath, f), '...')
  source(file.path(R.dirpath, f), local = FALSE, chdir = FALSE)
}


# if config.txt exists, update some funcs
config.file <- normalizePath(file.path(dirpath, 'config.txt'))
file.exists(config.file)
}



#' @title Source ui.R, server.R ang global.R files
#' 
#' @description xxx
#' 
#' @examples
#' source_shinyApp_files()
#' 
#' @export
#'
source_shinyApp_files <- function(){
# Checks if app can be found
#file_path_ui <- system.file("app/ui.R", package = "MagellanNTK")
#file_path_server <- system.file("app/server.R", package = "MagellanNTK")
file_path_global <- system.file("app/global.R", package = "MagellanNTK")
if (!nzchar(file_path_global)) 
  stop("Shiny app not found")

# Source add files
ui <- server <- NULL # avoid NOTE about undefined globals
#source(file_path_ui, local = FALSE)
#source(file_path_server, local = FALSE)
source(file_path_global, local = FALSE)

}


#' @title xxx
#' @param pattern xxx
#' @param target xxx
#' 
#' @return A boolean
#' @export
#' 
is.substr <- function(pattern, target){
  length(grep(pattern, target, fixed = TRUE)) > 0
}



#' # example code
#' #' @title Checks if the object is compliant with MagellanNTK
#' @description
#' Checks and accept the following data formats:
#' * An instance of class `MSnSet`
#' * An instance of class `MultiAssayExperiment`
#' * An instance of class `SummarizedExperiment`
#' * An instance of class `data.frame`
#' * An instance of class `matrix`
#' * A list of instances of class `MSnSet`
#' * A list of instances of class `SummarizedExperiment`
#' * A list of instances of class `data.frame`
#' * A list of instances of class `matrix`
#' 
#' 
#' @param obj xxx
#' 
#' @export
#' 
#' @examples
#' is.Magellan.compliant(data.frame())
#' 
#' 
#' ll <- list(data.frame(), data.frame())
#' is.Magellan.compliant(ll)
#' 
#' data(lldata)
#' is.Magellan.compliant(lldata)
#' 
is.Magellan.compliant <- function(obj){
  passed <- FALSE
  
  
  is.listOf <- function(object, obj.class = NULL){
    res <- NULL
    if(is.null(obj.class)){
      ll <- unlist(lapply(object, function(x) class(x)[[1]]))
      if (length(unique(ll)) == 1)
        res <- unique(ll)
    } else {
      res <- TRUE
      res <- res && inherits(object, 'list')
      res <- res && all(unlist(lapply(object, 
          function(x) class(x)[[1]] == obj.class)))
    }
    return(res)
  }
  
  
  
  passed <- passed || inherits(obj, 'MSnset') 
  passed <- passed || inherits(obj, 'QFeatures') 
  passed <- passed || inherits(obj, 'SummarizedExperiment') 
  passed <- passed || inherits(obj, 'MultiAssayExperiment') 
  passed <- passed || inherits(obj, 'data.frame')
  passed <- passed || inherits(obj, 'matrix')
  
  
  if (inherits(obj, 'list')){
    passed <- passed || is.listOf(obj, 'matrix')
    passed <- passed || is.listOf(obj, 'data.frame')
    passed <- passed || is.listOf(obj, 'SummarizedExperiment')
    passed <- passed || is.listOf(obj, 'MSnset')
  }
  
  return(passed)
}

#' @title Checks if a Shiny module exists
#' @description This function checks if the ui() and server() parts of a 
#' Shiny module are available in the global environment.
#' @param base_name The name of the module (without '_ui' nor '_server' suffixes)
#' 
#' @return A boolean
#' @export
#'
module.exists <- function(base_name){
  server.exists <- exists(paste0(base_name, '_server'), 
                          envir = .GlobalEnv, mode = "function")
  ui.exists <- exists(paste0(base_name, '_ui'), 
                      envir = .GlobalEnv, mode = "function")
  
  return(server.exists && ui.exists)
}






#' @title
#' Basic check workflow directory
#'
#' @description
#' This function checks if the directory contains well-formed directories and files
#' It must contains 3 directories: 'md', 'R' and 'data'. 
#' The 'R' directory must contains two directories:
#' * 'workflows' that contains the source files for workflows,
#' * 'other' that contains additional source files used by workflows. This directory 
#' can be empty. For each
#' file in the 'R/workflows' directory, there must exists a *.md file with the same filename
#' in the 'md' directory.
#' The 'data' directory can be empty.
#' 
#' For a full description of the nomenclature of workflows filename, please refer
#' to xxx.
#'
#' @param path A `character(1)`
#' 
#' @return A `boolean(1)`
#' 
#' @export
#' 
CheckWorkflowDir <- function(path){
  
  is.valid <- TRUE
  
  # Checks if 'path' contains the 3 directories
  dirs <- list.files(path)
  cond <- all.equal(rep(TRUE, 3), c('R', 'md', 'data') %in% dirs)
  is.valid <- is.valid && cond
  if (!cond) message('atat')
  
  dirs <- list.files(file.path(path, 'R'))
  cond <- all.equal(rep(TRUE, 2), c('workflows', 'other') %in% dirs)
  is.valid <- is.valid && cond
  if (!cond) message('atat')
  
  # Checks the correspondance between files in 'R' and 'md' directories
  files.R <- list.files(file.path(path, 'R/workflows'))
  files.md <- list.files(file.path(path, 'md'))

  # Remove the definition of root pipelines which does not have a 
  # corresponding md file (their description is contained in a separate file)
  files.R <- files.R[grepl('_', files.R)]
  
  
  files.R <- gsub('.R', '', files.R)
  files.md <- gsub('.md', '', files.md)
  n.R <- length(files.R)
  n.md <- length(files.md)
  
  cond <- n.R == n.md
  is.valid <- is.valid && cond
  if (!cond) {
    message('Lengths differ between xxx')
    } else {
      cond <- all.equal(rep(TRUE, n.R), c('R', 'md', 'data') %in% dirs)
    if (!cond) message('titi')
    is.valid <- is.valid && cond
    }

  return(is.valid) 
}



#' @title
#' Hide/show a widget w.r.t a condition.
#'
#' @description
#' Wrapper for the toggleWidget function of the package `shinyjs`
#'
#' @param widget The id of a `Shiny` widget
#' @param condition A `logical(1)` to hide/show the widget.
#'
#' @return NA
#'
#' @author Samuel Wieczorek
#'
#' @export
#' 

toggleWidget <- function(widget, condition) {
    tagList(
        shinyjs::useShinyjs(),
        if (isTRUE(condition))
            widget
        else
            shinyjs::disabled(widget)
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
#'
Timestamp <- function()
    as.numeric(Sys.time())




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
#' @param range A xxxx
#'
#' @param dataset `character(1)` providing the base with respect to which
#'     logarithms are computed. Default is log2.
#'
#' @param name A `character(1)` naming the new array name.
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
#'
NULL

## -------------------------------------------------------
##   Keep datasets from object
## -------------------------------------------------------

#' 
#' #' @rdname dataset-processing
#' keepDatasets <- function(object, range) {
#'   #stopifnot(!is.list(object, 'list'))
#'   if (missing(range))
#'     stop("Provide range of array to be processed")
#'   
#'   if (is.null(object)) {
#'     return()
#'     }
#'   
#'   object[range]
#'   }


# #' @rdname dataset-processing
# setMethod("keepDatasets",
#           "QFeatures",
#           function(object, range) {
#             if (missing(range))
#               stop("Provide range of array to be processed")
#
#             if (is.numeric(range)) range <- names(object)[[range]]
#
#             object[ , , range]
#           })




## -------------------------------------------------------
##   Add datasets to object
## -------------------------------------------------------


#' #' @rdname dataset-processing
#' addDatasets <- function(object, dataset, name) {
#'   #stopifnot(!inherits(object, 'list'))
#'   if (is.null(object))
#'     setNames(list(dataset), nm = name)
#'   else
#'     append(object, setNames(list(dataset), nm = name))
#'   }


# #' @rdname dataset-processing
# setMethod("addDatasets",
#           "QFeatures",
#           function(object, dataset) {
#             if (missing(dataset))
#               stop("Provide a dataset to add.")
#
#             if (is.numeric(range)) range <- names(object)[[range]]
#             addAssay(dataset,
#                      dataset[[length(dataset)]],
#                      name = name)
#           })

