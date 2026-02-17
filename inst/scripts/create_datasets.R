

#' @title Build an example dataset
#' @export
#' @name build_example_datasets
#' @return NA
#' 
#' @examples
#' create_example_data()
#' 
#' 
create_example_data <- function(){

  library(MultiAssayExperiment)
  ## Create array matrix and AnnotatedDataFrame to create an ExpressionSet class
  arraydat <- matrix(data = seq(1, length.out = 20), ncol = 4,
    dimnames = list(
      c("entity1", "entity2", "entity3","entity4", "entity5"),
      c("array1", "array2", "array3", "array4")
    ))
  
  ## SummarizedExperiment constructor
  exprdat <- SummarizedExperiment::SummarizedExperiment(arraydat)
  
  assayList <- list(Convert = exprdat)
  lldata <- MultiAssayExperiment(experiments = ExperimentList(assayList))
  save(lldata, file = 'data/lldata.rdata')
  
}


