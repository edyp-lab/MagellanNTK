# Shiny module \`nav_pipeline()\`

The module navigation can be launched via a Shiny app. This is the core
module of MagellanNTK

## Usage

``` r
nav_pipeline_ui(id)

nav_pipeline_server(
  id = NULL,
  dataIn = reactive({
     NULL
 }),
  is.enabled = reactive({
     TRUE
 }),
  remoteReset = reactive({
     0
 }),
  verbose = FALSE,
  usermod = "user"
)

nav_pipeline()
```

## Arguments

- id:

  A \`character(1)\` which defines the id of the module. It is the same
  as for the server() function.

- dataIn:

  An instance of the class \`MultiAssayExperiment\`

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

- verbose:

  A \`boolean\` to indicate whether to turn off (FALSE) or ON (TRUE) the
  verbose mode for logs.

- usermod:

  A \`character()\` to specifies the running mode of MagellanNTK: 'user'
  (default) or 'dev'. For more details, please refer to the document
  'Inside MagellanNTK'

## Value

A list of four items: \* dataOut A dataset of the same class of the
parameter dataIn \* steps.enabled A vector of \`boolean\` of the same
length than config@steps \* status A vector of \`integer(1)\` of the
same length than the config@steps vector

## Author

Samuel Wieczorek

## Examples

``` r
if (interactive()) {
    library(shiny)
    nav_pipeline()
}
```
