library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("infos_dataset_ui returns a tagList", {
  ui <- infos_dataset_ui("test_id")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("infos_dataset_ui contains h3 with correct text", {
  ui <- infos_dataset_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("This is the default module infos_dataset of MagellanNTK", ui_as_char)))
  expect_true(any(grepl("It can be customized", ui_as_char)))
})

test_that("infos_dataset_ui contains all expected uiOutput elements", {
  ui <- infos_dataset_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-choose_SE_ui", ui_as_char)))
  expect_true(any(grepl("test_id-show_SE_ui", ui_as_char)))
})

test_that("infos_dataset returns a shiny app", {
  obj <- NULL  # Mock a MultiAssayExperiment object
  suppressMessages(suppressWarnings({
    app <- tryCatch(infos_dataset(obj), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----
df1 <- as.data.frame(matrix(1:4, nrow = 2, ncol = 2))
colnames(df1) <- c("S1", "S2")
rownames(df1) <- c("prot1", "prot2")
df2 <- as.data.frame(matrix(5:8, nrow = 2, ncol = 2))
colnames(df2) <- c("S1", "S2")
rownames(df2) <- c("prot1", "prot2")
se1 <- SummarizedExperiment::SummarizedExperiment(
  assays = list(counts = df1),
  rowData = data.frame(prot = c("prot1", "prot2")),
  colData = data.frame(sample = c("S1", "S2")))
se2 <- SummarizedExperiment::SummarizedExperiment(
  assays = list(exprs = df2),
  rowData = data.frame(prot = c("prot1", "prot2")),
  colData = data.frame(sample = c("S1", "S2")))
mock_mae <- MultiAssayExperiment::MultiAssayExperiment(list(Assay1 = se1, Assay2 = se2))

test_that("rv$dataIn updates when dataIn is a MultiAssayExperiment", {
  testServer(
    infos_dataset_server,
    args = list(
      dataIn = reactive(mock_mae)
    ),
    {
      expect_true(is.null(rv$dataIn)) # Initially NULL
      session$flushReact()
      expect_s4_class(rv$dataIn, "MultiAssayExperiment")
      expect_equal(rv$dataIn, mock_mae)
    }
  )
})

test_that("rv$dataIn remains NULL when dataIn is not a MultiAssayExperiment", {
  testServer(
    infos_dataset_server,
    args = list(
      dataIn = reactive(data.frame(a = 1:3))
    ),
    {
      session$flushReact()
      expect_true(is.null(rv$dataIn))
    }
  )
})

test_that("output$choose_SE_ui renders when rv$dataIn is set", {
  testServer(
    infos_dataset_server,
    args = list(
      dataIn = reactive(mock_mae)
    ),
    {
      session$flushReact()
      ui_output <- output$choose_SE_ui
      expect_true(!is.null(ui_output))
      expect_true(inherits(ui_output, "list"))
      # Check if the choices are the assay names
      assay_names <- names(mock_mae)
      expect_match(ui_output[[1]], assay_names[1])
      expect_match(ui_output[[1]], assay_names[2])
    }
  )
})

test_that("output$show_SE_ui renders when all requirements are met", {
  testServer(
    infos_dataset_server,
    args = list(
      dataIn = reactive(mock_mae)
    ),
    {
      session$flushReact()
      # Set the input for selectInputSE to the first assay
      assay_names <- names(MultiAssayExperiment::experiments(mock_mae))
      session$setInputs(selectInputSE = assay_names[1])
      session$flushReact()
      
      ui_output <- output$show_SE_ui
      expect_true(!is.null(ui_output))
      expect_true(inherits(ui_output, "list"))
    }
  )
})


# shinytest2 ----
test_that("shinytest2 tests for infos_dataset", {
  data(lldata123)
  shiny_app <- MagellanNTK::infos_dataset(lldata123)
  app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-infos_dataset")
  
  app$set_window_size(width = 1235, height = 695)
  # Update output value
  # Update unbound `input` value
  app$expect_values()
  app$set_inputs(`mod_info-selectInputSE` = "DataGeneration")
  # Update output value
  # Update unbound `input` value
  app$expect_values()
  app$set_inputs(`mod_info-selectInputSE` = "Preprocessing")
  # Update output value
  # Update unbound `input` value
  app$expect_values()
  app$set_inputs(`mod_info-selectInputSE` = "Clustering")
  # Update output value
  # Update unbound `input` value
  app$expect_values()
  app$expect_values(output = "mod_info-dt2-StaticDataTable")
  app$expect_values(output = "mod_info-dt2-StaticDataTable")
})
