

#' @title Get the last validated step before current position.
#'
#' @description This function returns the indice of the last validated step before
#' the current step.
#'
#' @param history A `data.frame()`
#' @param process A `character()` 
#' @param step.name A `character()` 
#' @param param.name A `character()` 
#' @param value xxx
#' @return A `data.frame()`
#'
#' @export
#' @examples
#' NULL
Add2History <- function(history, process, step.name, param.name, value){
  if (inherits(value, 'list'))
    value <- unlist(value)
  
  if (is.null(value))
    value <- NA
  
  history[nrow(history)+1, ] <- c(process, step.name, param.name, value)
  
  return(history)
}




#' @title Get the history of an assay

#' @param obj The dataset managed by MagellanNTK
#' @param name The name of a slot in the object
#' @return A `data.frame()`
#'
#' @export
#' @examples
#' NULL
GetHistory <- function(obj, name){
  
  
  history <- NULL
  browser()
  if (x == 'Description'){
    if ('Convert' %in% names(dataIn))
      history <- S4Vectors::metadata(dataIn[['Convert']])[['history']]
  } else if (x == 'Save'){
    history <- NULL
  } else if (x %in% names(dataIn)){
    history <- DaparToolshed::GetHistory(dataIn[[x]])
  }

  return(history)
}



#' @title Standardize names
#'
#' @param obj.se An instance of the class `SummarizedExperiment`
#' @param history A `data.frame()`
#'
#' @author Samuel Wieczorek
#'
#' @export
#'
#' @examples
#' data(lldata)
#' history <- GetHistory(lldata, 1)
#' history <- rbind(history, c('Example', 'Step Ex', 'ex_param', 'Ex'))
#' lldata[[1]] <- SetHistory(lldata[[1]], history)
#'
SetHistory <- function(obj.se, history){
  S4Vectors::metadata(obj.se)[['history']] <- history
  return(obj.se)
}


#' @title Get the last validated step before current position.
#'
#' @description This function returns the indice of the last validated step before
#' the current step.
#'
#' @return A `integer(1)`
#'
#' @export
#' @examples
#' InitializeHistory()
#' 
InitializeHistory <- function(){
history <- NULL
  history <- setNames(data.frame(matrix(ncol = 4, nrow = 0)),
    c('Process', 'Step', 'Parameter', 'Value'))

  return(history)
  }

#' @title Get the last validated step before current position.
#'
#' @description This function returns the indice of the last validated step before
#' the current step.
#'
#' @param pos A `integer(1)` which is the indice of the active position.
#' @param rv A `list()` which stores reactiveValues()
#'
#' @return A `integer(1)`
#'
#' @export
#' @examples
#' NULL
#'
GetMaxValidated_BeforePos <- function(
    pos = NULL,
  rv) {
  ind.max <- NULL
  
  
  if (is.null(pos)) {
    pos <- rv$current.pos
  } else if (pos == 1)
    ind.max <- NULL
  else {
    indices.validated <- unname(which(rv$steps.status[1:(pos-1)] == stepStatus$VALIDATED))
    if (length(indices.validated) > 0) 
      ind.max <- max(indices.validated)
  }
  
  return(ind.max)
}



#' @title xxx
#'
#' @description xxx
#'
#' @param steps.status A vector of strings where each item is the status of a step.
#' The length of this vector is the same of the number of steps.
#'
#' @return A `integer(1)`
#'
#' @export
#' @examples
#' NULL
GetMaxValidated_AllSteps <- function(steps.status) {
  val <- 0
  ind <- grep(stepStatus$VALIDATED, steps.status)
  if (length(ind) > 0) {
    val <- max(ind)
  }
  
  return(val)
}



#' @title xxx
#'
#' @description Updates the status of steps in a given range
#'
#' @param cond A `boolean`
#' @param range A `vector` of integers. The min of this vector muste be gerater
#' of equal to 0 and the max must be less or equal to the size of the vector
#' rv$steps.enabled
#' @param is.enabled A `boolean`
#' @param rv A `list` containing at least a slot named 'steps.enabled' which is
#' a vector of integers
#'
#' @return An updated version of the vector rv$steps.enabled
#'
#' @export
#' @examples
#' NULL
ToggleState_Screens <- function(cond,
  range,
  is.enabled,
  rv) {
  if (isTRUE(is.enabled)) {
    rv$steps.enabled[range] <- unlist(
      lapply(range, function(x) {
        cond && !(rv$steps.status[x] == stepStatus$SKIPPED)
      })
    )
  }
  return(rv$steps.enabled)
}


