library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("insert_md_ui returns a tagList", {
  ui <- insert_md_ui("test_id")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("insert_md_ui contains htmlOutput with correct namespace", {
  ui <- insert_md_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-insertMD", ui_as_char)))
})

test_that("insert_md_ui contains only one htmlOutput", {
  ui <- insert_md_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_equal(length(grep("html-output", ui_as_char)), 1)
})

test_that("insert_md returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(insert_md("dummy.Rmd"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("insert_md works with empty url", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(insert_md(""), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----

test_that("insert_md_server runs without error", {
  testServer(
    insert_md_server,
    args = list(
      id = "test",
      url = "https://example.com/fake.md"
    ),
    { session$flushReact()
      # output exists (even if it fails internally)
      expect_true(!is.null(output$insertMD))
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for insert_md", {
  base <- system.file("www/md", package = "MagellanNTK")
  url <- file.path(base, "Presentation.Rmd")
  shiny_app <- MagellanNTK::insert_md(url)
  app = shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-insert_md")
  
  app$set_window_size(width = 1235, height = 695)
  app$expect_values(output = "tree-insertMD")
})
