# The server() function of the module \`nav_single_process\`

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
  history = reactive({
     NULL
 }),
  remoteResetUI = reactive({
     0
 }),
  is.enabled = TRUE,
  is.skipped = FALSE,
  verbose = FALSE,
  usermod = "user",
  btnEvents = reactive({
     NULL
 })
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

  xxx

- history:

  xxx

- remoteResetUI:

  xxx

- is.enabled:

  xxxx

- is.skipped:

  is.skipped xxx

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
    nav_single_process()
}
```