#' @title xxx
#'
#' @description xxx
#'
#' @param direction A `integer(1)` which is the direction of the xxx:
#' forward ('1'), backwards ('-1').
#' @param current.pos A `integer(1)` which is the current position.
#' @param len A `integer(1)` which is the number of steps in the process.
#'
#' @return A `integer(1)` which is the new current position.
#' @export
#' @examples
#' NULL
NavPage <- function(direction, current.pos, len) {
  newval <- current.pos + direction
  newval <- max(1, newval)
  newval <- min(newval, len)
  current.pos <- newval
  
  return(current.pos)
}



#' @title xxx
#'
#' @description xxx
#'
#' @param ns xxx
#' @param mode xxx
#'
#' @return A tag div for ui
#'
#'
#' @export
#' @examples
#' NULL
dataModal <- function(ns, mode) {
  # Used to show an explanation for the reset feature whether the navigation
  # mode is 'process' nor 'pipeline'.
  template_reset_modal_txt <- "This action will reset this mode. The input
    dataset will be the output of the last previous validated process and all
    further datasets will be removed"
  
  tags$div(
    id = "modal1",
    modalDialog(
      span(gsub("mode", mode, template_reset_modal_txt)),
      footer = tagList(
        actionButton(ns("closeModal"), "Cancel", class = PrevNextBtnClass),
        actionButton(ns("modal_ok"), "OK")
      )
    )
  )
}




#' @title Discover Skipped Steps
#' 
#' @param steps.status A vector of integers which reflects the status of the steps 
#' in the pipeline. Thus, the length of this vector is equal to the number of 
#' steps
#'
#' @return A vector of integers of the same length as steps.status and where skipped 
#' steps are identified with '-1'
#'
#'
#' @export
#' @examples
#' steps <- c(1, 1, 0, 1)
#' Discover_Skipped_Steps(steps)
#' 
Discover_Skipped_Steps <- function(steps.status) {
  for (i in seq_len(length(steps.status))) {
    max.val <- GetMaxValidated_AllSteps(steps.status)
    if (steps.status[i] != stepStatus$VALIDATED && max.val > i) {
      steps.status[i] <- stepStatus$SKIPPED
    }
  }
  
  return(steps.status)
}




#' @title Get the first mandatory step not validated
#'
#' @param range xxx
#' @param rv A `list` with at least two slots :
#' * mandatory: xxx
#' * steps.status: xxx
#'
#' @return An integer which is the indice of the identified step in the vector
#' rv$steps.status
#' 
#' @examples
#' NULL
#'
#' @export
#'
GetFirstMandatoryNotValidated <- function(range, rv) {
  .ind <- NULL
  first <- NULL
  first <- unlist((lapply(
    range,
    function(x) {
      rv$config@mandatory[x] && !rv$steps.status[x]
    }
  )))
  
  if (sum(first) > 0) {
    .ind <- min(which(first))
  }
  
  return(.ind)
}


#' @title Update the status of steps in a pipeline nor process.
#'
#' @param dataIn An instance of the `SummarizedExperiment` class
#' @param config An instance of the `Config` class
#' @return A vector of boolean in which each item indicates the status 
#' (VALIDATED, UNDONE, SKIPPED) of the corresponding step.
#' 
#'
#' @examples
#' NULL
#' @export
#'
UpdateStepsStatus <- function(dataIn, config){

  nSteps <- length(config@steps)
  steps.names <- names(config@steps)
  steps.status <- setNames(rep(stepStatus$UNDONE, nSteps), nm = steps.names)
  
  if(!is.null(dataIn)){
  for (i in steps.names){
    steps.status[i] <- as.numeric(i %in% names(dataIn))
  }
  
  if ('Description' %in% names(steps.status))
    steps.status['Description'] <- TRUE
  }
  
  return(steps.status)
}



#' @title Builds a vector of data
#'
#' @description The names of the slots in dataIn are a subset of the names of the steps
#' (names(stepsNames)). Each item is the result of a process and whe,n a process
#' has been validated, it creates a new slot with its own name
#'
#' @param session internal parameter
#' @param dataIn An instance of an object of type `list()`.
#' @param stepsNames A vector in which items is the name of a step in the pipeline.

#' @return A vector of the same length of the vector `stepsNames` in which each item
#' is an object (the type of object used by the pipeline). This object must have the same
#' behavior of a `list()`.
#'
#' @examples
#' data(lldata)
#' stepsNames <- c('data1', 'data2', 'data3')
#' #BuildData2Send(lldata, stepsNames)
#' 
#' 
#' stepsNames <- c('data1', 'data2', 'data3', 'data4', 'data5')
#' #BuildData2Send(lldata, stepsNames)
#' 
#' @export
#'
BuildData2Send <- function(session, dataIn, stepsNames){
  req(dataIn)

  child.data2send <- lapply(as.list(stepsNames), 
    function(x) {
      dataIn <- do.call(
        eval(parse(text = session$userData$funcs$keepDatasets)),
        list(object = dataIn, range = 1)
      )
    })
    names(child.data2send) <- stepsNames 
    
    if (length(names(dataIn)) > 1){
    for (i in 2:length(names(dataIn))){
      proc.name <- names(dataIn)[i]
      indInstepsNames <- which(proc.name == stepsNames)
      dataset <- do.call(
        eval(parse(text = session$userData$funcs$keepDatasets)),
        list(object = dataIn, range = 1:i)
      )
      for (j in (indInstepsNames):length(child.data2send))
            child.data2send[[j]] <- dataset
        }
}
    names(child.data2send) <- stepsNames
    
    
    return (child.data2send)
}


