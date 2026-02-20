# Main Shiny application

Main Shiny application

## Usage

``` r
MagellanNTK_ui(id, sidebarSize = "medium")

MagellanNTK_server(
  id,
  workflow.path = reactive({
     NULL
 }),
  workflow.name = reactive({
     NULL
 }),
  verbose = FALSE,
  usermod = "user"
)

MagellanNTK(
  workflow.path = NULL,
  workflow.name = NULL,
  verbose = FALSE,
  usermod = "user",
  sidebarSize = "medium",
  ...
)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- sidebarSize:

  The width of the sidebar. Available values are 'small', 'medium',
  'large'

- workflow.path:

  A \`character()\` which is the path to the directory which contains
  the files and directories of the pipeline.

- workflow.name:

  A \`character()\` which is the name of the pipeline to launch and run
  whithin the framework of MagellanNTK. It designs the name of a
  directory which contains the files and directories of the pipeline.

- verbose:

  A \`boolean\` to indicate whether to turn off (FALSE) or ON (TRUE) the
  verbose mode for logs.

- usermod:

  A \`character()\` to specifies the running mode of MagellanNTK: 'user'
  (default) or 'dev'. For more details, please refer to the document
  'Inside MagellanNTK'

- ...:

  Additional parameters

## Value

A shiny app

## Examples

``` r
if (interactive()) {
    MagellanNTK()
    }
```
