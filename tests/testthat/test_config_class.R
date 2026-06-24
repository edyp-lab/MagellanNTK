library(testthat)
library(MagellanNTK)


test_that("Config constructor creates valid Config object", {
  # Test basic process configuration
  proc <- Config(
    fullname = "PipelineDemo_DataGeneration",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
  )
  
  expect_s4_class(proc, "Config")
  expect_equal(proc@fullname, "PipelineDemo_DataGeneration")
  expect_equal(proc@mode, "process")
  expect_equal(proc@steps, 
               c(Description = "Description", DataGeneration = "DataGeneration", Save = "Save"))
  expect_equal(proc@mandatory, 
               c(Description = TRUE, DataGeneration = TRUE, Save = TRUE))
  expect_equal(proc@name, "DataGeneration")
  expect_equal(proc@parent, "PipelineDemo")
  expect_equal(proc@steps.source.file, logical(0))
})

test_that("Config constructor handles pipeline configuration", {
  # Test pipeline configuration
  pipe <- Config(
    fullname = "PipelineDemo",
    mode = "pipeline",
    steps = c("DataGeneration", "Preprocessing", "Clustering"),
    mandatory = c(TRUE, FALSE, FALSE)
  )
  
  expect_s4_class(pipe, "Config")
  expect_equal(pipe@fullname, "PipelineDemo")
  expect_equal(pipe@mode, "pipeline")
  expect_equal(pipe@steps, 
               c(Description = "Description", DataGeneration = "DataGeneration", 
                 Preprocessing = "Preprocessing", Clustering = "Clustering", Save = "Save"))
  expect_equal(pipe@mandatory, 
               c(Description = TRUE, DataGeneration = TRUE, 
                 Preprocessing = FALSE, Clustering = FALSE, Save = TRUE))
  expect_equal(pipe@name, "PipelineDemo")
  expect_equal(pipe@parent, "")
  expect_equal(pipe@steps.source.file, logical(0))
})

test_that("Config constructor handles Description process", {
  # Test Description process
  desc <- Config(
    fullname = "PipelineDemo_Description",
    mode = "process"
  )
  
  expect_s4_class(desc, "Config")
  expect_equal(desc@fullname, "PipelineDemo_Description")
  expect_equal(desc@mode, "process")
  expect_equal(desc@steps, c(Description = "Description"))
  expect_equal(desc@mandatory, c(Description = TRUE))
  expect_equal(desc@name, "Description")
  expect_equal(desc@parent, "PipelineDemo")
  expect_equal(desc@steps.source.file, "Description.R")
})

test_that("Config constructor handles Save process", {
  # Test Save process
  save_proc <- Config(
    fullname = "PipelineDemo_Save",
    mode = "process"
  )
  
  expect_s4_class(save_proc, "Config")
  expect_equal(save_proc@fullname, "PipelineDemo_Save")
  expect_equal(save_proc@mode, "process")
  expect_equal(save_proc@steps, c(Save = "Save"))
  expect_equal(save_proc@mandatory, c(Save = TRUE))
  expect_equal(save_proc@name, "Save")
  expect_equal(save_proc@parent, "PipelineDemo")
  expect_equal(save_proc@steps.source.file, "Save.R")
})

test_that("Config constructor handles simple fullname", {
  # Test simple fullname (no parent)
  simple_proc <- Config(
    fullname = "SimpleProcess",
    mode = "process",
    steps = c("Step1"),
    mandatory = c(TRUE)
  )
  
  expect_equal(simple_proc@name, "SimpleProcess")
  expect_equal(simple_proc@parent, "")
})

test_that("Config constructor handles empty steps and mandatory", {
  # Test with empty steps and mandatory
  empty_proc <- Config(
    fullname = "PipelineDemo_Empty",
    mode = "process"
  )
  
  expect_null(empty_proc@steps)
  expect_null(empty_proc@mandatory)
})


test_that("Config validity method validates correctly", {
  # Test valid process
  proc <- Config(
    fullname = "PipelineDemo_DataGeneration",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
  )
  expect_true(validObject(proc))
  
  # Test invalid mode
  expect_warning({
    invalid_proc <- Config(
      fullname = "PipelineDemo_DataGeneration",
      mode = "invalid",
      steps = c("DataGeneration"),
      mandatory = c(TRUE)
    )
    validObject(invalid_proc)
  }, "The 'mode' must be one of the following: 'process', 'pipeline'")
  
  # Test invalid fullname (multiple values)
  expect_error(Config(fullname = c("PipelineDemo", "DataGeneration"),
                      mode = "process",
                      steps = c("DataGeneration"),
                      mandatory = c(TRUE))  )
})


