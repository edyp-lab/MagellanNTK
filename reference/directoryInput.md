# Directory Selection Control

Directory Selection Control

## Usage

``` r
directoryInput(inputId, label, value = NULL)
```

## Arguments

- inputId:

  The `input` slot that will be used to access the value

- label:

  Display label for the control, or NULL for no label

- value:

  Initial value. Paths are expanded via
  [`path.expand`](https://rdrr.io/r/base/path.expand.html).

## Value

A directory input control that can be added to a UI definition.

## Details

This widget relies on
[`choose.dir`](https://edyp-lab.github.io/MagellanNTK/reference/choose.dir.md)
to present an interactive dialog to users for selecting a directory on
the local filesystem. Therefore, this widget is intended for shiny apps
that are run locally - i.e. on the same system that files/directories
are to be accessed - and not from hosted applications (e.g. from
shinyapps.io).

## See also

[`updateDirectoryInput`](https://edyp-lab.github.io/MagellanNTK/reference/updateDirectoryInput.md),
[`readDirectoryInput`](https://edyp-lab.github.io/MagellanNTK/reference/readDirectoryInput.md),
[`choose.dir`](https://edyp-lab.github.io/MagellanNTK/reference/choose.dir.md)

## Examples

``` r
NULL
#> NULL
```
