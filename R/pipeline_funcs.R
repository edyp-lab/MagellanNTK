

#' @title xxx
#'
#' @description
#' # A process has changed
# Either it has returned a value (newValue contains a dataset)
# or it has been reseted (newValue is NULL)

#'
#' @param temp.dataIn xxx
#' @param dataIn xxx
#' @param steps.status xxx
#' @param steps A vector of names which are the names of the steps
#' in the process
#' @param steps.enabled xxx
#' @param steps.skipped xxx
#' @param processHasChanged A character(1) which is the name of the process
#' which has changed its return value.
#' @param newValue The new value given by the step which has changed.
#' It can be either NULL (the process has been reseted) or contain
#' a dataset (the process has been validated and returned the result
#' of its calculations)
#' @param keepdataset_func xxxx
#'
#' @author Samuel Wieczorek
#'
#' @export
#'
#' @return NA
#' 
#'
ActionOn_Child_Changed <- function(
    temp.dataIn,
  dataIn,
  steps.status,
  steps,
  steps.enabled,
  steps.skipped,
  processHasChanged,
  newValue,
  keepdataset_func,
  rv) {


  # Indice of the dataset in the object
  # If the original length is not 1, then this indice is different
  # than the above one
  ind.processHasChanged <- which(names(steps) == processHasChanged)
  validatedBeforeReset <- names(dataIn)[length(names(dataIn))] == processHasChanged
  
  len <- length(steps)
  
  #browser()
  if (is.null(newValue)) {
    # A process has been reseted (it has returned a NULL value)
    
    
    
    validated.steps <- which(steps.status == stepStatus$VALIDATED)
    if (length(validated.steps) > 0) {
      ind.last.validated <- max(validated.steps)
    } else {
      ind.last.validated <- 0
    }
    
   #browser()
    
    # There is no validated step (the first step has been reseted)
    if (ind.last.validated == 0) {
      dataIn <- NULL
    } else if (ind.last.validated == 1){
      
      dataIn <- temp.dataIn
      
    } else {
      # Check if the reseted process has been validated before reset or not
      if (isTRUE(validatedBeforeReset)){
        dataIn <- call.func(
          fname = keepdataset_func,
          args = list(object = dataIn,
            range = seq_len(length(dataIn)-1))
        )
      } else {
        dataIn <- temp.dataIn
      }
      
      # browser()
      # name.last.validated <- steps[ind.last.validated]
      # dataIn.ind.last.validated <- which(names(dataIn) == names(name.last.validated))
      # #browser()
      # dataIn <- call.func(
      #   fname = keepdataset_func,
      #   args = list(object = dataIn,
      #     range = seq_len(dataIn.ind.last.validated))
      # )
    }
   
   # One take the last validated step (before the one
   # corresponding to processHasChanges
   # but it is straightforward because we just updates rv$status
   steps.status[ind.processHasChanged:len] <- stepStatus$UNDONE
   
   #All the following processes (after the one which has changed) are disabled
   steps.enabled[(ind.processHasChanged + 1):len] <- FALSE
   
   #browser()
   
   #test <- GetFirstMandatoryNotValidated((ind.processHasChanged + 1):len, rv)
   # The process that has been rested is enabled so as to rerun it
   steps.enabled[ind.processHasChanged] <- TRUE
   
   steps.skipped[ind.processHasChanged:len] <- FALSE
   
   
   
   Update_State_Screens(steps.skipped, steps.enabled, rv)
   
   
   
   
  } else {
    
    # A process has been validated
    steps.status[ind.processHasChanged] <- stepStatus$VALIDATED
    
    if (ind.processHasChanged < len) {
      steps.status[(1 + ind.processHasChanged):len] <- stepStatus$UNDONE
      
      # Reset all further processes
      #print('proceed to reset all further children')
      #
      # steps.status[(1 + ind.processHasChanged):len] <- 
    }
    
    steps.status <- Discover_Skipped_Steps(steps.status)
    dataIn <- newValue
  }
  
  
  return(
    list(
      dataIn = dataIn,
      steps.status = steps.status,
      steps.enabled = steps.enabled,
      steps.skipped = steps.skipped
    )
  )

}

