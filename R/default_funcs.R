#' @title
#' Datasets processing
#'
#' @description
#' The following functions are currently available:
#'
#' - `keepDatasets(object, range)` keep datasets in object which
#' are in range
#'
#' - `addDatasets(object, dataset, name)` add the 'dataset' to the
#' object (of type list)
#'
#' @details
#' The object must be of type list. Thetwo functions are implemented here for
# 'a simple list. For other dataset classes, their implementation must be part
#' of the package which uses MagellanNTK
#'
#' @param object An instance of class `MultiAssayExperiment`.
#'
#' @param range A `vector` of integers. The min of this vector must be greater
#' of equal to 0 and the max must be less or equal to the size of the object
#'
#' @param dataset An instance of class `SummarizedExperiment`.
#'
#' @param name A `character(1)` naming the new array name.
#'
#' @return An instance of class `MultiAssayExperiment`.
#'
#' @aliases keepDatasets keepDatasets,list-method
#' @aliases addDatasets addDatasets,list-method
#'
#' @name dataset-processing
#'
#' @importFrom methods setMethod new
#'
#' @examples
#' data(lldata)
#' obj.se <- lldata[[1]]
#' new.obj <- addDatasets(lldata, obj.se, 'mynewobj')
#' 
#' data(lldata123)
#' keepDatasets(lldata123, c(1,3))
#'
NULL



#' @rdname dataset-processing
#' @export
addDatasets <- function(object, dataset, name) {
  object <- c(object, newEL = dataset)
  names(object)[[length(object)]] <- name
  return(object)
}





#' @rdname dataset-processing
#' @export
#'
keepDatasets <- function(object = NULL, range = seq(length(object))) {
    if (missing(range)) {
        stop("Provide range of array to be processed")
    }

  stopifnot(!is.null(object))
  stopifnot(max(range) <= length(object))

    return(object[,,range])
}
