

#' @title Build an example list
#' @description Creates a list which contains example info to be
#' used to create instances of `MultiAssayExperiment` 
#' @export
#' @name build_example_datasets
#' @return A list
#' 
#' @examples
#' build_toy_example()
#' 
#' create_list_data()
#' 
#' 
NULL



create_assay_example <- function(name = 'Convert'){
  data <- data.frame(
    matrix(sample.int(30, 30), ncol = 6, 
      dimnames = list(1:5, LETTERS[1:6]))
    )
}


## ---------------------------------------------------------
## Create the vdata dataset
## ---------------------------------------------------------
create_example_data <- function(){

  lldata <- list(
    Convert = list(
      assay = create_assay_example(),
      metadata = list()
    ),
    ProcessA = list(
      assay = create_assay_example(),
      metadata = list()
    ),
    ProcessB = list(
      assay = create_assay_example(),
      metadata = list()
    )
  )

  save(lldata, file = 'data/lldata.rdata')
  lldata
}


