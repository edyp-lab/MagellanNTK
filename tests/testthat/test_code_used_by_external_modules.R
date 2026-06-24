library(testthat)
library(MagellanNTK)


test_that("Get_Code_Update_Config_Variable returns correct code", {
  result <- Get_Code_Update_Config_Variable()
  
  # Check the returned code matches expected pattern
  expect_match(result, "config@steps <- setNames\\(config@steps,")
  expect_match(result, "nm = gsub\\(\\' \\', \\'\\', config@steps, fixed = TRUE\\)\\)")
  
  # Check it's a single string
  expect_is(result, "character")
  expect_equal(length(result), 1)
})


test_that("Get_Code_Declare_widgets handles NULL input", {
  result <- Get_Code_Declare_widgets(NULL)
  expect_equal(result, "rv.widgets <- reactiveValues()\n\n")
})

test_that("Get_Code_Declare_widgets generates correct code for widgets", {
  widgets.names <- c("step1_widget1", "step2_widget1", "step2_widget2")
  result <- Get_Code_Declare_widgets(widgets.names)
  
  # Check the structure
  expect_match(result, "rv.widgets <- reactiveValues\\(\n")
  expect_match(result, "step1_widget1 = widgets.default.values\\$step1_widget1")
  expect_match(result, "step2_widget1 = widgets.default.values\\$step2_widget1")
  expect_match(result, "step2_widget2 = widgets.default.values\\$step2_widget2")
  expect_match(result, "\n\\)\n\n$")  # Ending pattern
  
  # Check it's a single string
  expect_is(result, "character")
  expect_equal(length(result), 1)
})

test_that("Get_Code_Declare_widgets handles empty vector", {
  result <- Get_Code_Declare_widgets(character(0))
  expect_equal(result, "rv.widgets <- reactiveValues(\n\t\n)\n\n")
})


test_that("Get_Code_Declare_rv_custom handles NULL input", {
  result <- Get_Code_Declare_rv_custom(NULL)
  expect_equal(result, "rv.custom <- reactiveValues()\n\n")
})

test_that("Get_Code_Declare_rv_custom generates correct code for custom variables", {
  rv.custom.names <- c("custom1", "custom2", "custom3")
  result <- Get_Code_Declare_rv_custom(rv.custom.names)
  
  # Check the structure
  expect_match(result, "rv.custom <- reactiveValues\\(\n")
  expect_match(result, "custom1 = rv.custom.default.values\\$custom1")
  expect_match(result, "custom2 = rv.custom.default.values\\$custom2")
  expect_match(result, "custom3 = rv.custom.default.values\\$custom3")
  expect_match(result, "\n\\)\n\n$")  # Ending pattern
  
  # Check it's a single string
  expect_is(result, "character")
  expect_equal(length(result), 1)
})

test_that("Get_Code_Declare_rv_custom handles empty vector", {
  result <- Get_Code_Declare_rv_custom(character(0))
  expect_equal(result, "rv.custom <- reactiveValues(\n\t\n)\n\n")
})


test_that("Get_Code_for_ObserveEvent_widgets handles NULL input", {
  result <- Get_Code_for_ObserveEvent_widgets(NULL)
  expect_null(result)
})

test_that("Get_Code_for_ObserveEvent_widgets generates correct observeEvent code", {
  widgets.names <- c("step1_widget1", "step2_widget1")
  result <- Get_Code_for_ObserveEvent_widgets(widgets.names)
  
  # Check the structure
  expect_match(result, "observeEvent\\(input\\$step1_widget1, \\{")
  expect_match(result, "rv.widgets\\$step1_widget1 <- input\\$step1_widget1\\}")
  expect_match(result, "observeEvent\\(input\\$step2_widget1, \\{")
  expect_match(result, "rv.widgets\\$step2_widget1 <- input\\$step2_widget1\\}")
  
  # Check the ending has extra newlines
  expect_match(result, "\n\n\n$")
  
  # Check it's a single string
  expect_is(result, "character")
  expect_equal(length(result), 1)
})

test_that("Get_Code_for_ObserveEvent_widgets handles empty vector", {
  result <- Get_Code_for_ObserveEvent_widgets(character(0))
  expect_equal(result, "\n\n\n")
})


test_that("Get_Code_for_rv_reactiveValues returns correct code", {
  result <- Get_Code_for_rv_reactiveValues()
  
  # Check the structure
  expect_match(result, "rv <- reactiveValues\\(\n")
  expect_match(result, "dataIn = NULL,")
  expect_match(result, "steps.status = NULL,")
  expect_match(result, "reset = NULL,")
  expect_match(result, "steps.enabled = NULL")
  expect_match(result, "\\)$")  # Ending with closing parenthesis
  
  # Check it's a single string
  expect_is(result, "character")
  expect_equal(length(result), 1)
})


