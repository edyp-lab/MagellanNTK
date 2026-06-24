library(testthat)
library(MagellanNTK)


test_that("GetPackageVersion returns version for installed packages", {
  # Test with a base R package that should be installed
  result <- GetPackageVersion("stats")
  expect_is(result, "character")
  expect_true(nzchar(result))  # Should return a non-empty string
})

test_that("GetPackageVersion returns NA for non-installed packages", {
  # Test with a non-existent package
  result <- GetPackageVersion("nonexistent_package_12345")
  expect_equal(result, NA)
})

test_that("GetPackageVersion handles NULL input", {
  # Test with NULL input
  result <- GetPackageVersion(NULL)
  expect_equal(result, character())
})


test_that("call_func executes functions correctly", {
  # Test with a simple function
  result <- call_func("base::sum", list(c(1, 2, 3)))
  expect_equal(result, 6)
  
  # Test with a function from a package
  result <- call_func("stats::rnorm", list(n = 5, mean = 0, sd = 1))
  expect_is(result, "numeric")
  expect_equal(length(result), 5)
  
  # Test with a custom function
  custom_func <- function(a, b) a + b
  assign("custom_func", custom_func, envir = .GlobalEnv)
  result <- call_func("custom_func", list(a = 2, b = 3))
  expect_equal(result, 5)
  rm("custom_func", envir = .GlobalEnv)
})

test_that("call_func handles errors", {
  # Test with a non-existent function
  expect_error(
    call_func("nonexistent_function", list())
  )
  
  # Test with invalid arguments
  expect_error(
    call_func("base::ncol", list(a = 1)) # sum doesn't have 'a' argument
  )
})


test_that("initComplete returns valid JavaScript code", {
  result <- initComplete()
  
  # Check it returns a JS object
  expect_is(result, "JS_EVAL")
  
  # Check the content contains expected strings
  js_code <- as.character(result)
  expect_match(js_code, "function\\(settings, json\\)")
  expect_match(js_code, "background-color.*darkgrey")
  expect_match(js_code, "color.*black")
})


test_that("GetExtension returns correct file extension", {
  # Test with simple extension
  expect_equal(GetExtension("file.txt"), "txt")
  expect_equal(GetExtension("data.csv"), "csv")
  expect_equal(GetExtension("image.png"), "png")
  
  # Test with multiple dots
  expect_equal(GetExtension("file.tar.gz"), "gz")
  expect_equal(GetExtension("archive.tar.bz2"), "bz2")
  
  # Test with no extension
  expect_equal(GetExtension("file"), "file")
  
  # Test with dot at beginning
  expect_equal(GetExtension(".hidden"), "hidden")
  
  # Test with empty string
  expect_equal(GetExtension(""), character())
})


test_that("pkgsRequire loads installed packages", {
  # Test with a base R package
  expect_silent(pkgsRequire("stats"))
})

test_that("pkgsRequire throws error for non-installed packages", {
  # Test with a non-existent package
  expect_error(
    pkgsRequire("nonexistent_package_12345"),
    regexp = "Please install nonexistent_package_12345"
  )
  
  # Test with multiple packages (one missing)
  expect_error(
    pkgsRequire(c("stats", "nonexistent_package_12345")),
    regexp = "Please install nonexistent_package_12345"
  )
})

test_that("pkgsRequire handles empty input", {
  # Test with empty vector
  expect_silent(pkgsRequire(character(0)))
})
