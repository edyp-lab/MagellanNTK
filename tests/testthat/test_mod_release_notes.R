library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("mod_release_notes_ui returns a tabsetPanel", {
  ui <- mod_release_notes_ui("test_id")
  expect_s3_class(ui, "shiny.tag")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("tabset", ui_as_char)))
})

test_that("mod_release_notes_ui contains insert_md_ui with correct namespace", {
  ui <- mod_release_notes_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("insertMD", ui_as_char)))
  expect_true(any(grepl("test_id-versionNotes_MD", ui_as_char)))
})

test_that("mod_release_notes returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_release_notes("http://example.com/release.md"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("mod_release_notes works with local URL", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_release_notes("/local/path/release.md"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("mod_release_notes works with remote URL", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_release_notes("http://example.com/release.md"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----

test_that("release notes module initializes without error", {
  
  testServer(
    mod_release_notes_server,
    args = list(
      URL_releaseNotes = "https://example.com/release.md"
    ),
    { # If the module crashes, this test fails automatically
      session$flushReact()
      
      expect_true(TRUE)
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for mod_release_notes", {
  local.url <- system.file("/workflow/PipelineDemo/md/links.Rmd",
                           package = "MagellanNTK")
  shiny_app <- MagellanNTK::mod_release_notes(local.url)
  app <- shinytest2::AppDriver$new(shiny_app, 
                                   name = "MagellanNTK-mod_release_notes")
  
  app$set_window_size(width = 1235, height = 695)
  app$expect_values(output = "notes-versionNotes_MD-insertMD")
})
