# This function exports a data.frame to a Excel file.

This is the default function fo export the current dataset as an Excel
file.

## Usage

``` r
write.excel(df, colors, tags, filename = NULL)
```

## Arguments

- df:

  A list of data.frame() items

- colors:

  xxx

- tags:

  xxx

- filename:

  A character string for the name of the Excel file.

## Value

A Excel file (.xlsx)

## Author

Samuel Wieczorek

## Examples

``` r
# \donttest{
write.excel(data.frame(), filename = "foo.xlsx")
#> Warning: Workbook does not contain any worksheets. A worksheet will be added.
unlink('foo.xlsx')
# }
```
