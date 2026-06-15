# Choose a Folder Interactively

This code is heavily based on the following repository:
https://github.com/wleepang/shiny-directory-input Display an OS-native
folder selection dialog under Mac OS X, Linux GTK+ or Windows.

Given x and y, return y only if both x and y are set

## Usage

``` r
x %AND% y

isWindows()

isLinux()

isDarwin()

file_sep()

choose_dir(default = NA, caption = NA, useNew = TRUE)

choose_dir.darwin(default = NA, caption = NA)

choose_dir.linux(default = NA, caption = NA)

choose_dir.windows(default = NA, caption = NA, useNew = TRUE)
```

## Arguments

- x:

  left operand

- y:

  right operand

- default:

  which folder to show initially

- caption:

  the caption on the selection dialog

- useNew:

  boolean, selects the type of dialog shown in windows

## Value

A length one character vector, character NA if 'Cancel' was selected.

A length one character vector, character NA if 'Cancel' was selected.

A length one character vector, character NA if 'Cancel' was selected.

A length one character vector, character NA if 'Cancel' was selected.

## Details

Uses an Apple Script, Zenity or Windows Batch script to display an
OS-native folder selection dialog.

For Apple Script, with `default = NA`, the initial folder selection is
determined by default behavior of the "choose folder" script. Otherwise,
paths are expanded with
[`path.expand`](https://rdrr.io/r/base/path.expand.html).

For Linux, with `default = NA`, the initial folder selection is
determined by defaul behavior of the zenity script.

The new windows batch script allows both initial folder and caption to
be set. In the old batch script for Windows the initial folder is always
ignored.

## See also

`choose_dir`

## Examples

``` r
NULL
#> NULL
```
