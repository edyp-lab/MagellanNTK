#' @title Get the version of a package installed in the local R distribution
#'
#' @param pkg The name of a package
#'
#' @return A `character()`
#'
#' @importFrom utils installed.packages
#'
#' @examples
#' GetPackageVersion("MagellanNTK")
#'
#' @export
GetPackageVersion <- function(pkg) {
  tryCatch(
    {
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
#' @return The result of the function called
#'
#' @seealso [do.call()]
#'
#' @examples
#' call_func("stats::rnorm", list(n = 10, mean = 3))
#'
#' @export
#'
call_func <- function(fname, args) {
  do.call(eval(parse(text = fname)), args)
}

#' @title Initialisation function for DT
#'
#' @return literal JavaScript code
#'
#' @examples
#' initComplete()
#'
#' @importFrom DT JS
#'
#' @export
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
#'
#' @return The extension of the given filename
#'
#' @examples
#' GetExtension("foo.xlsx")
#'
#' @export
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
#' @return NA
#'
#' @examples
#' \donttest{
#' pkgsRequire(c("stats"))
#' }
#'
#' @author Samuel Wieczorek
#'
#' @export
#'
pkgsRequire <- function(ll.deps) {
  lapply(ll.deps, function(x) {
    if (!requireNamespace(x, quietly = TRUE)) {
      txt <- paste0("Please install ", x, ": install.packages('", x, "')")
      stop(txt)
    }
  })
}
