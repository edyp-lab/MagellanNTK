

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



build_toy_example <- function(name = 'original'){
  
  data <- data.frame(
    matrix(sample.int(30, 30), ncol = 6, 
      dimnames = list(1:5, LETTERS[1:6]))
    )

  # save(data, file = 'data/data.rda')
  # return(data)
}


## ---------------------------------------------------------
## Create the vdata dataset
## ---------------------------------------------------------
create_list_data <- function(){

  lldata <- list(
    data1 = build_toy_example(), 
    data2 = build_toy_example(), 
    data3 = build_toy_example())

  save(lldata, file = 'data/lldata.rda')
  lldata
}


