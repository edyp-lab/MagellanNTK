# format_DT_ui and format_DT_server

A shiny Module.

## Usage

``` r
format_DT_ui(id)

format_DT_server(
  id,
  dataIn = reactive({
     NULL
 }),
  hidden = reactive({
     NULL
 }),
  withDLBtns = FALSE,
  showRownames = FALSE,
  dom = "Bt",
  max.rows = 20,
  hc_style = reactive({
     NULL
 }),
  remoteReset = reactive({
     0
 }),
  is.enabled = reactive({
     TRUE
 })
)

format_DT(
  dataIn,
  hidden = NULL,
  withDLBtns = FALSE,
  showRownames = FALSE,
  dom = "Bt",
  hc_style = NULL,
  remoteReset = NULL,
  is.enabled = TRUE
)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- dataIn:

  A \`data.frame()\`

- hidden:

  Default is NULL,

- withDLBtns:

  Default is FALSE,

- showRownames:

  Default is FALSE,

- dom:

  Default is 'Bt',

- max.rows:

  Default is 20,

- hc_style:

  Default is NULL,

- remoteReset:

  An \`integer\` which acts as a remote command to reset the module. Its
  value is incremented on a external event and it is used to trigger an
  event in this module

- is.enabled:

  Default is TRUE

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    obj <- SummarizedExperiment::assay(lldata[[1]])
    shiny::runApp(format_DT(obj))
    #
    # Compute style from within third party tab
    #
    obj <- as.data.frame(matrix(1:30, byrow = TRUE, nrow = 6))
    colnames(obj) <- paste0("col", 1:5)

    mask <- as.data.frame(matrix(rep(LETTERS[1:5], 6), byrow = TRUE, nrow = 6))


    style <- list(
        cols = colnames(obj),
        vals = colnames(mask),
        unique = unique(mask),
        pal = RColorBrewer::brewer.pal(5, "Dark2")[1:5]
    )

    shiny::runApp(format_DT(obj,
        hidden = mask,
        hc_style = style
    ))
}
```
