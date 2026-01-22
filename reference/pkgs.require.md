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

  A \`character()\` vector which contains packages names

## Value

NA

## Author

Samuel Wieczorek

## Examples

``` r
NULL
#> NULL

# \donttest{
pkgs.require(c("omXplore"))
#> Error in FUN(X[[i]], ...): Please install omXplore: install.packages('omXplore')
# }
```
