library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)
suppressWarnings(
  library(bs4Dash))



test_that("mainapp_ui returns a shiny.tag", {
  ui <- mainapp_ui("test_id")
  expect_s3_class(ui, "shiny.tag.list")
})

test_that("mainapp_ui has correct preloader", {
  ui <- mainapp_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("spinner", ui_as_char)))
  expect_true(any(grepl("Loading ...", ui_as_char)))
  expect_true(any(grepl("#343a40", ui_as_char)))
})

test_that("mainapp_ui has correct sidebar", {
  ui <- mainapp_ui("test_id", size = "200px")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-mySidebar", ui_as_char)))
  expect_true(any(grepl("padding-top: 0px", ui_as_char)))
  expect_true(any(grepl("200px", ui_as_char)))
  expect_true(any(grepl('collapsed="TRUE"', ui_as_char)))
  expect_true(any(grepl('minified="TRUE"', ui_as_char)))
})

test_that("mainapp_ui has expected tabItems", {
  ui <- mainapp_ui("test_id")
  ui_as_char <- as.character(ui)
  # Check for each tabItem
  expect_true(any(grepl("Home", ui_as_char)))
  expect_true(any(grepl("openDataset", ui_as_char)))
  expect_true(any(grepl("convertDataset", ui_as_char)))
  expect_true(any(grepl("SaveAs", ui_as_char)))
  expect_true(any(grepl("tools", ui_as_char)))
  expect_true(any(grepl("BuildReport", ui_as_char)))
  expect_true(any(grepl("openWorkflow", ui_as_char)))
  expect_true(any(grepl("workflow", ui_as_char)))
  expect_true(any(grepl("releaseNotes", ui_as_char)))
  expect_true(any(grepl("faq", ui_as_char)))
  expect_true(any(grepl("Manual", ui_as_char)))
  # Check for specific UI outputs
  expect_true(any(grepl("test_id-home", ui_as_char)))
  expect_true(any(grepl("test_id-open_dataset_UI", ui_as_char)))
  expect_true(any(grepl("test_id-open_convert_dataset_UI", ui_as_char)))
  expect_true(any(grepl("test_id-SaveAs_UI", ui_as_char)))
  expect_true(any(grepl("test_id-tools_UI", ui_as_char)))
  expect_true(any(grepl("test_id-BuildReport_UI", ui_as_char)))
  expect_true(any(grepl("test_id-open_workflow_UI", ui_as_char)))
  expect_true(any(grepl("test_id-workflow_UI", ui_as_char)))
  expect_true(any(grepl("test_id-ReleaseNotes_UI", ui_as_char)))
  expect_true(any(grepl("test_id-FAQ_MD", ui_as_char)))
  expect_true(any(grepl("test_id-manual_UI", ui_as_char)))
})

test_that("mainapp_ui uses default size of 300px", {
  ui <- mainapp_ui("test_id")
  expect_true(any(grepl("300px", as.character(ui))))
})

test_that("mainapp_ui has Home tab as active", {
  ui <- mainapp_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl('active" icon="home"', ui_as_char)))
})