test_that("Get_Code_for_dataOut returns correct code", {
  result <- Get_Code_for_dataOut()
  
  # Check the structure
  expect_match(result, "dataOut <- reactiveValues\\(\n")
  expect_match(result, "trigger = as.numeric\\(Sys.time\\(\\)\\),")
  expect_match(result, "value = NULL,")
  expect_match(result, "sidebarState = NULL")
  expect_match(result, "\\)$")  # Ending with closing parenthesis
  
  # Check it's a single string
  expect_is(result, "character")
  expect_equal(length(result), 1)
})


test_that("Get_Code_for_General_observeEvents returns correct code structure", {
  result <- Get_Code_for_General_observeEvents()
  
  # Check it's a single character string
  expect_is(result, "character")
  expect_equal(length(result), 1)
  
  # Check for observeEvent for steps.enabled
  expect_match(result, "observeEvent\\(steps\\.enabled\\(\\), ignoreNULL = TRUE, \\{")
  expect_match(result, "if \\(is\\.null\\(steps\\.enabled\\(\\)\\)\\)")
  expect_match(result, "rv\\$steps\\.enabled <- setNames\\(rep\\(FALSE, rv\\$length\\),")
  expect_match(result, "nm = names\\(rv\\$config@steps\\)\\)")
  expect_match(result, "else\\s+rv\\$steps\\.enabled <- steps\\.enabled\\(\\)")
  
  # Check for observeEvent for steps.status
  expect_match(result, "observeEvent\\(steps\\.status\\(\\), ignoreNULL = TRUE, \\{")
  expect_match(result, "if \\(is\\.null\\(steps\\.enabled\\(\\)\\)\\)")  # Note: checks steps.enabled() not steps.status()
  expect_match(result, "rv\\$steps\\.status <- setNames\\(rep\\(stepStatus\\$UNDONE, rv\\$length\\),")
  expect_match(result, "nm = names\\(rv\\$config@steps\\)\\)")
  expect_match(result, "else\\s+rv\\$steps\\.status <- steps\\.status\\(\\)")
})


test_that("Get_Code_for_remoteReset generates correct code with all options", {
  result <- Get_Code_for_remoteReset(widgets = TRUE, custom = TRUE, dataIn = "dataIn()", addon = "customCode()")
  
  expect_is(result, "character")
  expect_equal(length(result), 1)
  
  # Check the observeEvent structure
  expect_match(result, "^observeEvent\\(remoteReset\\(\\), ignoreInit = TRUE, ignoreNULL = TRUE, \\{")
  
  # Check widgets reset code is included
  expect_match(result, "lapply\\(names\\(rv\\.widgets\\), function\\(x\\)\\{")
  expect_match(result, "rv\\.widgets\\[\\[x\\]\\] <- widgets\\.default\\.values\\[\\[x\\]\\]")
  
  # Check custom reset code is included
  expect_match(result, "lapply\\(names\\(rv\\.custom\\), function\\(x\\)\\{")
  expect_match(result, "rv\\.custom\\[\\[x\\]\\] <- rv\\.custom\\.default\\.values\\[\\[x\\]\\]")
  
  # Check dataIn assignment
  expect_match(result, "rv\\$dataIn <- dataIn\\(\\)")
  
  # Check addon is included
  expect_match(result, "customCode\\(\\)")
  
  # Check closing brace
  expect_match(result, "\\}")
})

test_that("Get_Code_for_remoteReset handles widgets = FALSE", {
  result <- Get_Code_for_remoteReset(widgets = FALSE, custom = TRUE)
  
  # Should not contain widget reset code
  expect_false(grepl("lapply\\(names\\(rv\\.widgets\\)", result))
  # But should contain custom reset code
  expect_match(result, "lapply\\(names\\(rv\\.custom\\)")
})

test_that("Get_Code_for_remoteReset handles custom = FALSE", {
  result <- Get_Code_for_remoteReset(widgets = TRUE, custom = FALSE)
  
  # Should contain widget reset code
  expect_match(result, "lapply\\(names\\(rv\\.widgets\\)")
  # But should not contain custom reset code
  expect_false(grepl("lapply\\(names\\(rv\\.custom\\)", result))
})

test_that("Get_Code_for_remoteReset handles custom dataIn", {
  result <- Get_Code_for_remoteReset(dataIn = "customData()")
  expect_match(result, "rv\\$dataIn <- customData\\(\\)")
})

test_that("Get_Code_for_remoteReset handles empty addon", {
  result <- Get_Code_for_remoteReset(addon = "")
  # Should not have extra space before closing brace
  expect_match(result, "rv\\$dataIn <- dataIn\\(\\)\\s*\\}")
})


test_that("Get_Code_for_resetting_widgets returns correct code", {
  result <- Get_Code_for_resetting_widgets()
  
  expect_is(result, "character")
  expect_equal(length(result), 1)
  
  # Check the lapply structure
  expect_match(result, "^\\s*lapply\\(names\\(rv\\.widgets\\), function\\(x\\)\\{")
  expect_match(result, "rv\\.widgets\\[\\[x\\]\\] <- widgets\\.default\\.values\\[\\[x\\]\\]")
  expect_match(result, "#shinyjs::reset\\(x\\)")
  expect_match(result, "\\})")
})


