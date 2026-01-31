

#' @title Get the last validated step before current position.
#'
#' @description This function returns the indice of the last validated step before
#' the current step.
#'
#' @param dataIn xxx
#' @param x xxxx
#' @return A `integer(1)`
#'
#' @export
#' @examples
#' NULL
GetHistory <- function(dataIn, x){
  
  history <- NULL
  
  if (x %in% c('Description', 'Save')){
    history <- NULL
  } else if (x %in% names(dataIn)){
    history <- DaparToolshed::paramshistory(dataIn[[x]])
  }
  
  return(history)
}



#' @title Get the last validated step before current position.
#'
#' @description This function returns the indice of the last validated step before
#' the current step.
#'
#' @param widgets.names xxx
#' @return A `integer(1)`
#'
#' @export
#' @examples
#' NULL
Add2History <- function(history, process, step.name, param.name, value){
  #browser()
  
  if (inherits(value, 'list'))
    value <- unlist(value)
  
  if (is.null(value))
    value <- NA
  
  history[nrow(history)+1, ] <- c(process, step.name, param.name, value)
  
  return(history)
}






#' @title Get the last validated step before current position.
#'
#' @description This function returns the indice of the last validated step before
#' the current step.
#'
#' @param widgets.names xxx
#' @return A `integer(1)`
#'
#' @export
#' @examples
#' .names <- c('A_A', 'A_Z', 'B_Q', 'B_F')
#' InitializeHistory(.names)
#' 
InitializeHistory <- function(){

  history <- setNames(data.frame(matrix(ncol = 4, nrow = 0)), 
    c('Process', 'Step', 'Parameter', 'Value'))
  # if(!is.null(widgets.names)) {
  # steps <- NULL
  # ww <- NULL
  # 
  # for (x in names(widgets.names)){
  #  
  #   basis <- unlist(strsplit(x, '_'))
  #   steps <- c(steps, basis[1])
  #   ww <- c(ww, basis[2])
  # }
 

  # for (i in 1:length(steps)){
  #   history[i,] <- c(steps[i], ww[i], NA)
  # }

  #}
      
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
#' @description Updates the status of steps in range
#'
#' @param cond xxx
#' @param range xxx
#' @param is.enabled xxx
#' @param rv xxx
#'
#' @return NA
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


#' @title Status to string
#'
#' @description Converts status code (intefer) into a readable string.
#'
#' @param i xxx
#'
#' @param title.style xxx
#'
#' @return NA
#' @export
#' @examples
#' NULL
GetStringStatus <- function(i, title.style = FALSE) {
  txt <- names(which(stepStatus == i))
  
  if (title.style) {
    txt <- paste(substr(txt, 1, 1),
      tolower(substr(txt, 2, nchar(txt))),
      sep = ""
    )
  }
  txt
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




#' @title xxx
#'
#' @description xxx
#'
#' @param steps.status xxx
#'
#' @return NA
#'
#'
#' @export
#' @examples
#' NULL
Discover_Skipped_Steps <- function(steps.status) {
  for (i in seq_len(length(steps.status))) {
    max.val <- GetMaxValidated_AllSteps(steps.status)
    if (steps.status[i] != stepStatus$VALIDATED && max.val > i) {
      steps.status[i] <- stepStatus$SKIPPED
    }
  }
  
  return(steps.status)
}




#' @title xxx
#'
#' @description xxx
#'
#' @param steps.status xxx
#' @param tag xxx
#'
#' @return NA
#'
#' @examples
#' NULL
#'
#' @export
#'
All_Skipped_tag <- function(steps.status, tag) {
  steps.status <- setNames(rep(tag, length(steps.status)), steps.status)
  
  return(steps.status)
}

#' @title xxx
#'
#' @description xxx
#'
#' @param range xxx
#' @param rv xxx
#'
#' @return NA
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


#' @title xxx
#'
#' @description xxx
#'
#' @param dataIn xxx
#' @param config xxx
#' @return A vector of boolean
#'
#' @examples
#' NULL
#' @export
#'
UpdateStepsStatus <- function(dataIn, config){

  nSteps <- length(config@steps)
  steps.names <- names(config@steps)
  steps.status <- setNames(rep(stepStatus$UNDONE, nSteps), nm = steps.names)
  
  for (i in steps.names){
    steps.status[i] <- as.numeric(i %in% names(dataIn))
  }
  
  if ('Description' %in% names(steps.status))
    steps.status['Description'] <- sum(steps.status) > 0
  
  return(steps.status)
}


#' @title xxx
#'
#' @description xxx
#'
#' @param x xxx
#' @param range xxx

#' @return A QF dataset
#'
#' @examples
#' NULL
#' @export
#'
keepAssay <- function (x, range) 
{
  x[, , range]
}



#' @title xxx
#'
#' @description xxx
#'
#' @param dataIn xxx
#' @param stepsNames xxx

#' @return A vector of QF datasets
#'
#' @examples
#' NULL
#' @export
#'
BuildData2Send <- function(dataIn, stepsNames){
  #browser()
  
  
  child.data2send <- lapply(as.list(stepsNames), function(x) NULL)
  names(child.data2send) <- stepsNames 
  
  
 
  if (!is.null(dataIn)){
    dataInNames <- names(dataIn)
    
    child.data2send <- lapply(as.list(stepsNames), 
      function(x) keepAssay(dataIn, 1:2))
    names(child.data2send) <- stepsNames 
    
    if (length(dataInNames) > 2){
      for (i in 3:length(dataInNames)){
        offset <- 1
        ind.names <- names(dataIn)[i]
        indInstepsNames <- which(ind.names == stepsNames)

        for (j in (indInstepsNames + 1):length(stepsNames))
          child.data2send[j] <- keepAssay(dataIn, 1:i)
      }
    }
    
    
  }
  
  names(child.data2send) <- stepsNames
  return (child.data2send)
}


#' @title xxx
#'
#' @description xxx
#'
#' @param stepsstatus xxx
#' @return NA
#'
#' @examples
#' NULL
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

#' @title xxx
#'
#' @description xxx
#'
#' @param is.skipped xxx
#' @param is.enabled xxx
#' @param rv xxx
#' @return NA
#'
#' @examples
#' NULL
#' @export
#'
Update_State_Screens <- function(is.skipped,
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


#' @title xxx
#'
#' @description xxx
#'
#' @param current.pos xxx
#' @param nSteps xxx
#'
#' @return NA
#'
#' @examples
#' NULL
#' @export
#'
#' @importFrom shinyjs useShinyjs hidden toggle toggleState info hide show
#' disabled inlineCSS extendShinyjs
#'
ToggleState_NavBtns <- function(current.pos, nSteps) {
  if (nSteps == 1){
    shinyjs::toggleState(id = "prevBtn", condition = FALSE)
    shinyjs::toggleState(id = "nextBtn", condition = FALSE)
  } else {
    # If the cursor is not on the first position, show the 'prevBtn'
    shinyjs::toggleState(id = "prevBtn", condition = current.pos != 1)
    
    # If the cursor is set before the last step, show the 'nextBtn'
    shinyjs::toggleState(id = "nextBtn", condition = current.pos < nSteps)
  }
  
}


#' @title xxx
#'
#' @description xxx
#'
#' @param cond xxx
#'
#' @return NA
#'
#' @export
#' @examples
#' NULL
#'
ToggleState_ResetBtn <- function(cond) {
  shinyjs::toggleState("rstBtn", condition = cond)
}