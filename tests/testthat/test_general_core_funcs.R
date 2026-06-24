library(testthat)
library(MagellanNTK)


test_that("InitializeHistory creates an empty history data frame", {
  result <- InitializeHistory()
  
  # Check structure
  expect_is(result, "data.frame")
  expect_equal(ncol(result), 4)
  expect_equal(nrow(result), 0)
  
  # Check column names
  expect_equal(names(result), c("Process", "Step", "Parameter", "Value"))
})


test_that("Add2History adds a row to history data frame", {
  # Start with empty history
  history <- InitializeHistory()
  
  # Add a simple entry
  result <- Add2History(history, "Process1", "Step1", "Param1", "Value1")
  
  # Check structure
  expect_equal(nrow(result), 1)
  expect_equal(ncol(result), 4)
  
  # Check content
  expect_equal(result$Process[1], "Process1")
  expect_equal(result$Step[1], "Step1")
  expect_equal(result$Parameter[1], "Param1")
  expect_equal(result$Value[1], "Value1")
})

test_that("Add2History handles list values", {
  history <- InitializeHistory()
  test_list <- list(a = 1, b = 2)
  
  result <- Add2History(history, "Process1", "Step1", "Param1", test_list)
  
  # Check the list was unlisted
  expect_is(result$Value[1], "character")
  expect_equal(length(unlist(strsplit(result$Value[1], ", "))), 2)
})

test_that("Add2History handles NULL values", {
  history <- InitializeHistory()

  result <- Add2History(history, "Process1", "Step1", "Param1", NULL)

  # Check NULL was converted to NA
  expect_true(is.na(result$Value[1]))
})

test_that("Add2History preserves existing history", {
  history <- InitializeHistory()
  history <- Add2History(history, "Process1", "Step1", "Param1", "Value1")

  # Add another entry
  result <- Add2History(history, "Process2", "Step2", "Param2", "Value2")

  # Check both entries exist
  expect_equal(nrow(result), 2)
  expect_equal(result$Process, c("Process1", "Process2"))
})


test_that("GetHistory returns NULL for non-existent slot", {
  # Create a mock MultiAssayExperiment object
  suppressWarnings({
    skip_if_not_installed("MultiAssayExperiment")
    skip_if_not_installed("S4Vectors")
    library(MultiAssayExperiment)})
  
  mae <- MultiAssayExperiment()

  # Test with non-existent slot
  result <- GetHistory(mae, "NonExistent")
  expect_null(result)
})

test_that("GetHistory returns history for Description slot", {
  suppressWarnings({
    skip_if_not_installed(c("MultiAssayExperiment", "S4Vectors"))
    library(MultiAssayExperiment)
    library(SummarizedExperiment)})

  # Create a MultiAssayExperiment with Convert slot
  se <- SummarizedExperiment(list())
  metadata(se)$history <- InitializeHistory()
  metadata(se)$history <- Add2History(metadata(se)$history,
                                      "Process1", "Step1", "Param1", "Value1")
  mae <- MultiAssayExperiment(list(Convert = se))

  # Test with Description slot
  result <- GetHistory(mae, "Description")
  expect_is(result, "data.frame")
  expect_equal(nrow(result), 1)
})

test_that("GetHistory returns NULL for Save slot", {
  suppressWarnings({
    skip_if_not_installed("MultiAssayExperiment")
    library(MultiAssayExperiment)})
  
  mae <- MultiAssayExperiment()

  # Test with Save slot
  result <- GetHistory(mae, "Save")
  expect_null(result)
})

test_that("GetHistory returns history for existing slot", {
  suppressWarnings({
    skip_if_not_installed(c("MultiAssayExperiment", "S4Vectors"))
    library(MultiAssayExperiment)
    library(SummarizedExperiment)})

  # Create a MultiAssayExperiment with a slot containing history
  se <- SummarizedExperiment(list())
  metadata(se)$history <- InitializeHistory()
  metadata(se)$history <- Add2History(metadata(se)$history,
                                      "Process1", "Step1", "Param1", "Value1")
  mae <- MultiAssayExperiment(list(Test = se))

  # Test with existing slot
  result <- GetHistory(mae, "Test")
  expect_is(result, "data.frame")
  expect_equal(nrow(result), 1)
})

