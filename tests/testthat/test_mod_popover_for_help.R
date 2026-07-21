library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("mod_popover_for_help_ui returns a tagList", {
  ui <- mod_popover_for_help_ui("test_id")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("mod_popover_for_help_ui contains nested div structure", {
  ui <- mod_popover_for_help_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("div", ui_as_char)))
})

test_that("mod_popover_for_help_ui contains all expected uiOutput elements", {
  ui <- mod_popover_for_help_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-write_title_ui", ui_as_char)))
  expect_true(any(grepl("test_id-dot", ui_as_char)))
  expect_true(any(grepl("test_id-show_Pop", ui_as_char)))
})

test_that("mod_popover_for_help_ui contains correct styles", {
  ui <- mod_popover_for_help_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("display:inline-block", ui_as_char)))
  expect_true(any(grepl("vertical-align: middle", ui_as_char)))
  expect_true(any(grepl("padding-bottom: 5px", ui_as_char)))
})

test_that("mod_popover_for_help returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_popover_for_help(title = "Test", content = "Test content"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----

test_that("popover help module renders title and dot", {
  
  testServer(
    mod_popover_for_help_server,
    args = list(
      title = "My Title",
      content = "My content"
    ),
    {session$flushReact()
     # Check title UI is rendered correctly
     title_html <- as.character(output$write_title_ui)
      
     expect_true(grepl("My Title", title_html[[1]]))
     expect_true(grepl("<strong>", title_html[[1]]))
      
     # Check dot UI is rendered
     dot_html <- as.character(output$dot)
      
     expect_true(grepl("\\[\\?\\]", dot_html[[1]]))
     expect_true(grepl("custom_tooltip", dot_html[[1]]))
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for mod_popover_for_help", {
  shiny_app <- MagellanNTK::mod_popover_for_help("myTitle", "myContent")
  app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-mod_popover_for_help")

  app$set_window_size(width = 1235, height = 695)
  app$expect_values(output = "settings-dot")
  app$expect_values(output = "settings-write_title_ui")
})
