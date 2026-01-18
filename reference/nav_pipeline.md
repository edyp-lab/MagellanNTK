# The server() function of the module \`nav_pipeline\`

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
  remoteReset = reactive({
     0
 }),
  is.skipped = reactive({
     FALSE
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

  The dataset

- remoteReset:

  It is a remote command to reset the module. A boolen that indicates is
  the pipeline has been reseted by a program of higher level Basically,
  it is the program which has called this module

- verbose:

  = FALSE,

- usermod:

  = 'user'

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
    library(shiny)
    nav_pipeline()
}
```