test_that("is.process correctly identifies process Config objects", {
  proc <- Config(
    fullname = "PipelineDemo_DataGeneration",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
  )
  expect_true(is.process(proc))
  
  pipe <- Config(
    fullname = "PipelineDemo",
    mode = "pipeline",
    steps = c("DataGeneration", "Preprocessing"),
    mandatory = c(TRUE, FALSE)
  )
  expect_false(is.process(pipe))
})

test_that("is.pipeline correctly identifies pipeline Config objects", {
  pipe <- Config(
    fullname = "PipelineDemo",
    mode = "pipeline",
    steps = c("DataGeneration", "Preprocessing"),
    mandatory = c(TRUE, FALSE)
  )
  expect_true(is.pipeline(pipe))
  
  proc <- Config(
    fullname = "PipelineDemo_DataGeneration",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
  )
  expect_false(is.pipeline(proc))
})

test_that("has.parent correctly identifies Config objects with parent", {
  proc_with_parent <- Config(
    fullname = "PipelineDemo_DataGeneration",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
  )
  expect_true(has.parent(proc_with_parent))
  
  proc_no_parent <- Config(
    fullname = "SimpleProcess",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
  )
  expect_false(has.parent(proc_no_parent))
})


test_that("is.GenericProcess correctly identifies generic processes", {
  # Valid generic process
  proc <- Config(
    fullname = "PipelineDemo_DataGeneration",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
  )
  expect_true(is.GenericProcess(proc))
  
  # Description process (not generic)
  desc_proc <- Config(
    fullname = "PipelineDemo_Description",
    mode = "process",
    steps = "",
    mandatory = ""
  )
  expect_false(is.GenericProcess(desc_proc))
  
  # Process without parent
  simple_proc <- Config(
    fullname = "SimpleProcess",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
  )
  expect_false(is.GenericProcess(simple_proc))
})

test_that("is.GenericPipeline correctly identifies generic pipelines", {
  # Valid generic pipeline
  pipe <- Config(
    fullname = "PipelineDemo",
    mode = "pipeline",
    steps = c("DataGeneration", "Preprocessing"),
    mandatory = c(TRUE, FALSE)
  )
  expect_true(is.GenericPipeline(pipe))
  
  # Pipeline with no steps
  empty_pipe <- Config(
    fullname = "EmptyPipeline",
    mode = "pipeline",
    steps = "",
    mandatory = ""
  )
  expect_true(is.GenericPipeline(empty_pipe))
})

test_that("is.GenericNode correctly identifies generic nodes", {
  # Valid generic node (process)
  proc <- Config(
    fullname = "PipelineDemo_DataGeneration",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
  )
  expect_true(is.GenericNode(proc))
  
  # Valid generic node (pipeline)
  pipe <- Config(
    fullname = "PipelineDemo",
    mode = "pipeline",
    steps = c("DataGeneration", "Preprocessing"),
    mandatory = c(TRUE, FALSE)
  )
  expect_true(is.GenericNode(pipe))
  
  # Description process (not generic node)
  desc_proc <- Config(
    fullname = "PipelineDemo_Description",
    mode = "process",
    steps = "",
    mandatory = ""
  )
  expect_false(is.GenericNode(desc_proc))
  
  # Save process (not generic node)
  save_proc <- Config(
    fullname = "PipelineDemo_Save",
    mode = "process",
    steps = "",
    mandatory = ""
  )
  expect_false(is.GenericNode(save_proc))
})

test_that("is.SpecialProcess correctly identifies special processes", {
  # Description process
  desc_proc <- Config(
    fullname = "PipelineDemo_Description",
    mode = "process",
    steps = "",
    mandatory = ""
  )
  expect_false(is.SpecialProcess(desc_proc, "Description"))
  
  # Save process
  save_proc <- Config(
    fullname = "PipelineDemo_Save",
    mode = "process",
    steps = "",
    mandatory = ""
  )
  expect_false(is.SpecialProcess(save_proc, "Save"))
  
  # Regular process
  proc <- Config(
    fullname = "PipelineDemo_DataGeneration",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
  )
  expect_false(is.SpecialProcess(proc, "Description"))
  expect_false(is.SpecialProcess(proc, "Save"))
})


test_that("init.GenericProcess initializes process correctly", {
  # Create a basic Config object
  proc <- Config(fullname = "PipelineDemo_DataGeneration",
                 mode = "process",
                 steps = c("DataGeneration"),
                 mandatory = c(TRUE))
  
  # Initialize it
  proc <- init.GenericProcess(proc)
  
  expect_equal(proc@steps, c(Description = "Description", Description = "Description", 
                             DataGeneration = "DataGeneration", 
                             Save = "Save", Save = "Save"))
  expect_equal(proc@mandatory, c(Description = TRUE, Description = TRUE, 
                                 DataGeneration = TRUE, 
                                 Save = TRUE, Save = TRUE))
  expect_equal(names(proc@steps), c("Description", "Description", "DataGeneration", "Save", "Save"))
  expect_equal(names(proc@mandatory), c("Description", "Description", "DataGeneration", "Save", "Save"))
})

