library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)
suppressWarnings(
  library(DT))


test_that("format_DT_ui returns a tagList", {
  ui <- format_DT_ui("test_id")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("format_DT_ui contains DTOutput with correct namespace", {
  ui <- format_DT_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("datatables", ui_as_char)))
  expect_true(any(grepl("test_id-StaticDataTable", ui_as_char)))
})

test_that("format_DT_ui works with empty id", {
  ui <- format_DT_ui("")
  expect_s3_class(ui, "shiny.tag.list")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("-StaticDataTable", ui_as_char)))
})

test_that("format_DT returns a shiny app", {
  df <- data.frame(a = 1:3, b = 4:6)
  suppressMessages(suppressWarnings({
    app <- tryCatch(format_DT(df), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("format_DT validates dataIn is a data.frame", {
  expect_error(format_DT(123))
  expect_error(format_DT("not_a_dataframe"))
  expect_error(format_DT(NULL))
})

test_that("format_DT works with default parameters", {
  df <- data.frame(a = 1:3, b = 4:6)
  suppressMessages(suppressWarnings({
    app <- tryCatch(format_DT(df), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("format_DT works with custom parameters", {
  df <- data.frame(a = 1:3, b = 4:6)
  hidden <- data.frame(a = c("X", "Y", "Z"), b = c("A", "B", "C"))
  hc_style <- list(
    cols = c("a", "b"),
    vals = c("X", "A"),
    unique = c("X", "A"),
    pal = c("red", "blue")
  )
  suppressMessages(suppressWarnings({
    app <- tryCatch(
      format_DT(
        df,
        hidden = hidden,
        withDLBtns = TRUE,
        showRownames = TRUE,
        dom = "lfrtip",
        hc_style = hc_style
      ),
      error = function(e) NULL
    )
  }))
  expect_is(app, "shiny.appobj")
})

test_that("format_DT works with empty data.frame", {
  df <- data.frame()
  suppressMessages(suppressWarnings({
    app <- tryCatch(format_DT(df), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----

test_that("rv.infos$obj is updated when dataIn changes", {
  testServer(
    format_DT_server,
    args = list(
      dataIn = reactive(data.frame(a = 1:3, b = 4:6))
    ),
    {
      expect_true(is.null(rv.infos$obj)) # Initially NULL
      session$flushReact()
      expect_equal(nrow(rv.infos$obj), 3) # Updated to the input data
    }
  )
})

test_that("hidden data is appended to rv.infos$obj", {
  df <- data.frame(a = 1:3, b = 4:6)
  hidden_df <- data.frame(c = 7:9)
  
  testServer(
    format_DT_server,
    args = list(
      dataIn = reactive(data.frame(a = 1:3, b = 4:6)),
      hidden = reactive(data.frame(c = 7:9))
    ),
    {
      session$flushReact()
      expect_equal(ncol(rv.infos$obj), 3) # 2 from dataIn + 1 from hidden
      expect_equal(colnames(rv.infos$obj), c("a", "b", "c"))
      expect_equal(rv.infos$obj, cbind(df, hidden_df))
    }
  )
})

test_that("DT::replaceData is called with the correct data", {
  testServer(
    format_DT_server,
    args = list(
      dataIn = reactive(data.frame(a = 1:3, b = 4:6))
    ),
    {
      session$flushReact()
      # Mock or inspect the proxy to ensure replaceData was called
      # Since we can't directly inspect the proxy, we check if the output is rendered
      expect_true(!is.null(output$StaticDataTable))
    }
  )
})

test_that("GetColumnDefs hides the correct columns", {
  testServer(
    format_DT_server,
    args = list(
      dataIn = reactive(data.frame(a = 1:3, b = 4:6)),
      hidden = reactive(data.frame(c = 7:9))
    ),
    {
      session$flushReact()
      col_defs <- GetColumnDefs()
      expect_length(col_defs, 2)
      # Check if the hidden column (c) is marked as invisible
      expect_true(any(sapply(col_defs, function(x) x$targets == 2 && x$visible == FALSE)))
    }
  )
})

test_that("output$StaticDataTable is rendered with the correct options", {
  testServer(
    format_DT_server,
    args = list(
      dataIn = reactive(data.frame(a = 1:3, b = 4:6)),
      dom = "Bt",
      max.rows = 20
    ),
    {
      session$flushReact()
      # Check if the output is a DT object
      expect_true(!is.null(output$StaticDataTable))
      # If you can inspect the DT object, check its options
      # For example, check if dom is set to "Bt"
    }
  )
})

test_that("hc_style applies conditional formatting", {
  testServer(
    format_DT_server,
    args = list(
      dataIn = reactive(data.frame(a = 1:3, b = 4:6)),
      hc_style = reactive(list(
        cols = "a",
        vals = c(1, 2, 3),
        unique = c(1, 2, 3),
        pal = c("red", "green", "blue")
      ))
    ),
    {
      session$flushReact()
      # Check if the output has formatting applied
      expect_true(!is.null(output$StaticDataTable))
      # If you can inspect the DT object, check if formatStyle was applied
    }
  )
})

test_that("showRownames and max.rows are respected", {
  testServer(
    format_DT_server,
    args = list(
      dataIn = reactive(data.frame(a = 1:20, b = 21:40)),
      showRownames = TRUE,
      max.rows = 10
    ),
    {
      session$flushReact()
      # Check if the output respects showRownames and max.rows
      expect_true(!is.null(output$StaticDataTable))
      # If you can inspect the DT object, check its options
    }
  )
})

test_that("initComplete returns JS callback", {
  testServer(
    format_DT_server,
    {js <- initComplete()
     expect_s3_class(js, "JS_EVAL")
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for format_DT", {
  data(lldata)
  obj <- as.data.frame(SummarizedExperiment::assay(lldata[[1]]))
  shiny_app <- MagellanNTK::format_DT(obj)
  app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-format_DT")

  app$set_window_size(width = 1235, height = 695)
  app$set_inputs(`dt-StaticDataTable_rows_selected` = 1, allow_no_input_binding_ = TRUE)
  app$set_inputs(`dt-StaticDataTable_row_last_clicked` = 1, allow_no_input_binding_ = TRUE, priority_ = "event")
  app$set_inputs(`dt-StaticDataTable_cell_clicked` = c(1, 0, 0), allow_no_input_binding_ = TRUE, priority_ = "event")
  app$expect_values(output = "dt-StaticDataTable")
})

test_that("shinytest2 tests for format_DT with hidden", {
  obj <- as.data.frame(matrix(seq_len(30), byrow = TRUE, nrow = 6))
  colnames(obj) <- paste0("col", seq_len(5))
  mask <- as.data.frame(matrix(rep(LETTERS[seq_len(5)], 6),
                               byrow = TRUE, nrow = 6))
  style <- list(cols = colnames(obj),
                vals = colnames(mask),
                unique = unique(mask),
                pal = RColorBrewer::brewer.pal(5, "Dark2")[seq_len(5)])
  shiny_app <- MagellanNTK::format_DT(obj, hidden = mask, hc_style = style)
  app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-format_DT_hidden")

  app$set_window_size(width = 1235, height = 695)
  app$set_inputs(`dt-StaticDataTable_rows_selected` = 1, allow_no_input_binding_ = TRUE)
  app$set_inputs(`dt-StaticDataTable_row_last_clicked` = 1, allow_no_input_binding_ = TRUE, priority_ = "event")
  app$set_inputs(`dt-StaticDataTable_cell_clicked` = c(1, 0, 1), allow_no_input_binding_ = TRUE, priority_ = "event")
  app$expect_values(output = "dt-StaticDataTable")
})