test_that("GetHistory handles NULL input", {
  expect_error(GetHistory(NULL, "Test"))
})


test_that("SetHistory sets history for SummarizedExperiment", {
  suppressWarnings({
    skip_if_not_installed(c("SummarizedExperiment", "S4Vectors"))
    library(SummarizedExperiment)})

  # Create a SummarizedExperiment
  se <- SummarizedExperiment(list())

  # Create a history
  history <- InitializeHistory()
  history <- Add2History(history, "Process1", "Step1", "Param1", "Value1")

  # Set the history
  result <- SetHistory(se, history)

  # Check the history was set
  expect_is(S4Vectors::metadata(result)[["history"]], "data.frame")
  expect_equal(nrow(S4Vectors::metadata(result)[["history"]]), 1)
})

test_that("SetHistory appends to existing history", {
  suppressWarnings({
    skip_if_not_installed(c("SummarizedExperiment", "S4Vectors"))
    library(SummarizedExperiment)})

  # Create a SummarizedExperiment with existing history
  se <- SummarizedExperiment(list())
  existing_history <- InitializeHistory()
  existing_history <- Add2History(existing_history, "Process1", "Step1", "Param1", "Value1")
  S4Vectors::metadata(se)[["history"]] <- existing_history

  # Create new history
  new_history <- InitializeHistory()
  new_history <- Add2History(new_history, "Process2", "Step2", "Param2", "Value2")

  # Set the history (should append)
  result <- SetHistory(se, new_history)

  # Check both histories exist
  expect_equal(nrow(S4Vectors::metadata(result)[["history"]]), 2)
})

test_that("SetHistory handles NULL history", {
  suppressWarnings({
    skip_if_not_installed(c("SummarizedExperiment", "S4Vectors"))
    library(SummarizedExperiment)})

  # Create a SummarizedExperiment
  se <- SummarizedExperiment(list())

  # Set NULL history (should do nothing)
  result <- SetHistory(se, NULL)
  expect_null(S4Vectors::metadata(result)[["history"]])
})


test_that("GetMaxValidated_BeforePos returns NULL for position 1", {
  rv <- list(steps.status = c(1, 0, 1, 0), current.pos = 1)
  result <- GetMaxValidated_BeforePos(1, rv)
  expect_null(result)
})

test_that("GetMaxValidated_BeforePos returns NULL when no validated steps before position", {
  rv <- list(steps.status = c(0, 0, 0, 1), current.pos = 4)
  result <- GetMaxValidated_BeforePos(4, rv)
  expect_null(result)
})

test_that("GetMaxValidated_BeforePos returns correct index", {
  rv <- list(steps.status = c(1, 0, 1, 0, 1), current.pos = 5)
  result <- GetMaxValidated_BeforePos(5, rv)
  expect_equal(result, 3)  # Last validated before position 5 is at index 3
})

test_that("GetMaxValidated_BeforePos uses current.pos from rv when pos is NULL", {
  rv <- list(steps.status = c(1, 0, 1, 0), current.pos = 4)
  result <- GetMaxValidated_BeforePos(NULL, rv)
  expect_null(result) 
})

test_that("GetMaxValidated_BeforePos handles all validated steps", {
  rv <- list(steps.status = c(1, 1, 1, 0), current.pos = 4)
  result <- GetMaxValidated_BeforePos(4, rv)
  expect_equal(result, 3)  # Last validated before position 4 is at index 3
})

test_that("GetMaxValidated_BeforePos handles empty steps.status", {
  rv <- list(steps.status = numeric(0), current.pos = 1)
  result <- GetMaxValidated_BeforePos(1, rv)
  expect_null(result)
})


test_that("GetMaxValidated_AllSteps returns 0 for no validated steps", {
  result <- GetMaxValidated_AllSteps(c(0, 0, 0))
  expect_equal(result, 0)
})

test_that("GetMaxValidated_AllSteps returns correct index", {
  result <- GetMaxValidated_AllSteps(c(0, 1, 0, 1, 0))
  expect_equal(result, 4)  # Last validated is at index 4
})

