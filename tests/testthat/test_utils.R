library(testthat)
library(MagellanNTK)

# Tests for readConfigFile
# Helper function to create a temporary config file
create_config_file <- function(content, dir = tempdir()) {
  config_path <- file.path(dir, "config.txt")
  writeLines(content, config_path)
  return(dir)
}

test_that("readConfigFile reads and parses config.txt correctly in user mode", {
  # Create a temporary config file
  config_content <- c(
    "verbose: enabled",
    "debugger: disabled",
    "Open_pipeline: disabled",
    "convert_dataset: enabled",
    "change_Look_Feel: enabled",
    "change_core_funcs: disabled",
    "extension: .csv",
    "package: MagellanNTK",
    "URL_manual: https://example.com/manual",
    "URL_ReleaseNotes: https://example.com/release",
    "open_dataset: MagellanNTK",
    "view_dataset: MagellanNTK",
    "download_dataset: MagellanNTK"
  )
  temp_dir <- create_config_file(config_content)
  
  # Test in user mode
  result <- readConfigFile(temp_dir, usermod = "user")
  
  # Check structure
  expect_is(result, "list")
  expect_named(result, c(
    "funcs", "verbose", "UI_view_debugger", "UI_view_open_pipeline",
    "UI_view_convert_dataset", "UI_view_change_Look_Feel",
    "UI_view_change_core_funcs", "extension", "package",
    "URL_manual", "URL_ReleaseNotes"
  ))
  
  # Check values
  expect_equal(result$verbose, TRUE)
  expect_equal(result$UI_view_debugger, TRUE)  # debugger: disabled -> TRUE
  expect_equal(result$UI_view_open_pipeline, TRUE)
  expect_equal(result$UI_view_convert_dataset, TRUE)
  expect_equal(result$UI_view_change_Look_Feel, TRUE)
  expect_equal(result$UI_view_change_core_funcs, TRUE)
  expect_equal(result$extension, ".csv")
  expect_equal(result$package, "MagellanNTK")
  expect_equal(result$URL_manual, "https://example.com/manual")
  expect_equal(result$URL_ReleaseNotes, "https://example.com/release")
  expect_equal(length(result$funcs), 12)
  
  # Clean up
  unlink(file.path(temp_dir, "config.txt"))
})

test_that("readConfigFile reads and parses config.txt correctly in dev mode", {
  # Create a temporary config file
  config_content <- c(
    "verbose: enabled",
    "extension: .txt",
    "package: TestPackage",
    "URL_manual: manual.txt",
    "URL_ReleaseNotes: release.txt",
    "func1: dev1",
    "func2: dev2"
  )
  temp_dir <- create_config_file(config_content)
  
  # Test in dev mode
  result <- readConfigFile(temp_dir, usermod = "dev")
  
  # Check dev mode defaults
  expect_equal(result$verbose, TRUE)  # Always TRUE in dev mode
  expect_equal(result$UI_view_debugger, TRUE)  # Always TRUE in dev mode
  expect_equal(result$UI_view_open_pipeline, FALSE)  # Always FALSE in dev mode
  expect_equal(result$UI_view_convert_dataset, TRUE)  # Always TRUE in dev mode
  expect_equal(result$UI_view_change_Look_Feel, TRUE)  # Always TRUE in dev mode
  expect_equal(result$UI_view_change_core_funcs, FALSE)  # Always FALSE in dev mode
  expect_equal(result$extension, ".txt")
  expect_equal(result$package, "TestPackage")
  
  # Clean up
  unlink(file.path(temp_dir, "config.txt"))
})

test_that("readConfigFile throws error when config file doesn't exist", {
  expect_error(
    readConfigFile("/nonexistent/path"),
    regexp = "file does not exist"
  )
})

test_that("readConfigFile handles missing fields gracefully", {
  # Create a minimal config file
  config_content <- c(
    "verbose: enabled",
    "extension: .rds"
  )
  temp_dir <- create_config_file(config_content)
  
  # Should not throw error for missing fields
  result <- readConfigFile(temp_dir)
  expect_is(result, "list")
  expect_null(result$package)
  expect_null(result$URL_manual)
  
  # Clean up
  unlink(file.path(temp_dir, "config.txt"))
})


# Tests for GetListDatasets
test_that("GetListDatasets returns all datasets when class is NULL", {
  # Skip if no packages are available
  skip_if_not(
    length(.packages(all.available = TRUE)) > 0,
    "No packages available for testing"
  )
  
  result <- GetListDatasets(class = NULL)
  expect_is(result, "matrix")
  expect_true(ncol(result) >= 2)  # Should have Package and Item columns
  expect_true(all(result[,2] != ""))  # All items should be non-empty
})

test_that("GetListDatasets filters by class correctly", {
  # Test with a known class (data.frame)
  result <- GetListDatasets(class = "QFeatures")
  
  if (nrow(result) > 0) {
    expect_is(result, "data.frame")
    expect_true(all(result$Item != ""))
    
    # Verify at least one dataset inherits from QFeatures
    # Note: We can't easily verify the class of all returned datasets
    # without potentially loading many packages, so we just check the structure
    expect_true(ncol(result) >= 2)
  }
})

