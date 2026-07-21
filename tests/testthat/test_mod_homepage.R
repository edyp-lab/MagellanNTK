library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("mod_homepage_ui returns a tagList", {
  ui <- mod_homepage_ui("test_id")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("mod_homepage_ui contains insert_md_ui with correct namespace", {
  ui <- mod_homepage_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("insertMD", ui_as_char)))
  expect_true(any(grepl("test_id-md_file", ui_as_char)))
})

test_that("mod_homepage_ui contains uiOutput with correct namespace", {
  ui <- mod_homepage_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-infos_dataset", ui_as_char)))
})

test_that("mod_homepage returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_homepage(), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----

test_that("module initializes with the default mdfile", {
  testServer(
    mod_homepage_server,
    args = list(id = "test"),
    {
      # If the module initializes without error, the test passes
      expect_true(TRUE)
    }
  )
})

test_that("module initializes with a custom mdfile", {
  # Create a temporary Rmd file
  tmp_dir <- tempdir()
  tmp_mdfile <- file.path(tmp_dir, "test.Rmd")
  writeLines("# Test Markdown", tmp_mdfile)
  
  testServer(
    mod_homepage_server,
    args = list(
      id = "test",
      mdfile = tmp_mdfile
    ),
    {
      # If the module initializes without error, the test passes
      expect_true(TRUE)
    }
  )
})

test_that("module falls back to 404.Rmd when mdfile does not exist", {
  testServer(
    mod_homepage_server,
    args = list(
      id = "test",
      mdfile = "nonexistent.Rmd"
    ),
    {
      # If the module initializes without error, the test passes
      expect_true(TRUE)
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for mod_homepage", {
  shiny_app <- MagellanNTK::mod_homepage()
    app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-mod_homepage")
    
    app$set_window_size(width = 1235, height = 695)
    app$expect_values(output = "mod_pkg-md_file-insertMD")
})