test_that("GetMaxValidated_AllSteps returns last index for all validated", {
  result <- GetMaxValidated_AllSteps(c(1, 1, 1))
  expect_equal(result, 3)
})

test_that("GetMaxValidated_AllSteps handles first position", {
  result <- GetMaxValidated_AllSteps(c(1, 0, 0))
  expect_equal(result, 1)
})

test_that("GetMaxValidated_AllSteps handles empty input", {
  result <- GetMaxValidated_AllSteps(numeric(0))
  expect_equal(result, 0)
})

test_that("GetMaxValidated_AllSteps handles single validated step", {
  result <- GetMaxValidated_AllSteps(c(0, 0, 1))
  expect_equal(result, 3)
})


test_that("ToggleState_Screens updates steps.enabled correctly when cond is TRUE", {
  rv <- list(
    steps.enabled = c(FALSE, FALSE, FALSE, TRUE),
    steps.status = c(1, 1, 0, 1) 
  )
  result <- ToggleState_Screens(TRUE, 1:4, TRUE, rv)
  expect_equal(result, c(TRUE, TRUE, TRUE, TRUE))  
})

test_that("ToggleState_Screens updates steps.enabled correctly when cond is FALSE", {
  rv <- list(
    steps.enabled = c(TRUE, TRUE, TRUE, TRUE),
    steps.status = c(1, 1, 1, 1)
  )
  result <- ToggleState_Screens(FALSE, 1:4, TRUE, rv)
  expect_equal(result, c(FALSE, FALSE, FALSE, FALSE))
})

test_that("ToggleState_Screens does nothing when is.enabled is FALSE", {
  rv <- list(
    steps.enabled = c(TRUE, TRUE, TRUE, TRUE),
    steps.status = c(1, 1, 1, 1)
  )
  original <- rv$steps.enabled
  result <- ToggleState_Screens(TRUE, 1:4, FALSE, rv)
  expect_equal(result, original)  # No change
})

test_that("ToggleState_Screens handles partial range", {
  rv <- list(
    steps.enabled = c(TRUE, TRUE, TRUE, TRUE),
    steps.status = c(1, 0, 1, 1) 
  )
  result <- ToggleState_Screens(TRUE, 2:3, TRUE, rv)
  expect_equal(result, c(TRUE, TRUE, TRUE, TRUE))  
})

test_that("ToggleState_Screens handles empty range", {
  rv <- list(
    steps.enabled = c(TRUE, TRUE, TRUE, TRUE),
    steps.status = c(1, 1, 1, 1)
  )
  result <- ToggleState_Screens(TRUE, integer(0), TRUE, rv)
  expect_equal(result, rv$steps.enabled)  # No change
})


test_that("NavPage moves forward correctly", {
  expect_equal(NavPage(1, 3, 5), 4)  # Move forward from 3
  expect_equal(NavPage(1, 1, 5), 2)  # Move forward from 1
})

test_that("NavPage moves backward correctly", {
  expect_equal(NavPage(-1, 3, 5), 2)  # Move backward from 3
  expect_equal(NavPage(-1, 1, 5), 1)  # Can't move below 1
})

test_that("NavPage respects boundaries", {
  expect_equal(NavPage(1, 5, 5), 5)   # Can't move beyond length
  expect_equal(NavPage(-1, 1, 5), 1)  # Can't move below 1
  expect_equal(NavPage(10, 3, 5), 5)  # Large forward move
  expect_equal(NavPage(-10, 3, 5), 1) # Large backward move
})

test_that("NavPage handles edge cases", {
  expect_equal(NavPage(1, 1, 1), 1)   # Only one position
  expect_equal(NavPage(-1, 1, 1), 1)  # Only one position
  expect_equal(NavPage(0, 3, 5), 3)   # No movement
})


