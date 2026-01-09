# Shiny example module \`Process\`

This module contains the configuration information for the corresponding
pipeline. It is called by the nav_pipeline module of the package
MagellanNTK This documentation is for developers who want to create
their own pipelines nor processes to be managed with \`MagellanNTK\`.

## Usage

``` r
pipe_workflow_ui(id)

pipe_workflow_server(
  id,
  path = NULL,
  dataIn = reactive({
     NULL
 }),
  usermod = "user",
  verbose = FALSE
)

pipe_workflowApp(
  id,
  path = NULL,
  dataIn = NULL,
  usermod = "user",
  verbose = FALSE
)

proc_workflow_ui(id)

proc_workflow_server(
  id,
  path = NULL,
  dataIn = reactive({
     NULL
 }),
  usermod = "user",
  verbose = FALSE
)

proc_workflowApp(
  id,
  path = NULL,
  dataIn = NULL,
  usermod = "user",
  verbose = FALSE
)
```

## Arguments

- id:

  xxx

- path:

  xxx

- dataIn:

  xxx

- usermod:

  Available values are 'superdev', 'dev', 'superuser', 'user'

- verbose:

  xxx

## Value

NA

## Author

Samuel Wieczorek

## Examples

``` r
if (interactive()) {
    library(MagellanNTK)
    library(shiny)
    path <- system.file("workflow/PipelineDemo", package = "MagellanNTK")
    files <- list.files(file.path(path, "R"), full.names = TRUE)
    for (f in files) {
        source(f, local = FALSE, chdir = TRUE)
    }


    # Nothing happens when dataIn is NULL
    pipe_workflowApp("PipelineDemo", path, dataIn = NULL)

    pipe_workflowApp("PipelineDemo", path, dataIn = lldata)

    pipe_workflowApp("PipelineDemo", dataIn = data.frame())

    pipe_workflowApp("PipelineDemo", path, dataIn = lldata)

    pipe_workflowApp("PipelineB", path, tl.layout = c("v", "h"))

    pipe_workflowApp("PipelineDemo", path,
        dataIn = lldata,
        tl.layout = c("v", "h")
    )


    # Nothing happens when dataIn is NULL
    proc_workflowApp("PipelineDemo_Process1", path, dataIn = NULL)

    proc_workflowApp("PipelineDemo_Process1", path, dataIn = lldata)

    proc_workflowApp("PipelineDemo_Process1", path, dataIn = data.frame(), tl.layout = "v")

    proc_workflowApp("PipelineDemo", path, dataIn = lldata, tl.layout = c("v", "h"))

    proc_workflowApp("PipelineDemo", path, dataIn = lldata, tl.layout = c("v", "h"))
}
```
