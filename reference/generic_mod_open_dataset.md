# Change the default functions in \`MagellanNTK\`

This module allows to change

## Usage

``` r
open_dataset_ui(id)

open_dataset_server(
  id,
  class = NULL,
  demo_package = NULL,
  extension = NULL,
  remoteReset = reactive({
     NULL
 }),
  is.enabled = reactive({
     TRUE
 })
)

open_dataset(extension = NULL)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- class:

  xxx

- demo_package:

  xxx

- extension:

  The extension file allowed

- remoteReset:

  An \`integer\` which acts as a remote command to reset the module. Its
  value is incremented on a external event and it is used to trigger an
  event in this module

- is.enabled:

  A \`boolean\`. This variable is used as a remote command to specify if
  the corresponding module is enabled/disabled in the calling module of
  upper level. For example, if this module is disabled, then this
  variable is set to TRUE. Then, all the widgets will be disabled. If
  not, the enabling/disabling of widgets is deciding by this module.

## Value

A Shiny app

## Examples

``` r
if (interactive()) {
shiny::runApp(open_dataset(extension = "rdata"))
}
```
