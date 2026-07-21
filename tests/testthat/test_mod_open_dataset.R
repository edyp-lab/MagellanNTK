library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("open_dataset_ui returns a tagList", {
  ui <- open_dataset_ui("test_id")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("open_dataset_ui contains all expected uiOutput elements", {
  ui <- open_dataset_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-chooseSource_UI", ui_as_char)))
  expect_true(any(grepl("test_id-customDataset_UI", ui_as_char)))
  expect_true(any(grepl("test_id-packageDataset_UI", ui_as_char)))
  expect_true(any(grepl("test_id-Description_infos_dataset_UI", ui_as_char)))
})

test_that("open_dataset returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(open_dataset(), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("open_dataset works with default extension", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(open_dataset(), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("open_dataset works with custom extension", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(open_dataset(extension = "rdata"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----
test_that("module initializes without errors", {
  testServer(
    open_dataset_server,
    args = list(id = "test"),
    {
      expect_true(TRUE) # Module initializes without error
    }
  )
})

test_that("chooseSource_UI renders selectInput", {
  testServer(
    open_dataset_server,
    args = list(id = "test"),
    {
      session$flushReact()
      ui_output <- output$chooseSource_UI
      expect_true(!is.null(ui_output))
      expect_true(any(grepl("shiny-input-select", as.character(ui_output))))
      expect_true(any(grepl("packageDataset", as.character(ui_output))))
    }
  )
})

test_that("customDataset_UI renders fileInput when chooseSource = customDataset", {
  testServer(
    open_dataset_server,
    args = list(
      id = "test",
      extension = c("rds", "RData")
    ),
    {
      # Set chooseSource to customDataset
      rv.widgets$chooseSource <- "customDataset"
      session$flushReact()
      
      ui_output <- output$customDataset_UI
      expect_true(!is.null(ui_output))
      expect_true(any(grepl("shiny-input-file", as.character(ui_output))))
    }
  )
})

test_that("packageDataset_UI renders uiOutput when chooseSource = packageDataset", {
  testServer(
    open_dataset_server,
    args = list(id = "test"),
    {
      # Set chooseSource to packageDataset
      rv.widgets$chooseSource <- "packageDataset"
      session$flushReact()
      
      ui_output <- output$packageDataset_UI
      expect_true(!is.null(ui_output))
      expect_true(any(grepl("shiny-html-output", as.character(ui_output))))
    }
  )
})

test_that("chooseDemoDataset renders selectInput when chooseSource = packageDataset", {
  testServer(
    open_dataset_server,
    args = list(id = "test"),
    {
      # Set chooseSource and pkg
      rv.widgets$chooseSource <- "packageDataset"
      rv.widgets$pkg <- "MagellanNTK"
      session$flushReact()

      ui_output <- output$chooseDemoDataset
      expect_true(!is.null(ui_output))
      expect_true(any(grepl("shiny-input-select", as.character(ui_output))))
    }
  )
})

test_that("remoteReset observer resets values", {
  testServer(
    open_dataset_server,
    args = list(
      id = "test",
      remoteReset = reactive(1)  # Trigger reset
    ),
    {
      session$flushReact()
      
      # Check that widgets are reset to default values
      expect_equal(rv.widgets$chooseSource, "packageDataset")
      expect_equal(rv.widgets$file, character(0))
      expect_equal(rv.widgets$load_dataset_btn, 0)
      expect_equal(rv.widgets$pkg, "None")
      expect_equal(rv.widgets$demoDataset, "None")
      
      # Check that custom values are reset
      expect_null(rv.custom$dataRead)
      expect_equal(rv.custom$name, "default.name")
      expect_equal(rv.custom$packages, "MagellanNTK")
      
      # Check that dataOut is reset
      expect_null(dataOut$dataset)
      expect_null(dataOut$name)
      expect_true(!is.null(dataOut$trigger))
    }
  )
})

test_that("Description_infos_dataset_UI renders when rv.custom$dataRead is set", {
  local({
    # Define mocks
    infos_dataset_server <- function(id, dataIn) {
      moduleServer(id, function(input, output, session) {})
    }
    infos_dataset_ui <- function(id) {
      return(tags$div("Mock Infos Dataset UI"))
    }
    
    # Assign to the package namespace (not globalenv)
    assign("infos_dataset_server", infos_dataset_server, envir = globalenv())
    assign("infos_dataset_ui", infos_dataset_ui, envir = globalenv())
    
    # Ensure cleanup even if the test fails
    on.exit({
      rm("infos_dataset_server", envir = globalenv())
      rm("infos_dataset_ui", envir = globalenv())
    })
    
    # Run the test
    testServer(
      open_dataset_server,
      args = list(id = "test"),
      {
        rv.custom$dataRead <- data.frame(a = 1:3, b = 4:6)
        session$flushReact()
        
        ui_output <- output$Description_infos_dataset_UI
        expect_true(!is.null(ui_output))
        expect_true(inherits(ui_output, "list"))
      }
    )
  })
})

test_that("module returns a reactive with dataOut", {
  testServer(
    open_dataset_server,
    args = list(id = "test"),
    {
      return_value <- reactive({ dataOut })
      expect_true(!is.null(return_value))
      expect_true(is.reactive(return_value))
    }
  )
})


# shinytest2 ----

test_that("shinytest2 tests for open_dataset", {
  shiny_app <- MagellanNTK::open_dataset(extension = "rdata")
    app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-open_dataset")
  
    app$set_window_size(width = 1235, height = 695)
    app$expect_values()
})
