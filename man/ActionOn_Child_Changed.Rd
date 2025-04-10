% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pipeline_funcs.R
\name{ActionOn_Child_Changed}
\alias{ActionOn_Child_Changed}
\title{xxx}
\usage{
ActionOn_Child_Changed(
  temp.dataIn,
  dataIn,
  steps.status,
  steps,
  steps.enabled,
  steps.skipped,
  processHasChanged,
  newValue,
  keepdataset_func,
  rv
)
}
\arguments{
\item{temp.dataIn}{xxx}

\item{dataIn}{xxx}

\item{steps.status}{xxx}

\item{steps}{A vector of names which are the names of the steps
in the process}

\item{steps.enabled}{xxx}

\item{steps.skipped}{xxx}

\item{processHasChanged}{A character(1) which is the name of the process
which has changed its return value.}

\item{newValue}{The new value given by the step which has changed.
It can be either NULL (the process has been reseted) or contain
a dataset (the process has been validated and returned the result
of its calculations)}

\item{keepdataset_func}{xxxx}
}
\value{
NA
}
\description{
# A process has changed
}
\author{
Samuel Wieczorek
}
