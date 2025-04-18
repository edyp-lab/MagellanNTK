#' @title xxx
#' 
#' @param expr xxx
#' 
#' @export
#' 
catchToList <- function(expr) {
  val <- NULL
  myWarnings <- NULL
  myErrors <- NULL
  wHandler <- function(w) {
    myWarnings <<- c(myWarnings, w$message)
    invokeRestart("muffleWarning")
  }
  myError <- NULL
  eHandler <- function(e) {
    myError <<- c(myErrors, e$message)
    NULL
  }
  val <- tryCatch(withCallingHandlers(expr, warning = wHandler),
    error = eHandler
  )
  list(value = val, warnings = myWarnings, error = myError)
}