

#' @title Build an example list
#' @export
#' @name build_example_datasets
#' @return A list
#' 
#' @examples
#' create_example_data()
#' 
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
    )
  )
  save(lldata, file = 'data/lldata.rdata')
  
  
  lldata_A <- list(
    Convert = list(
      assay = create_assay_example(),
      metadata = list()
    ),
    ProcessA = list(
      assay = create_assay_example(),
      metadata = list()
    )
  )
  save(lldata_A, file = 'data/lldata_A.rdata')
  
  
  lldata_B <- list(
    Convert = list(
      assay = create_assay_example(),
      metadata = list()
    ),
    ProcessB = list(
      assay = create_assay_example(),
      metadata = list()
    )
  )
  save(lldata_B, file = 'data/lldata_B.rdata')
  
  lldata_AB <- list(
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
  save(lldata_AB, file = 'data/lldata_AB.rdata')
  
}


