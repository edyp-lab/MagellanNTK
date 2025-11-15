# Change the value of a directoryInput on the client

Change the value of a directoryInput on the client

## Usage

``` r
updateDirectoryInput(session, inputId, value = NULL, ...)
```

## Arguments

- session:

  The `session` object passed to function given to `shinyServer`.

- inputId:

  The id of the input object.

- value:

  A directory path to set

- ...:

  Additional arguments passed to
  [`choose.dir`](https://edyp-lab.github.io/MagellanNTK/reference/choose.dir.md).
  Only used if `value` is `NULL`.

## Value

NA

## Details

Sends a message to the client, telling it to change the value of the
input object. For `directoryInput` objects, this changes the value
displayed in the text-field and triggers a client-side change event. A
directory selection dialog is not displayed.

## Examples

``` r
NULL
#> NULL
```
