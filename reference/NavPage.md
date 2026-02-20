# Move the position of the cursor

Move the position of the cursor

## Usage

``` r
NavPage(direction, current.pos, len)
```

## Arguments

- direction:

  A \`integer(1)\` which is the direction in the timeline: forward (1),
  backwards (-1).

- current.pos:

  A \`integer(1)\` which is the current position.

- len:

  A \`integer(1)\` which is the number of steps in the process.

## Value

A \`integer(1)\` which is the new current position.

## Examples

``` r
NavPage(-1, 5, 5)
#> [1] 4

```
