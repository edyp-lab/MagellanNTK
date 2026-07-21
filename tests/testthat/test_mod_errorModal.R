library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("mod_errorModal_ui returns NULL", {
  result <- mod_errorModal_ui("test_id")
  expect_null(result)
})

test_that("mod_errorModal returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_errorModal(), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("mod_errorModal works with default parameters", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_errorModal(), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("mod_errorModal works with custom title and text", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_errorModal(title = "Error", text = "An error occurred"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----
test_that("module initializes without errors", {
  testServer(
    mod_errorModal_server,
    args = list(id = "test"),
    {
      expect_true(TRUE) # If no error, test passes
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for mod_errorModal", {
  shiny_app <- MagellanNTK::mod_errorModal("myTitle", "myContent")
    app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-mod_errorModal")
    
    app$set_window_size(width = 1235, height = 695)
    app$expect_values()
})