test_that("Discover_Skipped_Steps identifies skipped steps correctly", {
  # Test with no skipped steps
  steps <- c(1, 1, 1, 1)
  result <- Discover_Skipped_Steps(steps)
  expect_equal(result, steps)  # No changes
  
  # Test with one skipped step
  steps <- c(1, 1, 0, 1)
  result <- Discover_Skipped_Steps(steps)
  expect_equal(result, c(1, 1, -1, 1))  # Third step should be marked as skipped
  
  # Test with multiple skipped steps
  steps <- c(1, 0, 1, 0, 1)
  result <- Discover_Skipped_Steps(steps)
  expect_equal(result, c(1, -1, 1, -1, 1))
  
  # Test with all steps unvalidated
  steps <- c(0, 0, 0)
  result <- Discover_Skipped_Steps(steps)
  expect_equal(result, steps)  # No changes, as no validated steps exist
  
  # Test with empty input
  steps <- numeric(0)
  result <- Discover_Skipped_Steps(steps)
  expect_equal(result, steps)
})


# Mock the Config S4 class for testing
setClass(
  "Config_test",
  representation = representation(
    fullname = "character",
    name = "character",
    parent = "character",
    mode = "character",
    steps = "character",
    mandatory = "logical",
    ll.UI = "list",
    steps.source.file = "logical"
  )
)

# Constructor function for testing
mock_Config <- function(mode = "process", steps = character(0), mandatory = logical(0)) {
  # Ensure steps and mandatory have the same length
  if (length(steps) != length(mandatory)) {
    stop("steps and mandatory must have the same length")
  }
  
  # Create a Config object
  new(
    "Config_test",
    fullname = "",
    name = NA_character_,
    parent = "",
    mode = mode,
    steps = steps,
    mandatory = mandatory,
    ll.UI = list(),
    steps.source.file = logical(0)
  )
}

test_that("GetFirstMandatoryNotValidated finds first mandatory unvalidated step", {
  # Create test rv object
  config <- mock_Config(
    mode = "process",
    steps = c("Description", "A", "B", "C", "D"),
    mandatory = c(TRUE, TRUE, FALSE, TRUE, TRUE)
  )
  
  rv <- list(
    config = config,
    steps.status = c(1, 1, 0, 0, 0)  # 1=VALIDATED, 0=UNDONE
  )
  
  # Test with range covering all steps
  result <- GetFirstMandatoryNotValidated(1:5, rv)
  expect_equal(result, 4)  # First mandatory unvalidated is step 4 
  
  # Test with limited range
  result <- GetFirstMandatoryNotValidated(1:4, rv)
  expect_equal(result, 4)  # Only step 1 is in range and mandatory+unvalidated
  
  # Test with no mandatory unvalidated steps
  rv$steps.status <- c(1, 1, 0, 1, 1)
  result <- GetFirstMandatoryNotValidated(1:5, rv)
  expect_null(result)
  
  # Test with empty range
  result <- GetFirstMandatoryNotValidated(integer(0), rv)
  expect_null(result)
})

test_that("GetFirstMandatoryNotValidated handles edge cases", {
  # All steps validated
  config <- mock_Config(
    mode = "process",
    steps = c("A", "B"),
    mandatory = c(TRUE, TRUE)
  )
  
  rv <- list(
    config = config,
    steps.status = c(1, 1)  # 1=VALIDATED, 0=UNDONE
  )
  
  result <- GetFirstMandatoryNotValidated(1:2, rv)
  expect_null(result)
  
  # No mandatory steps
  rv$config@mandatory <- c(FALSE, FALSE)
  rv$steps.status <- c(0, 0)
  result <- GetFirstMandatoryNotValidated(1:2, rv)
  expect_null(result)
})


test_that("UpdateStepsStatus updates status based on dataIn", {
  # Create test config
  config <- mock_Config(
    mode = "process",
    steps = c("Description", "A", "B"),
    mandatory = c(TRUE, TRUE, FALSE)
  )
  names(config@steps) <- c("Description", "A", "B")
  
  # Test with NULL dataIn
  result <- UpdateStepsStatus(NULL, config)
  expect_equal(result, c(Description = 0, A = 0, B = 0))  # Description is TRUE
  
  # Test with dataIn containing some steps
  dataIn <- list(A = "data1")
  result <- UpdateStepsStatus(dataIn, config)
  expect_equal(result, c(Description = 1, A = 1, B = 0))
  
  # Test with dataIn containing all steps
  dataIn <- list(A = "data1", B = "data2")
  result <- UpdateStepsStatus(dataIn, config)
  expect_equal(result, c(Description = 1, A = 1, B = 1))
})