#' @title Get the position of the last validated item
#'
#' @param stepsstatus A vector of integers which reflects the status of the steps 
#' in the pipeline. Thus, the length of this vector is equal to the number of 
#' steps
#' @return An integer
#'
#' @examples
#' status <- c(1,1,1,0,0)
#' SetCurrentPosition(status)
#' 
#' 
#' status <- c(1,1,0,1, 0)
#' SetCurrentPosition(status)
#' 
#' @export
#'
SetCurrentPosition <- function(stepsstatus){
  position <- 1
  ind.last.validated <- GetMaxValidated_AllSteps(stepsstatus)
  if (ind.last.validated == 0)
    position <- 1
  else
    position <- ind.last.validated
  return(position)
}



#' @title Update the status enabled/disabled of the steps of a pipeline/process
#'
#' @param is.skipped A `boolean` indicating whether the current step of a process
#' or process of a pipeline has the status SKIPPED
#' @param is.enabled A `boolean` indicating whether the current step of a process
#' or process of a pipeline is enabled (TRUE) or not (FALSE)
#' @param rv A `list` containing at least an item named 'steps.status' which is 
#' a vector of of names for the steps of a pipeline nor a process.
#' @return A `vector` of boolean which gives the status enabled (TRUE) or 
#' disabled (FALSER) of the steps from a pipeline nor a process. 
#'
#' @examples
#' NULL
#' @export
#'
Update_State_Screens <- function(
    is.skipped,
    is.enabled,
    rv) {

  len <- length(rv$steps.status)

  if (isTRUE(is.skipped)) {
    steps.enabled <- ToggleState_Screens(
      cond = FALSE,
      range = seq_len(len),
      is.enabled = is.enabled,
      rv = rv
    )
  } else {
    # Ensure that all steps before the last validated one are disabled
    ind.max <- GetMaxValidated_AllSteps(rv$steps.status)
    if (ind.max > 0) {
      steps.enabled <- ToggleState_Screens(
        cond = FALSE,
        range = seq_len(ind.max),
        is.enabled = is.enabled,
        rv = rv
      )
    }
    
    if (ind.max < len) {
      # Enable all steps after the current one but the ones
      # after the first mandatory not validated
      firstM <- GetFirstMandatoryNotValidated(
        range = (ind.max + 1):len,
        rv = rv
      )
      if (is.null(firstM)) {
        steps.enabled <- ToggleState_Screens(
          cond = TRUE,
          range = (1 + ind.max):(len),
          is.enabled = is.enabled,
          rv = rv
        )
      } else {
        steps.enabled <- ToggleState_Screens(
          cond = TRUE,
          range = (1 + ind.max):(ind.max + firstM),
          is.enabled = is.enabled,
          rv = rv
        )
        if (ind.max + firstM < len) {
          steps.enabled <- ToggleState_Screens(
            cond = FALSE,
            range = (ind.max + firstM + 1):len,
            is.enabled = is.enabled,
            rv = rv
          )
        }
      }
    }
  }
  
  return(steps.enabled)
}


#' @title Updates the state of navigation buttons
#'
#' @description Enables/disables the buttons 'Next step' and 'Previous step'
#' wrt the current position of the cursor in the timeline.
#'
#' @param current.pos An `integer` which gives the current position of the cursor
#' in the corresponding timeline
#' @param nSteps The number of steps in the timeline
#'
#' @return NA
#'
#' @examples
#' NULL
#' 
#' @export
#'
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show
#' disabled inlineCSS extendShinyjs
#'
ToggleState_NavBtns <- function(current.pos, nSteps) {
  if (nSteps == 1){
    # on est soit sur l'etape de 'Description' soit sur l'etape de 'Save'
    shinyjs::toggleState(id = "prevBtn", condition = FALSE)
    shinyjs::toggleState(id = "nextBtn", condition = FALSE)
  } else {
    # If the cursor is not on the first position, show the 'prevBtn'
    shinyjs::toggleState(id = "prevBtn", condition = current.pos != 1)
    
    # If the cursor is set before the last step, show the 'nextBtn'
    shinyjs::toggleState(id = "nextBtn", condition = current.pos < nSteps)
  }
  
}
