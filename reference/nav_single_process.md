# Shiny module \`nav_single_process()\`

The module navigation can be launched via a Shiny app. This is the core
module of MagellanNTK

## Usage

``` r
nav_single_process_ui(id)

nav_single_process_server(
  id = NULL,
  dataIn = reactive({
     NULL
 }),
  status = reactive({
     NULL
 }),
  remoteResetUI = reactive({
     0
 }),
  is.enabled = TRUE,
  is.skipped = FALSE,
  verbose = FALSE,
  usermod = "user",
  sendDataIfReset = TRUE
)

nav_single_process()
```

## Arguments

- id:

  A \`character(1)\` which defines the id of the module. It is the same
  as for the server() function.

- dataIn:

  An instance of the \`SummarizedExperiment\` class

- status:

  A boolean which indicates whether the current status of the process

- remoteResetUI:

  An \`integer\` which acts as a remote command to reset the UI part of
  the module Its value is incremented on a external event and it is used
  to trigger an event in the module

- is.enabled:

  A \`boolean\`. This variable is used as a remote command to specify if
  the corresponding module is enabled/disabled in the calling module of
  upper level. For example, if this module is disabled, then this
  variable is set to TRUE. Then, all the widgets will be disabled. If
  not, the enabling/disabling of widgets is deciding by this module.

- is.skipped:

  A \`boolean\` which indicates whether the pipeline or process is
  skipped (TRUE) or not (FALSE)

- verbose:

  A \`boolean\` to indicate whether to turn off (FALSE) or ON (TRUE) the
  verbose mode for logs.

- usermod:

  A \`character()\` to specifies the running mode of MagellanNTK: 'user'
  (default) or 'dev'. For more details, please refer to the document
  'Inside MagellanNTK'

- sendDataIfReset:

  A \`boolean\` to indicate if the reseted value must be send to the
  caller in case of reseting the process. This is usefule for example
  for the Convert process

## Value

A shiny App

## Author

Samuel Wieczorek

## Examples

``` r
if (interactive()) {
    nav_single_process()
}
```
