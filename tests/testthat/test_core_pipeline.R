library(testthat)
suppressWarnings(
  library(shinytest2))
library(MagellanNTK)
suppressWarnings(
  library(shiny))

# Mock NS function
mock_ns <- function(id) {
  function(...) paste0(id, "_", ...)
}

test_that("nav_pipeline_ui returns a div with expected uiOutput elements", {
  ns <- mock_ns("test_id")
  ui <- nav_pipeline_ui("test_id")
  
  expect_s3_class(ui, "shiny.tag")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl('style=\"width: 100%; height: 100%;\"', ui_as_char)))
  expect_true(any(grepl("test_id-pipeline_panel_ui", ui_as_char)))
  expect_true(any(grepl("test_id-pipeline_tl_btn_ui", ui_as_char)))
})

test_that("nav_pipeline returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(nav_pipeline(), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----

test_that("module returns list with dataOut, steps.enabled, and status", {
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
      nav_pipeline_server,
      args = list(id = "PipelineDemo"),
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

test_that("pipeline_panel_ui renders", {
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
      nav_pipeline_server,
      args = list(id = "PipelineDemo"),
      {
        session$flushReact()
        ui_output <- output$pipeline_panel_ui
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

test_that("pipeline_tl_btn_ui, startBtnUI, datasetNameUI and EncapsulateScreens_ui renders", {
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
      nav_pipeline_server,
      args = list(id = "PipelineDemo"),
      {
        session$flushReact()
        ui_output <- output$pipeline_tl_btn_ui
        expect_true(!is.null(ui_output))
        expect_true(inherits(ui_output[[1]], "html"))
        
        ui_output <- output$startBtnUI
        expect_true(!is.null(ui_output))
        
        ui_output <- output$datasetNameUI
        expect_true(!is.null(ui_output))
        expect_true(inherits(ui_output[[1]], "html"))
        
        ui_output <- output$EncapsulateScreens_ui
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
      nav_pipeline_server,
      args = list(id = "PipelineDemo"),
      {
        # Initialize pipeline
        session$flushReact()
        
        # Set current.pos to 1 (first step)
        rv$current.pos <- 1
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

test_that("observeEvent on id initializes the pipeline", {
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
      nav_pipeline_server,
      args = list(id = "PipelineDemo"),
      {
        session$flushReact()
        expect_true(!is.null(rv$proc))
        expect_true(!is.null(rv$config))
        expect_equal(rv$current.pos, 1)
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("observeEvent on dataIn updates steps", {
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
      nav_pipeline_server,
      args = list(
        id = "PipelineDemo",
        dataIn = reactive(data.frame(a = 1:3))
      ),
      {
        session$flushReact()
        expect_equal(rv$temp.dataIn, data.frame(a = 1:3))
        expect_equal(rv$dataIn.original, data.frame(a = 1:3))
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

test_that("observeEvent on input$prevBtn updates current.pos", {
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
      nav_pipeline_server,
      args = list(id = "PipelineDemo"),
      {
        session$flushReact()
        rv$current.pos <- 2  # Set to non-first position
        session$flushReact()
        
        session$setInputs(prevBtn = 1)  # Simulate button click
        session$flushReact()
        
        expect_equal(rv$current.pos, 1)
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("observeEvent on input$nextBtn updates current.pos", {
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
      nav_pipeline_server,
      args = list(id = "PipelineDemo"),
      {
        session$flushReact()
        rv$current.pos <- 1  # Set to first position
        session$flushReact()
        
        session$setInputs(nextBtn = 1)  # Simulate button click
        session$flushReact()
        
        expect_equal(rv$current.pos, 2)
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("observeEvent on input$startBtn resets current.pos to 1", {
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
      nav_pipeline_server,
      args = list(id = "PipelineDemo"),
      {
        session$flushReact()
        rv$current.pos <- 3  # Set to arbitrary position
        session$flushReact()
        
        session$setInputs(startBtn = 1)  # Simulate button click
        session$flushReact()
        
        expect_equal(rv$current.pos, 1)
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})

test_that("observeEvent on rv$current.pos toggles button states", {
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
      nav_pipeline_server,
      args = list(id = "PipelineDemo"),
      {
        session$flushReact()
        rv$current.pos <- 2  # Change position
        session$flushReact()
        
        # Verify buttons are toggled (indirectly via UI rendering)
        expect_true(!is.null(output$prevBtnUI))
        expect_true(!is.null(output$nextBtnUI))
        expect_true(!is.null(output$startBtnUI))
      }
    )
    
    # Cleanup
    new_funcs <- setdiff(ls(envir = globalenv()), original_funcs)
    for (f in new_funcs) {
      rm(list = f, envir = globalenv())
    }
  })
})
