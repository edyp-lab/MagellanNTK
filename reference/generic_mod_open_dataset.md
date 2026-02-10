# Change the default functions in \`MagellanNTK\`

This module allows to change

## Usage

``` r
open_dataset_ui(id)

open_dataset_server(
  id,
  class = NULL,
  extension = NULL,
  demo_package = NULL,
  remoteReset = reactive({
     NULL
 }),
  is.enabled = reactive({
     TRUE
 })
)

open_dataset(class = NULL, extension = NULL, demo_package = NULL)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- class:

  xxx

- extension:

  xxx

- demo_package:

  xxx

- remoteReset:

  An \`integer\` which acts as a remote command to reset the module. Its
  value is incremented on a external event and it is used to trigger an
  event in this module

- is.enabled:

  xxx

## Value

NA

## Examples

``` r
if (interactive()) {
shiny::runApp(open_dataset(extension = "df"))
}
```
