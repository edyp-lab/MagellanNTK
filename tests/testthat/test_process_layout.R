library(testthat)
library(MagellanNTK)
library(shiny)


test_that("process_layout_pipeline returns a div with correct structure", {
  # Mock session object (minimal for testing)
  mock_session <- list(
    userData = list(
      usermod = list(),  
      wf_mode = "pipeline"
    )
  )
  
  # Mock ns (namespace)
  mock_ns <- shiny::NS("test")
  
  # Mock sidebar and content
  mock_sidebar <- div("Sidebar content")
  mock_content <- div("Main content")
  
  # Call the function
  result <- process_layout_pipeline(mock_session, mock_ns, mock_sidebar, mock_content)
  
  # Check structure
  expect_s3_class(result, "shiny.tag")  # Is it a Shiny tag?
  expect_equal(length(result$children), 2)  # Should have 2 children (sidebar + absolutePanel)
  
  # Check sidebar div
  sidebar_div <- result$children[[1]]
  expect_true(inherits(sidebar_div, "shiny.tag"))
  expect_equal(sidebar_div$children[[1]], mock_sidebar)
  
  # Check absolutePanel
  content_panel <- result$children[[2]]
  expect_true(inherits(content_panel, "shiny.tag"))
  expect_equal(content_panel$children[[1]], mock_content)
})


test_that("process_layout_process returns a div with correct structure", {
  # Mock session object (minimal for testing)
  mock_session <- list(
    userData = list(
      usermod = list(),  
      wf_mode = "process"
    )
  )
  
  # Mock ns (namespace)
  mock_ns <- shiny::NS("test")
  
  # Mock sidebar and content
  mock_sidebar <- div("Sidebar content")
  mock_content <- div("Main content")
  
  # Call the function
  result <- process_layout_process(mock_session, mock_ns, mock_sidebar, mock_content)
  
  # Check structure
  expect_s3_class(result, "shiny.tag")  # Is it a Shiny tag?
  expect_equal(length(result$children), 2)  # Should have 2 children (sidebar + absolutePanel)
  
  # Check sidebar div
  sidebar_div <- result$children[[1]]
  expect_true(inherits(sidebar_div, "shiny.tag"))
  expect_equal(sidebar_div$children[[1]], mock_sidebar)
  
  # Check absolutePanel
  content_panel <- result$children[[2]]
  expect_true(inherits(content_panel, "shiny.tag"))
  expect_equal(content_panel$children[[1]], mock_content)
})


test_that("process_layout_process returns a div with correct structure", {
  # Process
  # Mock session object (minimal for testing)
  mock_session <- list(
    userData = list(
      usermod = list(),  
      wf_mode = "process"
    )
  )
  
  # Mock ns (namespace)
  mock_ns <- shiny::NS("test")
  
  # Mock sidebar and content
  mock_sidebar <- div("Sidebar content")
  mock_content <- div("Main content")
  
  # Call the function
  result_process <- process_layout_process(mock_session, mock_ns, mock_sidebar, mock_content)
  result <- process_layout(mock_session, mock_ns, mock_sidebar, mock_content)
  
  expect_equal(result, result_process)
  
  
  # Pipeline
  mock_session <- list(
    userData = list(
      usermod = list(),  
      wf_mode = "pipeline"
    )
  )
  
  result_pipeline <- process_layout_pipeline(mock_session, mock_ns, mock_sidebar, mock_content)
  result <- process_layout(mock_session, mock_ns, mock_sidebar, mock_content)
  
  expect_equal(result, result_pipeline)
  
  
  # NULL
  mock_session <- list(
    userData = list(
      usermod = list(),  
      wf_mode = NULL
    )
  )
  
  result <- process_layout(mock_session, mock_ns, mock_sidebar, mock_content)
  
  expect_equal(result, result_pipeline)
})