test_that("UpdateStepsStatus handles missing Description", {
  config <- mock_Config(
    mode = "process",
    steps = c("A", "B"),
    mandatory = c(TRUE, FALSE)
  )
  names(config@steps) <- c("A", "B")
  
  dataIn <- list(A = "data1")
  
  result <- UpdateStepsStatus(dataIn, config)
  expect_equal(result, c(A = 1, B = 0))  # No Description step
})


test_that("BuildData2Send builds correct data structure", {
  # Skip if SummarizedExperiment or MultiAssayExperiment are not installed
  skip_if_not_installed("SummarizedExperiment")
  skip_if_not_installed("MultiAssayExperiment")
  
  # Mock keepDatasets to handle SummarizedExperiment
  mock_keepDatasets <- function(object, range) {
    # Return a subset of the object (mock behavior)
    return(object[, , range, drop = FALSE])
  }
  
  # Save original do.call
  original_do_call <- do.call
  
  # Mock do.call
  local({
    assign("do.call", function(what, args) {
      if (is.character(what) && grepl("keepDatasets", what, fixed = TRUE)) {
        return(mock_keepDatasets(args$object, args$range))
      }
      original_do_call(what, args)
    }, envir = parent.frame())
    
    # Mock session
    session <- list(
      userData = list(
        funcs = list(keepDatasets = "MagellanNTK::keepDatasets")
      )
    )
    
    # Create a mock SummarizedExperiment
    dataIn <- SummarizedExperiment::SummarizedExperiment(
      assays = list(),
      rowData = data.frame(),
      colData = data.frame()
    )
    dataIn <- MultiAssayExperiment::MultiAssayExperiment(list(data1 = dataIn))
    
    stepsNames <- c("step1", "step2", "step3")
    result <- BuildData2Send(session, dataIn, stepsNames)
    
    expect_is(result, "list")
    expect_equal(names(result), stepsNames)
    expect_equal(length(result), 3)
    
    # Create a mock SummarizedExperiment
    dataIn <- SummarizedExperiment::SummarizedExperiment(
      assays = list(),
      rowData = data.frame(),
      colData = data.frame()
    )
    dataIn <- MultiAssayExperiment::MultiAssayExperiment(list(step1 = dataIn, step2 = dataIn))
    
    stepsNames <- c("step1", "step2", "step3")
    result <- suppressWarnings(BuildData2Send(session, dataIn, stepsNames))
    
    expect_is(result, "list")
    expect_equal(names(result), stepsNames)
    expect_equal(length(result), 3)
    
    # Create a mock SummarizedExperiment
    result <- suppressWarnings(BuildData2Send(NULL, dataIn, stepsNames))
    
    expect_is(result, "list")
    expect_equal(names(result), stepsNames)
    expect_equal(length(result), 3)
  })
})
 
test_that("BuildData2Send handles missing funcs", {
  # Skip if SummarizedExperiment or MultiAssayExperiment are not installed
  skip_if_not_installed("SummarizedExperiment")
  skip_if_not_installed("MultiAssayExperiment")
  
  # Mock session without funcs
  session <- list(
    userData = list()
  )

  dataIn <- SummarizedExperiment::SummarizedExperiment(
    assays = list(),
    rowData = data.frame(),
    colData = data.frame()
  )
  dataIn <- MultiAssayExperiment::MultiAssayExperiment(list(data1 = dataIn))
  stepsNames <- c("step1", "step2", "step3")

  # Mock keepDatasets in global environment
  keepDatasets <- function(object, range) object
  assign("keepDatasets", keepDatasets, envir = .GlobalEnv)

  result <- BuildData2Send(session, dataIn, stepsNames)
  expect_equal(names(result), stepsNames)

  # Clean up
  rm("keepDatasets", envir = .GlobalEnv)
})

test_that("BuildData2Send handles empty dataIn", {
  # This should throw an error due to req(dataIn)
  expect_error(
    BuildData2Send(NULL, NULL, c("step1"))
  )
})