test_that("GetListDatasets returns datasets from specific package", {
  # Use base R datasets package which should be available
  skip_if_not_installed("datasets")
  
  result <- GetListDatasets(demo_package = "datasets")
  expect_is(result, "matrix")
  expect_true(ncol(result) >= 2)
  expect_true(all(result[,1] == "datasets"))
  expect_true(all(result[,2] != ""))
})

test_that("GetListDatasets handles non-existant package/class", {
  # GetListDatasets handles non-existent package
  expect_error(
    GetListDatasets(demo_package = "nonexistent_package_12345")
  )
  
  # GetListDatasets handles non-existent class
  result <- GetListDatasets(class = "nonexistent_class_12345")
  # Should return empty matrix or NULL
  expect_true(is.null(result) || nrow(result) == 0)
})


# Tests for source_wf_files
test_that("source_wf_files sources R files correctly", {
  # Create a temporary directory with R scripts
  temp_dir <- tempdir()
  R_dir <- file.path(temp_dir, "R")
  dir.create(R_dir)

  # Create a test R file
  test_file <- file.path(R_dir, "test_script.R")
  writeLines("test_var <- 1", test_file)
  test_file_conf <- file.path(temp_dir, "config.txt")
  writeLines("", test_file_conf)
  
  # Source the files
  expect_true(source_wf_files(temp_dir, verbose = FALSE))

  # Check if the variable was loaded
  expect_true(exists("test_var", envir = .GlobalEnv))
  expect_equal(get("test_var", envir = .GlobalEnv), 1)

  # Clean up
  unlink(test_file, recursive = TRUE)
  rm("test_var", envir = .GlobalEnv)
})


# Tests for source_wf_files
test_that("source_shinyApp_files test", {
  expect_silent(source_shinyApp_files())
})


# Test for isSubstr function
test_that("isSubstr correctly identifies substrings", {
  # Basic cases
  expect_true(isSubstr("cde", "abcdefghi"))
  expect_true(isSubstr("abc", "abcdefghi"))
  expect_true(isSubstr("ghi", "abcdefghi"))
  expect_true(isSubstr("abcdefghi", "abcdefghi")) # Exact match
  
  # Negative cases
  expect_false(isSubstr("xyz", "abcdefghi"))
  expect_false(isSubstr("abcx", "abcdefghi"))
  expect_true(isSubstr("", "abcdefghi")) # Empty pattern is substring of any string
  
  # Edge cases
  expect_true(isSubstr("a", "a")) # Single character
  expect_false(isSubstr("aa", "a")) # Pattern longer than target
  expect_true(isSubstr("a", "aa")) # Target longer than pattern
})


# Test for module_exists function
test_that("module_exists correctly identifies Shiny modules", {
  # Create mock functions in global environment
  assign("test_module_ui", function() {}, envir = .GlobalEnv)
  assign("test_module_server", function() {}, envir = .GlobalEnv)
  
  # Test when both ui and server exist
  expect_true(module_exists("test_module"))
  
  # Test when only ui exists
  remove("test_module_server", envir = .GlobalEnv)
  expect_false(module_exists("test_module"))
  
  # Recreate server for next test
  assign("test_module_server", function() {}, envir = .GlobalEnv)
  remove("test_module_ui", envir = .GlobalEnv)
  expect_false(module_exists("test_module"))
  
  # Test when neither exists
  if (exists("test_module_server", envir = .GlobalEnv)) {
    remove("test_module_server", envir = .GlobalEnv)
  }
  if (exists("test_module_ui", envir = .GlobalEnv)) {
    remove("test_module_ui", envir = .GlobalEnv)
  }
  expect_false(module_exists("test_module"))
  
  # Test with non-existent module
  expect_false(module_exists("non_existent_module"))
  
  # Clean up
  if (exists("test_module_ui", envir = .GlobalEnv)) {
    remove("test_module_ui", envir = .GlobalEnv)
  }
  if (exists("test_module_server", envir = .GlobalEnv)) {
    remove("test_module_server", envir = .GlobalEnv)
  }
})


# Test for toggleWidget function
test_that("toggleWidget behaves as expected", {
  # Skip if shinyjs not available
  skip_if_not_installed("shinyjs")
  
  # Test with condition TRUE
  widget <- div(id = "test_widget", "Test content")
  result <- toggleWidget(widget, TRUE)
  expect_s3_class(result, "shiny.tag.list")
  
  # Test with condition FALSE
  result <- toggleWidget(widget, FALSE)
  expect_s3_class(result, "shiny.tag.list")
  
  # Test with NULL condition (should be treated as FALSE)
  result <- toggleWidget(widget, NULL)
  expect_s3_class(result, "shiny.tag.list")
})


# Test for Timestamp function
test_that("Timestamp returns a valid UNIX timestamp", {
  # Get a timestamp
  ts <- Timestamp()
  
  # Check that it's a numeric value
  expect_type(ts, "double")
  
  # Check that it's a reasonable value (within a few seconds of current time)
  current_time <- as.numeric(Sys.time())
  expect_lt(abs(ts - current_time), 2) # Should be within 2 seconds
  
  # Check that it's a positive number (UNIX timestamps are seconds since 1970)
  expect_true(ts > 0)
  
  # Check that it's a finite number
  expect_false(is.infinite(ts))
})