#' @title xxxx
#' @description xxx
#'
#' @param config xxxx
#' @param tmp.return xxx
#'
#' @export
#'
#' @return NA
#'
GetValuesFromChildren <- function(config, tmp.return) {
  
  stepsnames <- names(config@steps)
  
    # Get the trigger values for each steps of the module
    return.trigger.values <- setNames(lapply(stepsnames, function(x) {
        tmp.return[[x]]$dataOut()$trigger
    }), nm = stepsnames
    )

    # Replace NULL values by NA
    return.trigger.values[sapply(return.trigger.values, is.null)] <- NA
    triggerValues <- unlist(return.trigger.values)


    # Get the values returned by each step of the modules
    return.values <- setNames(lapply(stepsnames, 
                                     function(x) {tmp.return[[x]]$dataOut()$value}),
                              nm = stepsnames)


    list(
        triggers = triggerValues,
        values = unlist(return.values)
    )
}


#' @title xxxx
#' @description xxx
#'
#' @param range xxxx
#' @param resetChildren xxx
#'
#' @export
#'
#' @return NA
#'
ResetChildren <- function(range, resetChildren) {
    
    resetChildren[range] <- resetChildren[range] + 1
    return(resetChildren)
}



#' @title xxxx
#' @description xxx
#'
#' @param rv xxxx
#' @param keepdataset_func xxx
#'
#' @export
#'
#' @return NA
#'
#'
Update_Data2send_Vector <- function(rv, keepdataset_func) {
    # One only update the current position because the vector has been entirely
    # initialized to NULL so the other processes are already ready to be sent
    ind.last.validated <- GetMaxValidated_BeforePos(rv = rv)
    name.last.validated <- names(rv$steps.status)[ind.last.validated]
    if (is.null(ind.last.validated) || 
        ind.last.validated == 1 ||
        name.last.validated == 'Save') {
        data <- rv$temp.dataIn
    } else {
    #browser()
      .ind <- which(grepl(name.last.validated, names(rv$dataIn)))
      data <- call.func(
        fname = keepdataset_func,
        args = list(object = rv$dataIn, range = seq_len(.ind))
      )
      
      }
    return(data)
}




#' @title xxxx
#' @description xxx
#'
#' @param rv xxxx
#' @param pos xxx
#' @param verbose xxx
#' @param keepdataset_func xxx
#'
#' @export
#' 
#' @importFrom crayon blue
#'
#' @return NA
#'
PrepareData2Send <- function(
    rv, 
    pos, 
    verbose = FALSE, 
    keepdataset_func) {
    # Returns NULL to all modules except the one pointed by the current position
    # Initialization of the pipeline : one send dataIn() to the
    # first module

    # The dataset to send is contained in the variable 'rv$dataIn'

    stepsnames <- names(rv$config@steps)
    nsteps <- length(rv$config@steps)
    # Initialize vector to all NULL values
    data2send <- setNames(lapply(stepsnames, function(x) {NULL}), nm = stepsnames)

    if (is.null(rv$dataIn)) { # Init of core engine

        # Only the first process will receive the data
        if (!is.null(rv$temp.dataIn))
          data2send[[1]] <- rv$temp.dataIn

        # The other processes are by default disabled.
        # If they have to be enabled, they will be by another function later
        lapply(seq_len(nsteps), function(x) {rv$steps.enabled[x] <- x == 1})
    } else {
      
        current.step.name <- stepsnames[rv$current.pos]
        data2send[[current.step.name]] <- Update_Data2send_Vector(rv, keepdataset_func)
    }

    if (verbose) {
        cat(crayon::blue("<----------------- Data sent to children ------------------> \n"))
        print(data2send)
        cat(crayon::blue("<----------------------------------------------------> \n"))
    }

    return(
        list(
            data2send = data2send,
            steps.enabled = rv$steps.enabled
        )
    )
}
