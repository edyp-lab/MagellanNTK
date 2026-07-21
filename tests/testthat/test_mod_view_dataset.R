library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("view_dataset_ui returns a tagList", {
  ui <- view_dataset_ui("test_id")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("view_dataset_ui contains h3 with correct text", {
  ui <- view_dataset_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("This is the default module infos_dataset of MagellanNTK", ui_as_char)))
  expect_true(any(grepl("It can be customized", ui_as_char)))
})

test_that("view_dataset_ui contains uiOutput with correct namespace", {
  ui <- view_dataset_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-choose_SE_ui", ui_as_char)))
})

test_that("view_dataset_ui contains plotOutput with correct namespace", {
  ui <- view_dataset_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-plot_ui", ui_as_char)))
})

test_that("view_dataset returns a shiny app", {
  dataIn <- NULL  # Mock a MultiAssayExperiment object
  suppressMessages(suppressWarnings({
    app <- tryCatch(view_dataset(dataIn), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----

test_that("server loads the data", {
  data(lldata123)
  testServer(
    view_dataset_server,
    args = list(
      dataIn = reactive(lldata123)
    ),
    {expect_true(is.null(rv$dataIn))
      session$flushReact()
      expect_s4_class(rv$dataIn, "MultiAssayExperiment")
    }
  )
})

test_that("plot updates for every assay", {
  data(lldata123)
  testServer(
    view_dataset_server,
    args = list(
      dataIn = reactive(lldata123)
    ),
    {session$flushReact()
      assays <- c(
        "DataGeneration",
        "Preprocessing",
        "Clustering"
      )
      for (assay_name in assays) {
        session$setInputs(selectInputSE = assay_name)
        session$flushReact()
        
        expect_true(!is.null(output$plot_ui))
      }
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for view_dataset", {
  testthat::skip_if_not_installed("chromote")
  testthat::skip_on_ci()
  
  data(lldata123)
  shiny_app <- MagellanNTK::view_dataset(lldata123)
  app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-view_dataset")
  
  app$set_window_size(width = 1235, height = 695)
  app$expect_values(output = "modviewDataset-plot_ui")
  app$set_inputs(`modviewDataset-selectInputSE` = "DataGeneration")
  # Update output value
  app$expect_values(output = "modviewDataset-plot_ui")
  app$set_inputs(`modviewDataset-selectInputSE` = "Preprocessing")
  # Update output value
  app$expect_values(output = "modviewDataset-plot_ui")
  app$set_inputs(`modviewDataset-selectInputSE` = "Clustering")
  # Update output value
  app$expect_values(output = "modviewDataset-plot_ui")
})
