# mod_main_page_ui and mod_loading_page_server

A shiny Module.

## Usage

``` r
mainapp_ui(id, session, size = "300px")

mainapp_server(
  id,
  dataIn = reactive({
     NULL
 }),
  data.name = reactive({
     "myDataset"
 }),
  workflow.name = reactive({
     NULL
 }),
  workflow.path = reactive({
     NULL
 }),
  verbose = FALSE,
  usermod = "user"
)

mainapp(usermod = "user")
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- session:

  xxx

- size:

  The width of the sidebar.in pixels

- dataIn:

  xxx

- data.name:

  The name of the dataset. Default is 'myDataset'

- workflow.name:

  Default is NULL,

- workflow.path:

  Default is NULL,

- verbose:

  = FALSE,

- usermod:

  = 'dev'

## Value

NA

## Examples

``` r
if (interactive()) {
    shiny::runApp(mainapp())
}
```