test_that("SetCurrentPosition returns 1 for all unvalidated steps", {
  stepsstatus <- c(0, 0, 0)
  result <- SetCurrentPosition(stepsstatus)
  expect_equal(result, 1)
})

test_that("SetCurrentPosition returns last validated position", {
  stepsstatus <- c(1, 1, 0, 1, 0)
  result <- SetCurrentPosition(stepsstatus)
  expect_equal(result, 4)  # Last validated is at position 4
})

test_that("SetCurrentPosition returns 1 when no steps are validated", {
  stepsstatus <- c(0, 0, 0, 0)
  result <- SetCurrentPosition(stepsstatus)
  expect_equal(result, 1)
})

test_that("SetCurrentPosition returns first position for first step validated", {
  stepsstatus <- c(1, 0, 0)
  result <- SetCurrentPosition(stepsstatus)
  expect_equal(result, 1)
})

test_that("SetCurrentPosition handles empty input", {
  stepsstatus <- numeric(0)
  result <- SetCurrentPosition(stepsstatus)
  expect_equal(result, 1)
})


test_that("Update_State_Screens disables all steps when is.skipped is TRUE", {
  rv <- list(
    steps.status = c(1, 0, 0, 1),
    config = mock_Config(mandatory = c(TRUE, TRUE, FALSE, TRUE), steps = c("A", "B", "C", "D"))
  )
  result <- Update_State_Screens(TRUE, TRUE, rv)
  expect_equal(result, c(FALSE, FALSE, FALSE, FALSE))
})

test_that("Update_State_Screens handles is.skipped = FALSE with no validated steps", {
  rv <- list(
    steps.status = c(0, 0, 0),
    config = mock_Config(mandatory = c(TRUE, FALSE, TRUE), steps = c("A", "B", "C"))
  )
  result <- Update_State_Screens(FALSE, TRUE, rv)
  expect_equal(result, c(NA, FALSE, FALSE))  
})

test_that("Update_State_Screens disables steps before last validated", {
  rv <- list(
    steps.status = c(1, 0, 0, 1, 0),
    config = mock_Config(mandatory = c(TRUE, TRUE, FALSE, TRUE, TRUE), steps = c("A", "B", "C", "D", "E"))
  )
  result <- Update_State_Screens(FALSE, TRUE, rv)
  expect_equal(result, c(NA, NA, NA, NA, TRUE))  
})

test_that("Update_State_Screens enables steps after last validated", {
  rv <- list(
    steps.status = c(1, 1, 0, 0),
    config = mock_Config(mandatory = c(TRUE, TRUE, FALSE, TRUE), steps = c("A", "B", "C", "D"))
  )
  result <- Update_State_Screens(FALSE, TRUE, rv)
  expect_equal(result, c(NA, NA, TRUE, TRUE)) 
})

test_that("Update_State_Screens disables steps after first mandatory unvalidated", {
  rv <- list(
    steps.status = c(1, 0, 0, 1, 0),
    config = mock_Config(mandatory = c(TRUE, TRUE, FALSE, TRUE, TRUE), steps = c("A", "B", "C", "D", "E"))
  )
  result <- Update_State_Screens(FALSE, TRUE, rv)
  expect_equal(result, c(NA, NA, NA, NA, TRUE))  # Step 5 disabled
})

test_that("Update_State_Screens handles is.enabled = FALSE", {
  rv <- list(
    steps.status = c(1, 0, 0),
    config = mock_Config(mandatory = c(TRUE, TRUE, FALSE), steps = c("A", "B", "C"))
  )
  result <- Update_State_Screens(FALSE, FALSE, rv)
  expect_equal(result, NULL) 
})

test_that("Update_State_Screens handles no mandatory step", {
  rv <- list(
    steps.status = c(1, 0, 0),
    config = mock_Config(mandatory = c(FALSE, FALSE, FALSE), steps = c("A", "B", "C"))
  )
  result <- Update_State_Screens(FALSE, TRUE, rv)
  expect_equal(result, c(NA, TRUE, TRUE)) 
})
