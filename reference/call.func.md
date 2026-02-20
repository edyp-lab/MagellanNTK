# Wrapper to the function \`do.call\`

Wrapper to the function \`do.call\`

## Usage

``` r
call.func(fname, args)
```

## Arguments

- fname:

  The name of the function to execute

- args:

  The \`list()\` of its arguments

## Value

The result of the function called

## See also

\[do.call()\]

## Examples

``` r
call.func("stats::rnorm", list(n =10, mean=3))
#>  [1] 3.362951 1.695456 3.737776 4.888505 2.902555 2.064153 2.984050 2.173211
#>  [9] 1.487600 3.935363
```