test_that("init.GenericNode initializes node correctly", {
  # Create a basic Config object
  node <- Config(fullname = "PipelineDemo_DataGeneration",
                 mode = "process",
                 steps = c("DataGeneration"),
                 mandatory = c(TRUE))
  
  # Initialize it
  node <- init.GenericNode(node)
  
  expect_equal(node@steps, c(Description = "Description", Description = "Description", 
                             DataGeneration = "DataGeneration", 
                             Save = "Save", Save = "Save"))
  expect_equal(node@mandatory, c(Description = TRUE, Description = TRUE, 
                                 DataGeneration = TRUE, 
                                 Save = TRUE, Save = TRUE))
  expect_equal(names(node@steps), c("Description", "Description", "DataGeneration", "Save", "Save"))
  expect_equal(names(node@mandatory), c("Description", "Description", "DataGeneration", "Save", "Save"))
})

test_that("init.GenericPipeline initializes pipeline correctly", {
  # Create a basic Config object
  pipe <- Config(fullname = "PipelineDemo",
                 mode = "pipeline",
                 steps = c("DataGeneration", "Preprocessing"),
                 mandatory = c(TRUE, FALSE))
  
  # Initialize it
  pipe <- init.GenericPipeline(pipe)
  
  expect_equal(pipe@steps, c(Description = "Description", Description = "Description", 
                             DataGeneration = "DataGeneration", Preprocessing = "Preprocessing",
                             Save = "Save", Save = "Save"))
  expect_equal(pipe@mandatory,c(Description = TRUE, Description = TRUE, 
                                DataGeneration = TRUE, Preprocessing = FALSE,
                                Save = TRUE, Save = TRUE))
  expect_equal(names(pipe@steps), c("Description", "Description", "DataGeneration", "Preprocessing", "Save", "Save"))
  expect_equal(names(pipe@mandatory), c("Description", "Description", "DataGeneration", "Preprocessing", "Save", "Save"))
  expect_equal(pipe@steps.source.file, c("Description.R", "Description.R", "DataGeneration.R", "Preprocessing.R", "Save.R", "Save.R"))
})

test_that("init.DescriptionProcess initializes Description process correctly", {
  # Create a basic Config object
  desc <- Config(fullname = "PipelineDemo_Description",
                 mode = "process")
  
  # Initialize it
  desc <- init.DescriptionProcess(desc)
  
  expect_equal(desc@steps, c(Description = "Description"))
  expect_equal(desc@mandatory, c(Description = TRUE))
  expect_equal(names(desc@steps), "Description")
  expect_equal(names(desc@mandatory), "Description")
  expect_equal(desc@steps.source.file, "Description.R")
})

test_that("init.SaveProcess initializes Save process correctly", {
  # Create a basic Config object
  save_proc <- Config(fullname = "PipelineDemo_Save",
                      mode = "process")
  
  # Initialize it
  save_proc <- init.SaveProcess(save_proc)
  
  expect_equal(save_proc@steps, c(Save = "Save"))
  expect_equal(save_proc@mandatory, c(Save = TRUE))
  expect_equal(names(save_proc@steps), "Save")
  expect_equal(names(save_proc@mandatory), "Save")
  expect_equal(save_proc@steps.source.file, "Save.R")
})


test_that("RemoveDescriptionStep removes Description step correctly", {
  # Create a Config with Description
  proc <- Config(
    fullname = "PipelineDemo_DataGeneration",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
  )
  
  # Verify Description is present
  expect_equal(proc@steps[1], c(Description = "Description"))
  expect_equal(proc@mandatory[1], c(Description = TRUE))
  expect_equal(length(proc@ll.UI), 0)  
  
  # Remove Description
  proc <- RemoveDescriptionStep(proc)
  
  # Verify Description is removed
  expect_false("Description" %in% proc@steps)
  expect_equal(length(proc@steps), 2)  # DataGeneration, Save
  expect_equal(length(proc@mandatory), 2)
  expect_equal(length(proc@ll.UI), 0)
})


test_that("show method prints Config object correctly", {
  # Create a Config object
  proc <- Config(
    fullname = "PipelineDemo_DataGeneration",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
  )
  
  # Capture output
  output <- capture.output(methods::show(proc))
  
  # Check output contains expected elements
  expect_match(paste(output, collapse = "\n"), "Config")
  expect_match(paste(output, collapse = "\n"), "fullname: PipelineDemo_DataGeneration")
  expect_match(paste(output, collapse = "\n"), "mode: process")
  expect_match(paste(output, collapse = "\n"), "DataGeneration")
})

