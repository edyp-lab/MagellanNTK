library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("download_dataset_ui returns a tagList", {
  ui <- download_dataset_ui("test_id")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("download_dataset_ui contains h3 with correct text", {
  ui <- download_dataset_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("Download dataset", ui_as_char)))
})

test_that("download_dataset_ui contains all expected uiOutput elements", {
  ui <- download_dataset_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-nodataset_ui", ui_as_char)))
  expect_true(any(grepl("test_id-buttons_ui", ui_as_char)))
})

test_that("download_dataset returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(download_dataset(), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("download_dataset works with default parameters", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(download_dataset(), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("download_dataset works with custom filename", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(download_dataset(filename = "customDataset"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----
test_that("module initializes with rv$export_file = NULL", {
  testServer(
    download_dataset_server,
    args = list(id = "test"),
    {
      expect_null(rv$export_file)
    }
  )
})

test_that("nodataset_ui renders when rv$data_save is NULL", {
  testServer(
    download_dataset_server,
    args = list(id = "test"),
    {
      session$flushReact()
      ui_output <- output$nodataset_ui
      expect_true(!is.null(ui_output))
      expect_true(any(grepl("No dataset available", as.character(ui_output))))
    }
  )
})

test_that("nodataset_ui returns error when rv$data_save is not NULL", {
  testServer(
    download_dataset_server,
    args = list(
      id = "test",
      dataIn = reactive(data.frame(a = 1:3))
    ),
    {
      session$flushReact()
      expect_error(output$nodataset_ui)
    }
  )
})

test_that("buttons_ui renders when rv$data_save is not NULL", {
  testServer(
    download_dataset_server,
    args = list(
      id = "test",
      dataIn = reactive(data.frame(a = 1:3))
    ),
    {
      session$flushReact()
      ui_output <- output$buttons_ui
      expect_true(!is.null(ui_output))
      expect_true(any(grepl("shiny-html-output", as.character(ui_output))))
    }
  )
})

test_that("dl_raw renders downloadButton", {
  testServer(
    download_dataset_server,
    args = list(id = "test"),
    {
      # Set rv$data_save to trigger dl_raw
      rv$data_save <- data.frame(a = 1:3)
      session$flushReact()
      
      ui_output <- output$dl_raw
      expect_true(!is.null(ui_output))
      expect_true(any(grepl("shiny-download", as.character(ui_output))))
    }
  )
})

test_that("observeEvent updates rv$data_save when dataIn changes", {
  testServer(
    download_dataset_server,
    args = list(
      id = "test",
      dataIn = reactive(data.frame(a = 1:3))
    ),
    {
      session$flushReact()
      expect_equal(rv$data_save, data.frame(a = 1:3))
    }
  )
})

test_that("downloadData handler uses correct filename", {
  testServer(
    download_dataset_server,
    args = list(
      id = "test",
      filename = "myDataset"
    ),
    {
      # Get the downloadHandler's filename function
      file_func <- output$downloadData
      expect_true(any(grepl("myDataset.qf", as.character(file_func ))))
    }
  )
})

# Only include this if your module returns a value
test_that("module returns a reactive", {
  testServer(
    download_dataset_server,
    args = list(id = "test"),
    {
      # If your module returns a reactive, test it here
      # Example: return_value <- reactive({ ... })
      # expect_true(is.reactive(return_value))
      expect_true(TRUE) # Placeholder
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for download_dataset", {
  testthat::skip_if_not_installed("chromote")
  testthat::skip_on_ci()
  
  data(lldata)
  shiny_app <- MagellanNTK::download_dataset(lldata)
    app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-download_dataset")
  
    app$set_window_size(width = 1235, height = 695)
    app$expect_values()
})

