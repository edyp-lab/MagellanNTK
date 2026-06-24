library(testthat)
library(MagellanNTK)


test_that("default_funcs returns expected function list", {
  result <- default_funcs()
  
  # Check it returns a named list
  expect_is(result, "list")
  expect_named(result, c(
    "open_dataset", "view_dataset", "download_dataset",
    "build_report", "infos_dataset", "history_dataset",
    "addDatasets", "keepDatasets", "InitializeHistory",
    "Add2History", "GetHistory", "SetHistory"
  ))
  
  # Check all values are character strings with expected format
  expect_true(all(sapply(result, function(x) grepl("^MagellanNTK::", x))))
})


test_that("default_base_URL returns valid path", {
  # Skip if MagellanNTK isn't installed
  skip_if_not_installed("MagellanNTK")
  
  result <- default_base_URL()
  
  # Check it returns a character string
  expect_is(result, "character")
  
  # Check the path exists (if package is installed)
  expect_true(nzchar(result))
  
  # Check it points to the expected location
  expect_match(result, "www/md$")
})


test_that("default_workflow returns expected structure", {
  # Skip if MagellanNTK isn't installed
  skip_if_not_installed("MagellanNTK")
  
  result <- default_workflow()
  
  # Check it returns a named list
  expect_is(result, "list")
  expect_named(result, c("name", "path"))
  
  # Check the values
  expect_equal(result$name, "PipelineDemo_Preprocessing")
  expect_match(result$path, "workflow/PipelineDemo$")
  
  # Check the path exists (if package is installed)
  expect_true(file.exists(result$path))
})


test_that("default_theme returns correct theme for user mode", {
  result <- default_theme("user")
  
  # Check it returns a named list
  expect_is(result, "list")
  
  # Check all expected elements are present
  expected_user_elements <- c(
    "bgcolor_process_sidebar", "bgcolor_process_timeline",
    "bgcolor_process_content", "bgcolor_process_panel",
    "bgcolor_process_btns", "bgcolor_pipeline_sidebar",
    "bgcolor_pipeline_timeline", "bgcolor_content_wrapper"
  )
  expect_named(result, expected_user_elements)
  
  # Check specific values for user mode
  expect_equal(result$bgcolor_process_sidebar, "lightgrey")
  expect_equal(result$bgcolor_pipeline_sidebar, "lightgrey")
  expect_equal(result$bgcolor_content_wrapper, "white")
})

test_that("default_theme returns correct theme for dev mode", {
  result <- default_theme("dev")
  
  # Check it returns a named list
  expect_is(result, "list")
  
  # Check all expected elements are present
  expected_dev_elements <- c(
    "bgcolor_process_sidebar", "bgcolor_process_timeline",
    "bgcolor_process_content", "bgcolor_process_panel",
    "bgcolor_process_btns", "bgcolor_pipeline_sidebar",
    "bgcolor_pipeline_timeline", "edaBackgroundColor"
  )
  expect_named(result, expected_dev_elements)
  
  # Check specific values for dev mode
  expect_equal(result$bgcolor_process_sidebar, "yellow")
  expect_equal(result$bgcolor_pipeline_sidebar, "lightblue")
  expect_equal(result$edaBackgroundColor, "red")
})

test_that("default_theme handles NULL mode", {
  # Should default to user mode
  result <- default_theme(NULL)
  expect_equal(result, default_theme("user"))
})

test_that("default_theme handles invalid mode", {
  # Should default to user mode for invalid inputs
  expect_equal(default_theme(NULL), default_theme("user"))
  expect_equal(default_theme("invalid"), default_theme("user"))
  expect_equal(default_theme(123), default_theme("user"))
})
