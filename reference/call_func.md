# Wrapper to the function \`do.call\`

Wrapper to the function \`do.call\`

## Usage

``` r
call_func(fname, args)
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
call_func("stats::rnorm", list(n =10, mean=3))
#>  [1] 1.5999565 3.2553171 0.5627364 2.9944287 3.6215527 4.1484116 1.1781823
#>  [8] 2.7526747 2.7558004 2.7172946
```
