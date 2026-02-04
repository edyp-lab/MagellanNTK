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
  history = reactive({
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
  usermod = "user",
  btnEvents = reactive({
     NULL
 })
)

nav_process()
```

## Arguments

- id:

  A \`character(1)\` which defines the id of the module. It is the same
  as for the server() function.

- dataIn:

  The dataset

- status:

  xxx

- history:

  xxx

- is.enabled:

  A \`boolean\`. This variable is a remote command to specify if the
  corresponding module is enabled/disabled in the calling module of
  upper level. For example, if this module is part of a pipeline and the
  pipeline calculates that it is disabled (i.e. skipped), then this
  variable is set to TRUE. Then, all the widgets will be disabled. If
  not, the enabling/disabling of widgets is deciding by this module.

- remoteReset:

  It is a remote command to reset the module. A boolen that indicates is
  the pipeline has been reseted by a program of higher level Basically,
  it is the program which has called this module

- remoteResetUI:

  xxx

- is.skipped:

  xxx

- verbose:

  = FALSE,

- usermod:

  = 'user'

- btnEvents:

  xxxx

## Value

A list of four items: \* dataOut A dataset of the same class of the
parameter dataIn \* steps.enabled A vector of \`boolean\` of the same
length than config@steps \* status A vector of \`integer(1)\` of the
same length than the config@steps vector \* reset xxxx

## Author

Samuel Wieczorek

## Examples

``` r
if (interactive()) {
    nav_process()
}
```
