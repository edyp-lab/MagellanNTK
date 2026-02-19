

#' @title Build an example dataset
#' @export
#' @name build_example_datasets
#' @return NA
#' 
#' @examples
#' library(MultiAssayExperiment)
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
  
  lldata[[1]] <- SetHistory(lldata[[1]], InitializeHistory())
  lldata[[1]] <- SetHistory(lldata[[1]], c("Convert","Convert", "-", "Init"))
  save(lldata, file = 'data/lldata.rdata')
  
}


