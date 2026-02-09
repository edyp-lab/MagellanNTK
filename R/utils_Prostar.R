#' @title Package version
#' #'description xxx
#' @param pkg xxx
#' @export
#' @importFrom utils help.search installed.packages maintainer 
#' packageVersion tail write.table
#' @examples NULL
#' @return NA
GetPackageVersion <- function(pkg) {
    tryCatch(
        {
            installed.packages()[pkg, "Version"]
        },
        warning = function(w) NA,
        error = function(e) NA
    )
}

#' @title Call function
#' @description xxx
#'
#' @param fname xxx
#' @param args xxx
#'
#' @seealso [do.call()]
#'
#' @export
#'
#' @examples
#' call.func("stats::rnorm", list(10))
#'
#' @return
#' NA
#'
call.func <- function(fname, args) {
    do.call(eval(parse(text = fname)), args)
}


#' @title Package version
#' #'description xxx
#' @param FUN xxx
#' @param id A `character()` as the id of the Shiny module
#' @param num The number of widgets
#' @param ... Additional parameters
#' @export
#'
#' @examples
#' NULL
#' @return NA
shinyOutput <- function(FUN, id, num, ...) {
    inputs <- character(num)
    for (i in seq_len(num)) {
        inputs[i] <- as.character(FUN(paste0(id, i), label = NULL, ...))
    }
    inputs
}


#' @title function for dynamic inputs in DT
#' #'description xxx
#' @param FUN xxx
#' @param id A `character()` as the id of the Shiny module
#' @param num The number of widgets
#' @param ... Additional parameters
#' @export
#' @examples
#' NULL
#' @return NA
shinyInput <- function(FUN, id, num, ...) {
    inputs <- character(num)
    for (i in seq_len(num)) {
        inputs[i] <- as.character(FUN(paste0(id, i), label = NULL, ...))
    }
    inputs
}




#' @title function for dynamic inputs in DT
#' @description Call this function with all the regular navbarPage() parameters,
#'  plus a text parameter, if you want to add text to the navbar
#' @param ... Additional parameters
#' @param text xxx
#' @export
#' @examples
#' NULL
#' @return NA
navbarPageWithText <- function(..., text) {
    navbar <- navbarPage(...)
    textEl <- tags$p(class = "navbar-text", text)
    navbar[[3]][[1]]$children[[1]] <- htmltools::tagAppendChild(
        navbar[[3]][[1]]$children[[1]], textEl
    )
    navbar
}


#' @title xxx
#' @description Call this function with all the regular navbarPage() parameters,
#'  plus a text parameter, if you want to add text to the navbar
#' @param ... Additional parameters
#' @param inputs xxx
#' @export
#' @examples
#' NULL
#' @return NA
navbarPageWithInputs <- function(..., inputs) {
    navbar <- navbarPage(...)
    form <- tags$form(class = "navbar-form", inputs)
    navbar[[3]][[1]]$children[[1]] <- htmltools::tagAppendChild(
        navbar[[3]][[1]]$children[[1]], form
    )
    navbar
}








#' @title xxx
#' @description
#' A short description...
#' @export
#' @examples
#' NULL
#' @return NA
launchGA <- function() {
    if (system2("hostname") == "prabig-prostar2") {
        tags$head(includeScript("www/google-analytics.js"))
    } else {
        # tags$head(includeScript("www/google-analytics-ProstarZeroInstall.js"))
    }
}


#' @title xxx
#' @description
#' A short description...
#' @export
#' @examples
#' NULL
#' @return NA
initComplete <- function() {
    return(JS(
        "function(settings, json) {",
        "$(this.api().table().header()).css({'background-color': 'darkgrey', 'color': 'black'});",
        "}"
    ))
} # comonFunc.R de prostar 2.0


#' @title Get file extension
#'
#' @param name A complete filename
#'
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
