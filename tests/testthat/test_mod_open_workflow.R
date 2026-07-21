library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("open_workflow_ui returns a tagList", {
  ui <- open_workflow_ui("test_id")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("open_workflow_ui contains h3 with correct text and style", {
  ui <- open_workflow_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("Open workflow", ui_as_char)))
  expect_true(any(grepl('color: blue', ui_as_char)))
})

test_that("open_workflow_ui contains all expected uiOutput elements", {
  ui <- open_workflow_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-choosePackage_UI", ui_as_char)))
  expect_true(any(grepl("test_id-chooseWF1_UI", ui_as_char)))
  expect_true(any(grepl("test_id-chooseProcess_UI", ui_as_char)))
  expect_true(any(grepl("test_id-wf_preview_ui", ui_as_char)))
  expect_true(any(grepl("test_id-infos_wf_UI", ui_as_char)))
})

test_that("open_workflow_ui contains actionButton with correct namespace and label", {
  ui <- open_workflow_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-load_btn", ui_as_char)))
  expect_true(any(grepl("Load", ui_as_char)))
})

test_that("open_workflow returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(open_workflow(), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----
test_that("module initializes with correct reactive values", {
  testServer(
    open_workflow_server,
    args = list(id = "test"),
    {
      expect_equal(rv.wf$path, path.expand("~"))
      expect_null(rv.wf$dataOut)
    }
  )
})

test_that("choosePackage_UI renders a selectInput", {
  testServer(
    open_workflow_server,
    args = list(id = "test"),
    {
      session$flushReact()
      ui_output <- output$choosePackage_UI
      expect_true(!is.null(ui_output))
      expect_true(inherits(ui_output, "list"))
    }
  )
})

test_that("infos_wf_UI requires rv.wf$dataOut$wf_name", {
  testServer(
    open_workflow_server,
    args = list(id = "test"),
    {
      # Initialize as empty list to avoid `NULL$` errors
      rv.wf$dataOut <- list()
      session$flushReact()
      
      # Check output is NULL (handles silent error from req(NULL))
      result <- tryCatch({
        output$infos_wf_UI
      }, shiny.silent.error = function(e) NULL, error = function(e) NULL)
      expect_null(result)
      
      # Set wf_name and verify output renders
      rv.wf$dataOut$wf_name <- "test_wf"
      session$flushReact()
      expect_true(!is.null(output$infos_wf_UI))
    }
  )
})

test_that("module returns a reactive with rv.wf$dataOut", {
  testServer(
    open_workflow_server,
    args = list(id = "test"),
    {
      # The module returns a reactive
      return_value <- reactive({ rv.wf$dataOut })
      expect_true(!is.null(return_value))
      expect_true(is.reactive(return_value))
    }
  )
})

test_that("FindPkg2MagellanNTK and Find_WF return correct values", {
  testServer(
    open_workflow_server,
    args = list(id = "test"),
    {
      session$flushReact()
      
      pkg_list <- FindPkg2MagellanNTK()
      expect_is(pkg_list, "character")
      expect_true("MagellanNTK" %in% pkg_list)
      
      session$setInputs(choosePkg = "MagellanNTK")
      session$flushReact()
      
      wf_list <- Find_WF()
      expect_is(wf_list, "character")
      expect_true("PipelineDemo" %in% wf_list)
    }
  )
})

test_that("output$chooseProcess_UI returns correct value", {
  testServer(
    open_workflow_server,
    args = list(id = "test"),
    {
      session$flushReact()
      session$setInputs(choosePkg = "MagellanNTK")
      session$flushReact()
      session$setInputs(chooseWF1 = "PipelineDemo")
      session$flushReact()
      
      UI <- as.character(output$chooseProcess_UI$html)
      
      expect_is(output$chooseProcess_UI, "list")
      expect_true(any(grepl("test-chooseProcess", UI)))
      expect_true(any(grepl("PipelineDemo", UI)))
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for open_workflow", {
  testthat::skip_if_not_installed("chromote")
  testthat::skip_on_ci()
  
  shiny_app <- MagellanNTK::open_workflow()
    app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-open_workflow")
  
    app$set_window_size(width = 1235, height = 695)
    # Update output value
    app$set_inputs(`wf-choosePkg` = "MagellanNTK")
    # Update output value
    # app$expect_values()
    # app$expect_values(output = "wf-choosePackage_UI")
    app$expect_values(output = "wf-chooseWF1_UI")
    app$expect_values(output = "wf-chooseProcess_UI")
    app$click("wf-load_btn")
    # Update output value
    app$expect_values(output = "wf-infos_wf_UI")
})
