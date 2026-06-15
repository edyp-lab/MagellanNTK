# Loads packages

Checks if a package is available to load it

Checks if a package is available to load it

## Usage

``` r
pkgsRequire(ll.deps)

pkgsRequire(ll.deps)
```

## Arguments

- ll.deps:

  A vector of \`character()\` which contains packages names

## Value

NA

## Author

Samuel Wieczorek

## Examples

``` r
NULL
#> NULL

# \donttest{
pkgsRequire(c("stats"))
#> [[1]]
#> NULL
#> 
# }
```
