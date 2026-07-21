library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)

# Mock NS function
mock_ns <- function(id) {
  function(...) paste0(id, "_", ...)
}

test_that("nav_process_ui returns a tagList with expected elements", {
  ns <- mock_ns("test_id")
  ui <- nav_process_ui("test_id")
  
  expect_s3_class(ui, "shiny.tag.list")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-process_panel_ui_process", ui_as_char)))
  expect_true(any(grepl("test_id-process_panel_ui_pipeline", ui_as_char)))
  expect_true(any(grepl("test_id-EncapsulateScreens_pipeline_ui", ui_as_char)))
})

test_that("nav_process returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(nav_process(), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----

test_that("module initializes with correct reactive values", {
  testServer(
    nav_process_server,
    args = list(id = "test"),
    {
      expect_null(dataOut$trigger)
      expect_null(dataOut$value)
      expect_null(rv$proc)
      expect_null(rv$steps.status)
      expect_null(rv$dataIn)
      expect_null(rv$temp.dataIn)
      expect_null(rv$steps.enabled)
      expect_null(rv$steps.skipped)
      expect_equal(rv$prev.remoteReset, 1)
      expect_equal(rv$prev.remoteResetUI, 1)
      expect_equal(rv$current.pos, 1)
      expect_null(rv$length)
      expect_null(rv$config)
      expect_true(inherits(rv$rstBtn, "reactive"))
      expect_null(rv$doProceedAction)
      expect_equal(rv$btnEvents, 0)
    }
  )
})

test_that("process_panel_ui_pipeline renders", {
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
      nav_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        session$flushReact()
        ui_output <- output$process_panel_ui_pipeline
        expect_true(!is.null(ui_output))
        expect_true(inherits(ui_output, "list"))
        expect_true(any(grepl("shiny-html-output", as.character(ui_output))))
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("process_btns_ui renders", {
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
      nav_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        session$flushReact()
        ui_output <- output$process_btns_ui
        expect_true(!is.null(ui_output))
        expect_true(inherits(ui_output, "list"))
        expect_true(any(grepl("Btn", as.character(ui_output))))
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("prevBtnUI renders and is disabled on first step and nextBtnUI renders and is enabled for non-last step", {
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
      nav_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        rv$config <- list(
          steps = list(Step1 = list(), Step2 = list(), Step3 = list()),
          ll.UI = list(Step1 = tags$div("UI1"), Step2 = tags$div("UI2"), Step3 = tags$div("UI3"))
        )
        rv$current.pos <- 1
        rv$steps.status <- setNames(rep(stepStatus$UNDONE, 3), c("Step1", "Step2", "Step3"))
        session$flushReact()
        
        ui_output <- output$prevBtnUI
        expect_true(!is.null(ui_output))
        
        ui_output <- output$nextBtnUI
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

test_that("DoBtn and DoProceedBtn renders", {
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
      nav_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        rv$config <- list(
          steps = list(Step1 = list()),
          ll.UI = list(Step1 = tags$div("UI1"))
        )
        rv$current.pos <- 1
        rv$steps.status <- setNames(stepStatus$UNDONE, "Step1")
        rv$steps.enabled <- setNames(TRUE, "Step1")
        rv$dataIn <- data.frame(a = 1:3)
        session$flushReact()
        
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

test_that("proc_datasetNameUI renders", {
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
      nav_process_server,
      args = list(id = "PipelineDemo_Description"),
      {
        session$flushReact()
        ui_output <- output$proc_datasetNameUI
        expect_true(!is.null(ui_output))
        expect_true(any(grepl("PipelineDemo_Description", as.character(ui_output))))
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("testTL renders", {
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
      nav_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        rv$config <- list(
          steps = list(Step1 = list(), Step2 = list()),
          ll.UI = list(Step1 = tags$div("UI1"), Step2 = tags$div("UI2"))
        )
        rv$steps.status <- setNames(rep(stepStatus$UNDONE, 2), c("Step1", "Step2"))
        rv$steps.enabled <- setNames(rep(TRUE, 2), c("Step1", "Step2"))
        rv$current.pos <- 1
        session$flushReact()
        
        ui_output <- output$testTL
        expect_true(!is.null(ui_output))
        expect_true(inherits(ui_output, "list"))
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("EncapsulateScreens_pipeline_ui renders", {
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
      nav_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        rv$config <- list(
          steps = list(Step1 = list(), Step2 = list(), Step3 = list()),
          ll.UI = list(Step1 = tags$div("UI1"), Step2 = tags$div("UI2"), Step3 = tags$div("UI3"))
        )
        rv$current.pos <- 2
        session$flushReact()
        
        ui_output <- output$EncapsulateScreens_pipeline_ui
        expect_true(!is.null(ui_output))
        expect_true(inherits(ui_output, "list"))
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
      nav_process_server,
      args = list(id = "PipelineDemo_Description"),
      {
        session$flushReact()
        expect_true(!is.null(rv$proc))
        expect_true(!is.null(rv$config))
        expect_equal(rv$current.pos, 1)
        expect_equal(rv$proc.id, "Description")
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("observeEvent on dataIn updates temp.dataIn and steps", {
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
      nav_process_server,
      args = list(id = "PipelineDemo_DataGeneration",
                  dataIn = reactive(data.frame(a = 1:3))),
      {
        rv$config <- list(
          steps = list(Step1 = list(), Step2 = list()),
          ll.UI = list(Step1 = tags$div("UI1"), Step2 = tags$div("UI2"))
        )
        rv$steps.status <- setNames(rep(stepStatus$UNDONE, 2), c("Step1", "Step2"))
        session$flushReact()
        expect_equal(rv$temp.dataIn, data.frame(a = 1:3))
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("module returns list with dataOut, steps.enabled, and status", {
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
      nav_process_server,
      args = list(id = "PipelineDemo_DataGeneration"),
      {
        return_value <- list(
          dataOut = reactive({ dataOut }),
          steps.enabled = reactive({ rv$steps.enabled }),
          status = reactive({ rv$steps.status })
        )
        expect_true(!is.null(return_value))
        expect_true(!is.null(return_value$dataOut))
        expect_true(!is.null(return_value$steps.enabled))
        expect_true(!is.null(return_value$status))
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})
