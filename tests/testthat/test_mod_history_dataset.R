library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("history_dataset_ui returns a div", {
  ui <- history_dataset_ui("test_id")
  expect_s3_class(ui, "shiny.tag")
})

test_that("history_dataset_ui has correct style", {
  ui <- history_dataset_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl('height: 600px', ui_as_char)))
})

test_that("history_dataset_ui contains p with correct text", {
  ui <- history_dataset_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("Default implementation of this content", ui_as_char)))
})

test_that("history_dataset_ui contains format_DT_ui with correct namespace", {
  ui <- history_dataset_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-history", ui_as_char)))
})

test_that("history_dataset returns a shiny app", {
  obj <- NULL  # Mock a MultiAssayExperiment object
  suppressMessages(suppressWarnings({
    app <- tryCatch(history_dataset(obj), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----

test_that("history_dataset_server computes MAE history", {
  data(lldata123)
  testServer(
    history_dataset_server,
    args = list(
      dataIn = reactive(lldata123)
    ),
    { expect_true(is.null(rv$dataIn)) # Initially NULL
      
      session$flushReact()
      expect_s4_class(rv$dataIn, "MultiAssayExperiment") # Updated to the input
      
      # internal reactive exists and is valid
      expect_true(exists("Get_MAE_History"))
      
      hist_df <- Get_MAE_History()
      expect_true(is.data.frame(hist_df))
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for history_dataset", {
  data(lldata)
  shiny_app <- MagellanNTK::history_dataset(lldata)
  app = shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-history_dataset")
  
  app$set_window_size(width = 1235, height = 695)
  app$set_inputs(`mod_info-history-StaticDataTable_rows_selected` = 1, allow_no_input_binding_ = TRUE)
  app$set_inputs(`mod_info-history-StaticDataTable_row_last_clicked` = 1, allow_no_input_binding_ = TRUE, priority_ = "event")
  app$set_inputs(`mod_info-history-StaticDataTable_cell_clicked` = c("1", "2", "-"), allow_no_input_binding_ = TRUE, priority_ = "event")
  app$expect_values(output = "mod_info-history-StaticDataTable")
})
