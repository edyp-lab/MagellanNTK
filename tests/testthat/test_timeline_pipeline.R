library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("timeline_pipeline_ui returns a tagList", {
  ui <- timeline_pipeline_ui("test_id")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("timeline_pipeline_ui contains uiOutput with correct namespace", {
  ui <- timeline_pipeline_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-show_pipeline_TL", ui_as_char)))
})

test_that("timeline_pipeline returns a shiny app", {
  config <- list(
    mode = "pipeline",
    fullname = "Test",
    steps = c("Step1", "Step2"),
    mandatory = c(TRUE, FALSE)
  )
  status <- reactive({ c(1, 0) })
  position <- reactive({ 1 })
  enabled <- reactive({ c(TRUE, FALSE) })
  
  suppressMessages(suppressWarnings({
    app <- tryCatch(
      timeline_pipeline(config, status, position, enabled),
      error = function(e) NULL
    )
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----

test_that("UpdateTags returns the correct status tags for a Config object", {
  # Create a Config object
  mock_config <- Config(
    fullname = "TestPipeline",
    mode = "pipeline",
    steps = c("Step1", "Step2", "Step3"),
    mandatory = c(FALSE, TRUE, TRUE)
  )
  
  # Mock reactives
  mock_status <- reactive(c(1, -1, 1, 0, 0)) 
  mock_position <- reactive(2) # Active step is Step2
  mock_enabled <- reactive(c(FALSE, FALSE, TRUE, TRUE, FALSE))
  
  testServer(
    timeline_pipeline_server,
    args = list(
      config = mock_config,
      status = mock_status,
      position = mock_position,
      enabled = mock_enabled
    ),
    {
      session$flushReact()
      tags <- UpdateTags()
      
      # Expected tags
      expect_equal(tags[1], "completed disabled mandatory")
      expect_equal(tags[2], "skipped disabled  active")
      expect_equal(tags[3], "completed enabled mandatory")
      expect_equal(tags[4], "undone enabled mandatory")
      expect_equal(tags[5], "undone disabled mandatory")
    }
  )
})

test_that("output$show_pipeline_TL renders the correct UI for a Config object", {
  # Create a Config object
  mock_config <- Config(
    fullname = "TestPipeline",
    mode = "pipeline",
    steps = c("Step1", "Step2"),
    mandatory = c(TRUE, FALSE)
  )
  
  # Mock reactives
  mock_status <- reactive(c(1, 1, 0, 0))
  mock_position <- reactive(1) # Active step is Step1
  mock_enabled <- reactive(c(FALSE, TRUE, TRUE, TRUE))
  
  testServer(
    timeline_pipeline_server,
    args = list(
      config = mock_config,
      status = mock_status,
      position = mock_position,
      enabled = mock_enabled
    ),
    {
      session$flushReact()
      ui_output <- output$show_pipeline_TL
      
      # Check if the output is the correct class
      expect_true(!is.null(ui_output))
      expect_true(inherits(ui_output, "list"))
      
      # Check if the output contains the expected number of steps
      expect_equal(length(ui_output), 2) # Two steps
    }
  )
})

test_that("UpdateTags updates when reactives change", {
  # Create a Config object
  mock_config <- Config(
    fullname = "TestPipeline",
    mode = "pipeline",
    steps = c("Step1", "Step2"),
    mandatory = c(TRUE, FALSE)
  )
  
  # Use reactiveVal for reactives that need to be updated
  mock_status <- reactiveVal(c(1, 0, 0, 0)) # Initially undone
  mock_position <- reactiveVal(1) # Initially Step1
  mock_enabled <- reactiveVal(c(TRUE, TRUE, TRUE, TRUE))
  
  testServer(
    timeline_pipeline_server,
    args = list(
      config = mock_config,
      status = mock_status,
      position = mock_position,
      enabled = mock_enabled
    ),
    {
      session$flushReact()
      tags <- UpdateTags()
      expect_equal(tags[1], "completed enabled mandatory active")
      expect_equal(tags[2], "undone enabled mandatory")
      expect_equal(tags[3], "undone enabled ")
      expect_equal(tags[4], "undone enabled mandatory")
      
      # Update status and position
      mock_status(c(1, 1, 0, 0)) # Step1 = VALIDATED
      mock_position(2) # Active step is Step2
      session$flushReact()
      
      tags <- UpdateTags()
      expect_equal(tags[1], "completed enabled mandatory")
      expect_equal(tags[2], "completed enabled mandatory active")
      expect_equal(tags[3], "undone enabled ")
      expect_equal(tags[4], "undone enabled mandatory")
    }
  )
})

test_that("UpdateTags stops execution when config@steps is empty", {
  # Create a Config object with empty steps
  mock_config <- Config(
    fullname = "TestPipeline",
    mode = "pipeline",
    steps = character(0),
    mandatory = logical(0)
  )
  
  # Mock reactives
  mock_status <- reactive(integer(0))
  mock_position <- reactive(integer(0))
  mock_enabled <- reactive(logical(0))
  
  testServer(
    timeline_pipeline_server,
    args = list(
      config = mock_config,
      status = mock_status,
      position = mock_position,
      enabled = mock_enabled
    ),
    {
      session$flushReact()
      # Expect an error because req(config@steps != "") fails
      expect_error(UpdateTags(), regexp = "")
    }
  )
})

test_that("output$show_pipeline_TL is NULL when config@steps is empty", {
  # Create a Config object with empty steps
  mock_config <- Config(
    fullname = "TestPipeline",
    mode = "pipeline",
    steps = character(0),
    mandatory = logical(0)
  )
  
  # Mock reactives
  mock_status <- reactive(integer(0))
  mock_position <- reactive(integer(0))
  mock_enabled <- reactive(logical(0))
  
  testServer(
    timeline_pipeline_server,
    args = list(
      config = mock_config,
      status = mock_status,
      position = mock_position,
      enabled = mock_enabled
    ),
    {
      session$flushReact()
      # The output is NULL because the reactive stops
      expect_error(output$show_pipeline_TL)
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for timeline_pipeline", {
  config <- Config(mode = "pipeline",
                   fullname = "PipelineDemo",
                   steps = c("DataGeneration", "Preprocessing", "Clustering"),
                   mandatory = c(TRUE, FALSE, FALSE))
  status <- reactive({c(1, 1, -1, 1, 0)})
  pos <- reactive({4})
  enabled <- reactive({c(0, 0, 0, 0, 1)})
  shiny_app <- MagellanNTK::timeline_pipeline(config, status, pos, enabled)
  app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-timeline_pipeline")
  
  app$set_window_size(width = 1235, height = 695)
  app$expect_values(output = "myTimeline-show_pipeline_TL")
})

