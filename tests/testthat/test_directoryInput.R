library(testthat)
library(MagellanNTK)
suppressWarnings(library(shiny))
suppressWarnings(library(htmltools))


test_that("%AND% returns y when both x and y are non-NULL/NA", {
  expect_equal(1 %AND% 2, 2)
  expect_equal("a" %AND% "b", "b")
  expect_equal(TRUE %AND% FALSE, FALSE)
  expect_equal(list(1) %AND% list(2), list(2))
})

test_that("%AND% returns NULL when x is NULL or NA", {
  expect_null(NULL %AND% 1)
  expect_null(NA %AND% 1)
  expect_null(NA_character_ %AND% "test")
})

test_that("%AND% returns NULL when y is NULL or NA", {
  expect_null(1 %AND% NULL)
  expect_null(1 %AND% NA)
  expect_null("test" %AND% NA_character_)
})

test_that("%AND% returns NULL when both are NULL or NA", {
  expect_null(NULL %AND% NULL)
  expect_null(NA %AND% NA)
  expect_null(NULL %AND% NA)
})


test_that("file_sep returns correct separator for each OS", {
  # Test Windows
  windows_info <- list(sysname = "Windows")
  expect_equal(file_sep(windows_info), "\\")
  
  # Test Linux
  linux_info <- list(sysname = "Linux")
  expect_equal(file_sep(linux_info), "/")
  
  # Test Darwin (Mac)
  darwin_info <- list(sysname = "Darwin")
  expect_equal(file_sep(darwin_info), "/")
})


test_that("directoryInput creates valid HTML", {
  # Test basic creation
  result <- directoryInput("test_id", "Test Label")
  expect_s3_class(result, "shiny.tag.list")
  
  # Test with NULL value
  result_null <- directoryInput("test_id", "Test Label", value = NULL)
  expect_s3_class(result_null, "shiny.tag.list")
  
  # Test with NA value
  result_na <- directoryInput("test_id", "Test Label", value = NA)
  expect_s3_class(result_na, "shiny.tag.list")
  
  # Test with valid path (should expand)
  result_path <- directoryInput("test_id", "Test Label", value = "~/test")
  expect_s3_class(result_path, "shiny.tag.list")
  
  # Test without label
  result_no_label <- directoryInput("test_id", NULL)
  expect_s3_class(result_no_label, "shiny.tag.list")
})


test_that("updateDirectoryInput sends correct message", {
  # Create a mock session
  sent_messages <- list()
  mock_session <- list(
    sendInputMessage = function(inputId, value) {
      sent_messages <<- list(inputId = inputId, value = value)
    }
  )
  
  updateDirectoryInput(mock_session, "test_id", value = "/test/path")
  expect_equal(sent_messages$inputId, "test_id")
  expect_equal(sent_messages$value, list(chosen_dir = "/test/path"))
})


test_that("readDirectoryInput retrieves correct value", {
  # Create a mock session with input
  mock_session <- list(
    input = list("test_id__chosen_dir" = "/test/path")
  )
  
  result <- readDirectoryInput(mock_session, "test_id")
  expect_equal(result, "/test/path")
})

test_that("readDirectoryInput returns NULL for missing input", {
  # Create a mock session without input
  mock_session <- list(input = list())
  
  result <- readDirectoryInput(mock_session, "nonexistent_id")
  expect_null(result)
})


test_that("runDirinputExample creates a shiny app", {
  # This is more of a smoke test since we can't fully test the app
  expect_silent({
    app <- runDirinputExample()
    expect_s3_class(app, "shiny.appobj")
  })
})
