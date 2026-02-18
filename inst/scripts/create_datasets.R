

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

  requireNamespace('MultiAssayExperiment')

  ## Create array matrix and AnnotatedDataFrame to create an ExpressionSet class
  arraydat <- matrix(data = rep(0, 600), nrow = 100)
  colnames(arraydat) <-c("col1", "col2", "col3", "col4", "col5", "col6")
  
  ## SummarizedExperiment constructor
  exprdat <- SummarizedExperiment::SummarizedExperiment(arraydat)
  
  assayList <- list(Convert = exprdat)
  lldata <- MultiAssayExperiment(experiments = ExperimentList(assayList))
  save(lldata, file = 'data/lldata.rdata')
  
}


