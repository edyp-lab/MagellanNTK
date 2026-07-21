library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("mod_SweetAlert_ui returns NULL", {
  result <- mod_SweetAlert_ui("test_id")
  expect_null(result)
})

test_that("mod_SweetAlert returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_SweetAlert(title = "Test", text = "Test message"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("mod_SweetAlert works with default type", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_SweetAlert(title = "Test", text = "Test message"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("mod_SweetAlert works with custom type", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_SweetAlert(title = "Test", text = "Test message", type = "error"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----
test_that("module initializes without errors", {
  testServer(
    mod_SweetAlert_server,
    args = list(id = "test"),
    {
      expect_true(TRUE) # If no error, test passes
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for mod_SweetAlert", {
  shiny_app <- MagellanNTK::mod_SweetAlert("my title", "my message")
    app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-mod_SweetAlert")
    
    app$set_window_size(width = 1235, height = 695)
    app$expect_values()
})
