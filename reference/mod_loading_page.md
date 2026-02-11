# Load customizable functions

A shiny Module.which allow to choose whether to use the default
functions (embedded in Magellan) or functions provided by external
packages. The names of these functions (shiny modules) are: \*
convert(): xxx \* open_dataset(): xxx \* open_demoDataset(): xxx \*
view_dataset(): xxxx \* infos_dataset(): xxx

Thus, MagellanNTK seraches in the global environment if any package
exports one or more of these functions. If so,

For each of these functions, the shiny app lists all the packages that
export it. Once the user has make its choices, the module returns a list
containing the infos.

## Usage

``` r
loadapp_ui(id)

loadapp_server(id)

loadApp()
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    app <- loadApp()
    shiny::runApp(app)
}
```
