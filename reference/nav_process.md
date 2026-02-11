# The server() function of the module \`nav_process\`

The module navigation can be launched via a Shiny app. This is the core
module of MagellanNTK

## Usage

``` r
nav_process_ui(id)

nav_process_server(
  id = NULL,
  dataIn = reactive({
     NULL
 }),
  status = reactive({
     NULL
 }),
  is.enabled = reactive({
     TRUE
 }),
  remoteReset = reactive({
     0
 }),
  remoteResetUI = reactive({
     0
 }),
  is.skipped = reactive({
     FALSE
 }),
  verbose = FALSE,
  usermod = "user"
)

nav_process()
```

## Arguments

- id:

  A \`character(1)\` which defines the id of the module. It is the same
  as for the server() function.

- dataIn:

  An instance of the \`SummarizedExperiment\` class

- status:

  A boolean which indicates whether the current status of the process

- is.enabled:

  A \`boolean\`. This variable is a remote command to specify if the
  corresponding module is enabled/disabled in the calling module of
  upper level. For example, if this module is part of a pipeline and the
  pipeline calculates that it is disabled (i.e. skipped), then this
  variable is set to TRUE. Then, all the widgets will be disabled. If
  not, the enabling/disabling of widgets is deciding by this module.

- remoteReset:

  An \`integer\` which acts as a remote command to reset the module. Its
  value is incremented on a external event and it is used to trigger an
  event in this module

- remoteResetUI:

  xxx

- is.skipped:

  A booelan which indicates whether the pipeline or process is skipped
  (TRUE) or not (FALSE)

- verbose:

  A \`boolean\` to indicate whether to turn off (FALSE) or ON (TRUE) the
  verbose mode for logs.

- usermod:

  A character to specifies the running mode of MagellanNTK. \* user
  (default) : xxx \* dev: xxx

## Value

A shiny App

## Author

Samuel Wieczorek

## Examples

``` r
if (interactive()) {
    nav_process()
}
```