test_that("Get_Code_for_resetting_custom returns correct code", {
  result <- Get_Code_for_resetting_custom()
  
  expect_is(result, "character")
  expect_equal(length(result), 1)
  
  # Check the lapply structure
  expect_match(result, "^\\s*lapply\\(names\\(rv\\.custom\\), function\\(x\\)\\{")
  expect_match(result, "rv\\.custom\\[\\[x\\]\\] <- rv\\.custom\\.default\\.values\\[\\[x\\]\\]")
  expect_match(result, "\\})")
})


test_that("Module_Return_Func returns correct code", {
  result <- Module_Return_Func()
  
  expect_is(result, "character")
  expect_equal(length(result), 1)
  
  expect_equal(result, "list(config = reactive({config}), dataOut = reactive({dataOut}))")
})


test_that("AdditionnalCodeForExternalModules generates correct code with all components", {
  w.names <- c("widget1", "widget2")
  rv.custom.names <- c("custom1", "custom2")
  
  result <- AdditionnalCodeForExternalModules(w.names, rv.custom.names)
  
  expect_is(result, "character")
  expect_equal(length(result), 1)
  
  # Check all components are included
  expect_match(result, "rv\\.widgets <- reactiveValues\\(")
  expect_match(result, "observeEvent\\(input\\$widget1")
  expect_match(result, "dataIn = NULL")
  expect_match(result, "rv\\.custom <- reactiveValues\\(")
  expect_match(result, "dataOut <- reactiveValues\\(")
})

test_that("AdditionnalCodeForExternalModules handles NULL inputs", {
  result <- AdditionnalCodeForExternalModules(NULL, NULL)
  
  expect_is(result, "character")
  expect_equal(length(result), 1)
  
  # Should include empty reactiveValues
  expect_match(result, "rv\\.widgets <- reactiveValues\\(\\)")
  expect_match(result, "rv\\.custom <- reactiveValues\\(\\)")
})







test_that("Get_Workflow_Core_Code generates correct code with all components", {
  w.names <- c("widget1", "widget2")
  rv.custom.names <- c("custom1", "custom2")
  
  result <- Get_Workflow_Core_Code(mode = "process", name = "TestProcess",
                                   w.names, rv.custom.names)
  
  expect_is(result, "character")
  expect_equal(length(result), 1)
  
  # Check all components are included
  expect_match(result, "TestProcess_conf\\(\\)")
  expect_match(result, "rv\\.widgets <- reactiveValues\\(")
  expect_match(result, "observeEvent\\(input\\$widget1")
  expect_match(result, "dataIn = NULL")
  expect_match(result, "rv\\.custom <- reactiveValues\\(")
  expect_match(result, "dataOut <- reactiveValues\\(")
  expect_match(result, "observeEvent\\(steps\\.enabled\\(\\)")
  expect_match(result, "observeEvent\\(remoteReset\\(\\)")
})

test_that("Get_Workflow_Core_Code handles NULL inputs", {
  expect_error(Get_Workflow_Core_Code(NULL, NULL, NULL, NULL))
})


test_that("Insert_Call_to_Config generates correct code", {
  result <- Insert_Call_to_Config("TestPipeline")
  
  expect_is(result, "character")
  expect_equal(length(result), 1)
  
  expect_match(result, "^config <- TestPipeline_conf\\(\\)")
  expect_match(result, "config@ll\\.UI <- setNames\\(")
  expect_match(result, "lapply\\(")
  expect_match(result, "do\\.call\\(\\\"uiOutput\\\", list\\(ns\\(x\\)\\)\\)")
  expect_match(result, "nm = paste0\\(\\\"screen_\\\", names\\(config@steps\\)\\)")
})


test_that("Get_AdditionalModule_Core_Code generates correct code with all components", {
  w.names <- c("widget1", "widget2")
  rv.custom.names <- c("custom1", "custom2")
  
  result <- Get_AdditionalModule_Core_Code(w.names, rv.custom.names)
  
  expect_is(result, "character")
  expect_equal(length(result), 1)
  
  # Check all components are included
  expect_match(result, "rv\\.widgets <- reactiveValues\\(")
  expect_match(result, "observeEvent\\(input\\$widget1")
  expect_match(result, "dataIn = NULL")
  expect_match(result, "rv\\.custom <- reactiveValues\\(")
  expect_match(result, "dataOut <- reactiveValues\\(")
  expect_match(result, "observeEvent\\(remoteReset\\(\\)")
})

test_that("Get_AdditionalModule_Core_Code handles NULL inputs", {
  result <- Get_AdditionalModule_Core_Code(NULL, NULL)
  
  expect_is(result, "character")
  expect_equal(length(result), 1)
  
  # Should include empty reactiveValues
  expect_match(result, "rv\\.widgets <- reactiveValues\\(\\)")
  expect_match(result, "rv\\.custom <- reactiveValues\\(\\)")
})
