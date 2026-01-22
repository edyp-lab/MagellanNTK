# Find the packages of a function

This code is extracted from https://sebastiansauer.github.io/finds_funs/

## Usage

``` r
find_funs(f)
```

## Arguments

- f:

  name of function for which the package(s) are to be identified.

## Value

A dataframe with two columns:

## Examples

``` r
# \donttest{
find_funs("filter")
#> Error in dplyr::select(dplyr::filter(pckgs, pckgs$Priority %in% c("base",     "recommended")), pckgs$Package): Can't select columns that don't exist.
#> ✖ Columns `BiocGenerics`, `BiocManager`, `BiocStyle`, `DBI`, `DT`, etc. don't exist.
# }
```