test_that("mainapp returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mainapp(), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----
test_that("module initializes with correct rv.core values", {
  testServer(
    mainapp_server,
    args = list(id = "test"),
    {
      expect_null(rv.core$result_convert())
      expect_null(rv.core$result_open_dataset())
      expect_null(rv.core$result_open_workflow())
      expect_null(rv.core$result_run_workflow())
      expect_null(rv.core$current.obj)
      expect_null(rv.core$processed.obj)
      expect_null(rv.core$current.obj.name)
      expect_equal(rv.core$resetWF, 0)
      expect_null(rv.core$workflow.name)
      expect_null(rv.core$workflow.path)
      expect_true(!is.null(rv.core$funcs))
      expect_true(!is.null(rv.core$filepath))
    }
  )
})

test_that("Insert_User_Sidebar_UI renders for user mode", {
  path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
  testServer(
    mainapp_server,
    args = list(
      id = "test",
      usermod = "user",
      workflow.name = reactive("PipelineDemo"),  # Non-NULL
      workflow.path = reactive(path)       # Non-NULL
    ),
    {
      session$flushReact()
      ui_output <- output$Insert_User_Sidebar_UI
      expect_true(!is.null(ui_output))
      expect_true(inherits(ui_output, "list"))
      expect_true(any(grepl("shiny-tab", as.character(ui_output))))
    }
  )
})

test_that("Insert_User_Sidebar_UI is NULL for dev mode", {
  path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
  testServer(
    mainapp_server,
    args = list(
      id = "test",
      usermod = "dev",
      workflow.name = reactive("PipelineDemo"),  # Non-NULL
      workflow.path = reactive(path)       # Non-NULL
    ),
    {
      session$flushReact()
      expect_null(output$Insert_User_Sidebar_UI)
    }
  )
})

test_that("left_UI renders with package name", {
  path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
  testServer(
    mainapp_server,
    args = list(
      id = "test",
      workflow.name = reactive("PipelineDemo"),  # Non-NULL
      workflow.path = reactive(path)       # Non-NULL
    ),
    {
      session$flushReact()
      ui_output <- output$left_UI
      expect_true(!is.null(ui_output))
      expect_true(inherits(ui_output, "list"))
      expect_true(any(grepl("MagellanNTK", as.character(ui_output))))
    }
  )
})

test_that("WF_Name_UI renders when workflow.name is set", {
  path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
  testServer(
    mainapp_server,
    args = list(
      id = "test",
      workflow.name = reactive("PipelineDemo"),  # Non-NULL
      workflow.path = reactive(path)       # Non-NULL
    ),
    {
      session$flushReact()
      ui_output <- output$WF_Name_UI
      expect_true(!is.null(ui_output))
      expect_true(inherits(ui_output, "list"))
      expect_true(any(grepl("PipelineDemo", as.character(ui_output))))
    }
  )
})

test_that("Dataset_Name_UI renders when current.obj.name is set", {
  path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
  testServer(
    mainapp_server,
    args = list(
      id = "test",
      workflow.name = reactive("PipelineDemo"),  # Non-NULL
      workflow.path = reactive(path)       # Non-NULL
    ),
    {
      rv.core$current.obj.name <- "test_dataset"
      session$flushReact()
      ui_output <- output$Dataset_Name_UI
      expect_true(!is.null(ui_output))
      expect_true(inherits(ui_output, "list"))
      expect_true(any(grepl("test_dataset", as.character(ui_output))))
    }
  )
})

test_that("SaveAs_UI renders when download_dataset function is available", {
  path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
  testServer(
    mainapp_server,
    args = list(
      id = "test",
      workflow.name = reactive("PipelineDemo"),  # Non-NULL
      workflow.path = reactive(path)       # Non-NULL
    ),
    {
      rv.core$funcs$funcs$download_dataset <- "download_dataset"
      session$flushReact()
      ui_output <- output$SaveAs_UI
      expect_true(!is.null(ui_output))
      expect_true(inherits(ui_output, "list"))
      expect_true(any(grepl("test-download_dataset", as.character(ui_output))))
    }
  )
})

test_that("open_dataset_UI renders when open_dataset function is available", {
  path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
  testServer(
    mainapp_server,
    args = list(
      id = "test",
      workflow.name = reactive("PipelineDemo"),  # Non-NULL
      workflow.path = reactive(path)       # Non-NULL
    ),
    {
      rv.core$funcs$funcs$open_dataset <- "open_dataset"
      session$flushReact()
      ui_output <- output$open_dataset_UI
      expect_true(!is.null(ui_output))
      expect_true(inherits(ui_output, "list"))
      expect_true(any(grepl("test-open_dataset", as.character(ui_output))))
    }
  )
})

test_that("observe_result_open_dataset updates current.obj", {
  path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
  testServer(
    mainapp_server,
    args = list(
      id = "test",
      workflow.name = reactive("PipelineDemo"),  # Non-NULL
      workflow.path = reactive(path)       # Non-NULL
    ),
    {
      rv.core$funcs$funcs$open_dataset <- "open_dataset"
      rv.core$result_open_dataset <- reactive({
        list(trigger = 0, dataset = NULL, name = NULL)
      })
      session$flushReact()
      
      # Simulate a trigger
      rv.core$result_open_dataset <- reactive({
        list(trigger = MagellanNTK::Timestamp(), dataset = data.frame(a = 1:3), name = "test_dataset")
      })
      session$flushReact()
      
      expect_equal(rv.core$current.obj, data.frame(a = 1:3))
      expect_equal(rv.core$current.obj.name, "test_dataset")
      expect_equal(rv.core$processed.obj, data.frame(a = 1:3))
    }
  )
})

test_that("workflow_UI renders for process mode", {
  path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
  testServer(
    mainapp_server,
    args = list(
      id = "test",
      workflow.name = reactive("PipelineDemo_DataGeneration"),  # Non-NULL
      workflow.path = reactive(path)       # Non-NULL
    ),
    {
      session$userData$wf_mode <- "process"
      session$userData$workflow.name <- "PipelineDemo_DataGeneration"
      rv.core$workflow.name <- "PipelineDemo_DataGeneration"
      session$flushReact()
      ui_output <- output$workflow_UI
      expect_true(!is.null(ui_output))
      expect_true(inherits(ui_output, "list"))
      expect_true(any(grepl("singleProcess", as.character(ui_output))))
    }
  )
})

test_that("workflow_UI renders for pipeline mode", {
  path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
  testServer(
    mainapp_server,
    args = list(
      id = "test",
      workflow.name = reactive("PipelineDemo"),  # Non-NULL
      workflow.path = reactive(path)       # Non-NULL
    ),
    {
      session$userData$wf_mode <- "pipeline"
      session$userData$workflow.name <- "PipelineDemo"
      rv.core$workflow.name <- "PipelineDemo"
      session$flushReact()
      ui_output <- output$workflow_UI
      expect_true(!is.null(ui_output))
      expect_true(inherits(ui_output, "list"))
      expect_true(any(grepl("pipeline", as.character(ui_output))))
    }
  )
})


# shinytest2 ----


