#' @title xxx
#'
#' @description xxx
#'
#' @param steps.status xxx
#' @param current.pos xxx
#' @param config xxx
#'
#' @return A `wellPanel`
#'
#' @export
#' @examples
#' NULL
#'
Build_SkippedInfoPanel <- function(steps.status, current.pos, config) {
    req(steps.status[current.pos] == stepStatus$SKIPPED)
    .op1 <- stepStatus$SKIPPED * length(config@steps)
    process_entirely_skipped <- isTRUE(sum(steps.status) == .op1)

    if (process_entirely_skipped) {
        # This case appears when the process has been skipped from the
        # pipeline. Thus, it is not necessary to show the info box because
        # it is shown below the timeline of the pipeline
    } else {
        txt <- paste0(
            "This ", config@mode,
            " is skipped so it has been disabled."
        )
        wellPanel(
            style = "background-color: #7CC9F0; opacity: 0.72; padding: 0px;
                   align: center; vertical-align: center;",
            height = 100,
            width = 300,
            align = "center",
            p(style = "color: black;", paste0("Info: ", txt))
        )
    }
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

        # ToggleState_NavBtns(
        #     current.pos = rv$current.pos,
        #     nSteps = rv$length
        # )
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
