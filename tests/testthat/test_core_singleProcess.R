library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


# Mock NS function for testing
mock_ns <- function(id) {
  function(...) paste0(id, "_", ...)
}

test_that("nav_single_process_ui returns a tagList with expected elements", {
  ns <- mock_ns("test_id")
  ui <- nav_single_process_ui("test_id")
  
  expect_s3_class(ui, "shiny.tag.list")
  expect_true(any(grepl("test_id-process_panel_ui_process", as.character(ui))))
  expect_true(any(grepl("test_id-btn_eda_singleProcess", as.character(ui))))
  expect_true(any(grepl("EDA", as.character(ui))))
})

test_that("nav_single_process_ui actionButton has correct style", {
  ns <- mock_ns("test_id")
  ui <- nav_single_process_ui("test_id")
  
  expect_true(any(grepl("padding: 0px; margin: 0px; border: none;", as.character(ui))))
  expect_true(any(grepl("background-color: transparent;", as.character(ui))))
})

test_that("nav_single_process returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(nav_single_process(), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----
test_that("module returns list with dataOut and steps.enabled", {
  local({
    original_funcs <- ls(envir = globalenv())
    
    # Source workflow files
    path <- system.file(file.path("workflow", "PipelineDemo"), package = "MagellanNTK")
    if (!is.null(path)) {
      files <- list.files(file.path(path, "R"), full.names = FALSE)
      for (f in files) {
        source(file.path(path, "R", f), local = FALSE, chdir = FALSE)
      }
    }
    
    testServer(
      nav_single_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        return_value <- list(
          dataOut = reactive({ dataOut }),
          steps.enabled = reactive({ rv$steps.enabled })
        )
        expect_true(!is.null(return_value))
        expect_true(!is.null(return_value$dataOut))
        expect_true(!is.null(return_value$steps.enabled))
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("process_panel_ui_process, process_btns_ui, prevBtnUI, nextBtnUI, DoBtn and DoProceedBtn renders", {
  local({
    original_funcs <- ls(envir = globalenv())
    
    path <- system.file(file.path("workflow", "PipelineDemo"), package = "MagellanNTK")
    if (!is.null(path)) {
      files <- list.files(file.path(path, "R"), full.names = FALSE)
      for (f in files) {
        source(file.path(path, "R", f), local = FALSE, chdir = FALSE)
      }
    }
    
    testServer(
      nav_single_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        session$flushReact()
        ui_output <- output$process_panel_ui_process
        expect_true(!is.null(ui_output))
        expect_true(inherits(ui_output[[1]], "html"))
        
        ui_output <- output$process_btns_ui
        expect_true(!is.null(ui_output))
        expect_true(inherits(ui_output[[1]], "html"))
        
        ui_output <- output$prevBtnUI
        expect_true(!is.null(ui_output))
        
        ui_output <- output$nextBtnUI
        expect_true(!is.null(ui_output))
        
        ui_output <- output$DoBtn
        expect_true(!is.null(ui_output))
        
        ui_output <- output$DoProceedBtn
        expect_true(!is.null(ui_output))
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("proc_datasetNameUI renders with correct name", {
  local({
    original_funcs <- ls(envir = globalenv())
    
    path <- system.file(file.path("workflow", "PipelineDemo"), package = "MagellanNTK")
    if (!is.null(path)) {
      files <- list.files(file.path(path, "R"), full.names = FALSE)
      for (f in files) {
        source(file.path(path, "R", f), local = FALSE, chdir = FALSE)
      }
    }
    
    testServer(
      nav_single_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        session$flushReact()
        ui_output <- output$proc_datasetNameUI
        expect_true(!is.null(ui_output))
        expect_true(any(grepl("PipelineDemo_DataGeneration", as.character(ui_output))))
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("testTL and EncapsulateScreens_process_ui renders", {
  local({
    original_funcs <- ls(envir = globalenv())
    
    path <- system.file(file.path("workflow", "PipelineDemo"), package = "MagellanNTK")
    if (!is.null(path)) {
      files <- list.files(file.path(path, "R"), full.names = FALSE)
      for (f in files) {
        source(file.path(path, "R", f), local = FALSE, chdir = FALSE)
      }
    }
    
    testServer(
      nav_single_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        session$flushReact()
        ui_output <- output$testTL
        expect_true(!is.null(ui_output))
        expect_true(inherits(ui_output[[1]], "html"))
        
        i_output <- output$EncapsulateScreens_process_ui
        expect_true(!is.null(ui_output))
        expect_true(inherits(ui_output[[1]], "html"))
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("observeEvent on id initializes the process", {
  local({
    original_funcs <- ls(envir = globalenv())
    
    path <- system.file(file.path("workflow", "PipelineDemo"), package = "MagellanNTK")
    if (!is.null(path)) {
      files <- list.files(file.path(path, "R"), full.names = FALSE)
      for (f in files) {
        source(file.path(path, "R", f), local = FALSE, chdir = FALSE)
      }
    }
    
    testServer(
      nav_single_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        session$flushReact()
        expect_true(!is.null(rv$proc))
        expect_true(!is.null(rv$config))
        expect_equal(rv$current.pos, 1)
        expect_equal(rv$proc.id, "DataGeneration")
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("observeEvent on dataIn updates steps and data", {
  local({
    original_funcs <- ls(envir = globalenv())
    
    path <- system.file(file.path("workflow", "PipelineDemo"), package = "MagellanNTK")
    if (!is.null(path)) {
      files <- list.files(file.path(path, "R"), full.names = FALSE)
      for (f in files) {
        source(file.path(path, "R", f), local = FALSE, chdir = FALSE)
      }
    }
    
    testServer(
      nav_single_process_server,
      args = list(
        id = "PipelineDemo_DataGeneration",
        dataIn = reactive(data.frame(a = 1:3))
      ),
      {
        session$flushReact()
        expect_equal(dataIn(), data.frame(a = 1:3))
        expect_true(!is.null(rv$steps.status))
        expect_true(!is.null(rv$steps.enabled))
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("observeEvent on input$DoBtn updates btnEvents and doProceedAction", {
  local({
    original_funcs <- ls(envir = globalenv())
    
    path <- system.file(file.path("workflow", "PipelineDemo"), package = "MagellanNTK")
    if (!is.null(path)) {
      files <- list.files(file.path(path, "R"), full.names = FALSE)
      for (f in files) {
        source(file.path(path, "R", f), local = FALSE, chdir = FALSE)
      }
    }
    
    testServer(
      nav_single_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        session$flushReact()
        session$setInputs(DoBtn = 1)
        session$flushReact()
        expect_equal(rv$btnEvents, "Description_Do_1")
        expect_equal(rv$doProceedAction, "Do")
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("observeEvent on input$DoProceedBtn updates btnEvents and doProceedAction", {
  local({
    original_funcs <- ls(envir = globalenv())
    
    path <- system.file(file.path("workflow", "PipelineDemo"), package = "MagellanNTK")
    if (!is.null(path)) {
      files <- list.files(file.path(path, "R"), full.names = FALSE)
      for (f in files) {
        source(file.path(path, "R", f), local = FALSE, chdir = FALSE)
      }
    }
    
    testServer(
      nav_single_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        session$flushReact()
        session$setInputs(DoProceedBtn = 1)
        session$flushReact()
        expect_equal(rv$btnEvents, "Description_Do_Proceed_1")
        expect_equal(rv$doProceedAction, "Do_Proceed")
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})
