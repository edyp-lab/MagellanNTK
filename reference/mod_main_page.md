# mod_main_page_ui and mod_loading_page_server

A shiny Module.

## Usage

``` r
mainapp_ui(id, session, size = "300px")

mainapp_server(
  id,
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

  shiny internal

- size:

  The width of the sidebar.in pixels

- workflow.name:

  A \`character()\` which is the name of the pipeline to launch and run
  whithin the framework of MagellanNTK. It designs the name of a
  directory which contains the files and directories of the pipeline.

- workflow.path:

  A \`character()\` which is the path to the directory which contains
  the files and directories of the pipeline.

- verbose:

  A \`boolean\` to indicate whether to turn off (FALSE) or ON (TRUE) the
  verbose mode for logs.

- usermod:

  A character to specifies the running mode of MagellanNTK. \* user
  (default) : xxx \* dev: xxx

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    shiny::runApp(mainapp())
}
```
