library(testthat)
library(shinytest2)
library(MagellanNTK)
library(shiny)


test_that("mod_modalDialog_ui returns a uiOutput", {
  ui <- mod_modalDialog_ui("test_id")
  expect_s3_class(ui, "shiny.tag")
  expect_true(any(grepl("shiny-html-output", as.character(ui))))
})

test_that("mod_modalDialog_ui contains uiOutput with correct namespace", {
  ui <- mod_modalDialog_ui("test_id")
  ui_as_char <- as.character(ui)
  expect_true(any(grepl("test_id-dialog_UI", ui_as_char)))
})

test_that("mod_modalDialog returns a shiny app", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_modalDialog(title = "Test"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("mod_modalDialog works with default parameters", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_modalDialog(title = "Test"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("mod_modalDialog works with uiContent", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_modalDialog(title = "Test", uiContent = p("Test content")), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("mod_modalDialog works with external_mod", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_modalDialog(title = "Test", external_mod = "someModule"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})

test_that("mod_modalDialog works with typeWidget = 'link'", {
  suppressMessages(suppressWarnings({
    app <- tryCatch(mod_modalDialog(title = "Test", typeWidget = "link"), error = function(e) NULL)
  }))
  expect_is(app, "shiny.appobj")
})


# testServer ----
test_that("module initializes with correct reactive values", {
  testServer(
    mod_modalDialog_server,
    args = list(id = "test"),
    {
      expect_null(rv$dataOut)
      expect_null(rv$tmp)
    }
  )
})

test_that("dialog_UI renders a button when typeWidget = button", {
  testServer(
    mod_modalDialog_server,
    args = list(
      id = "test",
      title = "Test",
      typeWidget = "button"
    ),
    {
      session$flushReact()
      ui_output <- output$dialog_UI
      expect_true(!is.null(ui_output))
      expect_true(any(grepl("action-button", as.character(ui_output))))
      expect_true(any(grepl("btn-danger", as.character(ui_output))))
    }
  )
})

test_that("dialog_UI renders a link when typeWidget = link", {
  testServer(
    mod_modalDialog_server,
    args = list(
      id = "test",
      title = "Test",
      typeWidget = "link"
    ),
    {
      session$flushReact()
      ui_output <- output$dialog_UI
      expect_true(!is.null(ui_output))
      expect_true(any(grepl("action-link", as.character(ui_output))))
    }
  )
})

test_that("warning when both uiContent and external_mod are provided", {
  # Suppress all output (stack traces, warnings, messages)
  suppressWarnings(
    suppressMessages(
      capture.output({
        testServer(
          mod_modalDialog_server,
          args = list(
            id = "test",
            uiContent = tags$div("Content"),
            external_mod = "test_module"
          ),
          {
            session$flushReact()
            
            withCallingHandlers(
              {
                result <- output$dialog_UI
                expect_null(result)  # Check output is NULL
              },
              warning = function(w) {
                expect_match(
                  w$message,
                  "uiContent and external_mod cannot be both instantiated"
                )
              }
            )
          }
        )
      }, type = "message")  # Capture stderr (where stack traces go)
    )
  )
})

test_that("module returns a reactive with rv$dataOut", {
  testServer(
    mod_modalDialog_server,
    args = list(id = "test"),
    {
      return_value <- reactive({ rv$dataOut })
      expect_true(!is.null(return_value))
      expect_true(is.reactive(return_value))
    }
  )
})

# shinytest2 ----

test_that("shinytest2 tests for mod_modalDialog", {
  shiny_app <- MagellanNTK::mod_modalDialog(title = "test modalDialog",
                                            uiContent = p("test"))
    app <- shinytest2::AppDriver$new(shiny_app, name = "MagellanNTK-mod_modalDialog")
  
    app$set_window_size(width = 1235, height = 695)
    app$expect_values()
    app$click("tbl-show")
    app$expect_values(output = "tbl-dialog_UI")
    app$expect_values(input = "tbl-show")
})
