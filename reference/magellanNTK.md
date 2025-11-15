# Main Shiny application

xxx

DO NOT REMOVE.

## Usage

``` r
MagellanNTK_ui(id, sidebarSize = "medium")

MagellanNTK_server(
  id,
  dataIn = reactive({
     NULL
 }),
  workflow.path = reactive({
     NULL
 }),
  workflow.name = reactive({
     NULL
 }),
  verbose = FALSE,
  usermod = "dev"
)

MagellanNTK(
  dataIn = NULL,
  workflow.path = NULL,
  workflow.name = NULL,
  verbose = FALSE,
  usermod = "dev",
  sidebarSize = "medium",
  ...
)
```

## Arguments

- id:

  xxx

- dataIn:

  xxx

- workflow.path:

  xxx

- workflow.name:

  xxxx

- verbose:

  A \`boolean(1)\`

- usermod:

  xxx

- ...:

  xxx

## Value

NA

## Details

The list of customizable funcs (param \`funcs\`) contains the following
items:

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

if (interactive()) {
    # launch without initial config
    shiny::runApp(MagellanNTK())
}
```
