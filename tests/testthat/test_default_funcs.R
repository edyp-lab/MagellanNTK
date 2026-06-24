library(testthat)
library(MagellanNTK)

test_that("addDatasets adds a dataset to a list", {
  # Create test data
  test_list <- list(a = 1, b = 2)
  new_dataset <- 3
  name <- "c"
  
  # Test adding a dataset
  result <- addDatasets(test_list, new_dataset, name)
  
  # Check the result
  expect_equal(length(result), length(test_list) + 1)
  expect_equal(names(result), c("a", "b", name))
  expect_equal(result[[name]], new_dataset)
})

test_that("addDatasets handles empty list", {
  # Test with empty list
  result <- addDatasets(list(), "test_data", "new_name")
  
  # Check the result
  expect_equal(length(result), 1)
  expect_equal(names(result), "new_name")
  expect_equal(result$new_name, "test_data")
})

test_that("addDatasets preserves existing data", {
  # Create test data
  test_list <- list(a = data.frame(x = 1:3), b = matrix(1:4, nrow = 2))
  new_dataset <- list(z = 5)
  
  # Test adding a dataset
  result <- addDatasets(test_list, new_dataset, "c")
  
  # Check existing data is preserved
  expect_equal(result$a, test_list$a)
  expect_equal(result$b, test_list$b)
  expect_equal(result$c, new_dataset$z)
})


test_that("keepDatasets returns correct subset", {
  # Create test data (3D array)
  test_array <- array(1:24, dim = c(2, 3, 4))
  
  # Test keeping specific range
  result <- keepDatasets(test_array, range = c(1, 3))
  
  # Check dimensions
  expect_equal(dim(result), c(2, 3, 2))  # Keeps first and third layers
})

test_that("keepDatasets handles full range", {
  # Create test data
  test_array <- array(1:12, dim = c(2, 2, 3))
  
  # Test with full range
  result <- keepDatasets(test_array, range = 1:3)
  
  # Should return the same array
  expect_equal(result, test_array)
})

test_that("keepDatasets validates range", {
  # Create test data
  test_array <- array(1:12, dim = c(2, 2, 3))
  
  # Test with invalid range (max > length)
  expect_error(
    keepDatasets(test_array, range = c(1, 4))
  )
  
  # Test with missing range
  expect_error(
    keepDatasets(test_array),
    regexp = "Provide range of array to be processed"
  )
  
  # Test with NULL object
  expect_error(
    keepDatasets(NULL, range = 1:3),
    regexp = "!is.null\\(object\\)"
  )
})

test_that("keepDatasets handles single layer", {
  # Create test data
  test_array <- array(1:6, dim = c(2, 3, 1))
  
  # Test keeping single layer
  result <- keepDatasets(test_array, range = 1)
  
  # Check dimensions
  expect_equal(dim(result), c(2, 3))
})
