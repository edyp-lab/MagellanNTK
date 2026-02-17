# Main Shiny application

xxx

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

  A character to specifies the running mode of MagellanNTK. \* user
  (default) : xxx \* dev: xxx

- ...:

  Additional parameters

## Value

A shiny app

## Details

The list of customizable functions (param \`funcs\`) contains the
following items:

These are the default values where each item points to a default
fucntion implemented into MagellanNTK.

The user can modify these values by two means: \* setting the values in
the parameter to pass to the function \`MagellanNTK()\`, \* inside the
UI of MagellanNTK, in the settings panels

## Examples

``` r
if (interactive()) {
    MagellanNTK()
    }
```
