# Loads packages

Checks if a package is available to load it

Checks if a package is available to load it

## Usage

``` r
pkgs.require(ll.deps)

pkgs.require(ll.deps)
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
pkgs.require(c("stats"))
#> [[1]]
#> NULL
#> 
# }
```
