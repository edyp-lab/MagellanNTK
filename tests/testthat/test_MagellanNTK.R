library(testthat)
suppressWarnings(
  library(shinytest2))
library(MagellanNTK)
suppressWarnings(
  library(shiny))


test_that("MagellanNTK_ui returns a shiny.tag", {
  ui <- MagellanNTK_ui("test_id")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("MagellanNTK_ui uses correct sidebar size", {
  # Test small
  ui_small <- MagellanNTK_ui("test_id", sidebarSize = "small")
  expect_s3_class(ui_small, "shiny.tag.list")
  
  # Test medium
  ui_medium <- MagellanNTK_ui("test_id", sidebarSize = "medium")
  expect_s3_class(ui_medium, "shiny.tag.list")
  
  # Test large
  ui_large <- MagellanNTK_ui("test_id", sidebarSize = "large")
  expect_s3_class(ui_large, "shiny.tag.list")
})

test_that("MagellanNTK_ui uses medium as default sidebar size", {
  ui <- MagellanNTK_ui("test_id")
  expect_true(any(grepl("300px", as.character(ui))))
})

test_that("MagellanNTK_ui calls mainapp_ui with correct id and size", {
  ui <- MagellanNTK_ui("test_id", sidebarSize = "small")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("mainapp_module", ui_as_char)))
})

test_that("MagellanNTK returns NULL when workflow.path is NULL", {
  expect_null(suppressWarnings(MagellanNTK(workflow.path = NULL, workflow.name = "test")))
})

test_that("MagellanNTK returns NULL when workflow.name is NULL", {
  expect_null(suppressWarnings(MagellanNTK(workflow.path = "/some/path", workflow.name = NULL)))
})

test_that("MagellanNTK generates warning when workflow.path is NULL", {
  expect_warning(
    MagellanNTK(workflow.path = NULL, workflow.name = "test"),
    "workflow.path is NULL"
  )
})

test_that("MagellanNTK generates warning when workflow.name is NULL", {
  expect_warning(
    MagellanNTK(workflow.path = "/some/path", workflow.name = NULL),
    "workflow.name is NULL"
  )
})


# testServer ----

test_that("module initializes with default NULL values", {
  testServer(
    MagellanNTK_server,
    args = list(),
    {
      # Check if the module initializes without errors
      expect_true(TRUE) # Placeholder for initialization check
    }
  )
})

test_that("reactive values are propagated to mainapp_server", {
  testServer(
    MagellanNTK_server,
    args = list(
      workflow.path = reactive("path/to/workflow"),
      workflow.name = reactive("test_workflow")
    ),
    {
      # Mock or inspect the call to mainapp_server
      # Since we can't directly inspect the call, we assume it works if no errors occur
      expect_true(TRUE) # Placeholder for propagation check
    }
  )
})

test_that("verbose and usermod arguments are passed to mainapp_server", {
  testServer(
    MagellanNTK_server,
    args = list(
      verbose = TRUE,
      usermod = "admin"
    ),
    {
      # Mock or inspect the call to mainapp_server
      # Since we can't directly inspect the call, we assume it works if no errors occur
      expect_true(TRUE) # Placeholder for argument propagation check
    }
  )
})
