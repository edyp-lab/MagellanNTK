#' @title Get the version of a package installed in the local R distribution
#' @param pkg The name of a package
#' @export
#' @importFrom utils installed.packages
#' @examples 
#' GetPackageVersion('MagellanNTK')
#' @return A `character()`
#' 
GetPackageVersion <- function(pkg) {
    tryCatch({
            installed.packages()[pkg, "Version"]
        },
        warning = function(w) NA,
        error = function(e) NA
    )
}

#' @title Wrapper to the function `do.call`
#'
#' @param fname The name of the function to execute
#' @param args The `list()` of its arguments
#'
#' @seealso [do.call()]
#'
#' @export
#'
#' @examples
#' call.func("stats::rnorm", list(n =10, mean=3))
#'
#' @return The result of the function called
#'
call.func <- function(fname, args) {
    do.call(eval(parse(text = fname)), args)
}



#' @title Initialisation function for DT
#' @export
#' @examples
#' initComplete()
#' @return literal JavaScript code
#' @importFrom DT JS
#' 
initComplete <- function() {
    return(DT::JS(
        "function(settings, json) {",
        "$(this.api().table().header()).css({'background-color': 'darkgrey', 'color': 'black'});",
        "}"
    ))
}


#' @title Get file extension
#'
#' @param name A complete filename
#' @export
#'
#' @examples
#' GetExtension("foo.xlsx")
#'
#' @return The extension of the given filename
#'
#'
GetExtension <- function(name) {
    temp <- unlist(strsplit(name, ".", fixed = TRUE))
    return(temp[length(temp)])
}



#' @title Loads packages
#'
#' @description Checks if a package is available to load it
#'
#' @param ll.deps A vector of `character()` which contains packages names
#'
#' @examples
#' \donttest{
#' pkgs.require(c("stats"))
#' }
#' @return NA
#' @export
#'
#' @author Samuel Wieczorek
#'
pkgs.require <- function(ll.deps) {
    lapply(ll.deps, function(x) {
        if (!requireNamespace(x, quietly = TRUE)) {
            stop(paste0("Please install ", x, ": install.packages('", x, "')"))
        }
    })
}
