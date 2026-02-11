# xxx

xxx

## Usage

``` r
NavPage(direction, current.pos, len)
```

## Arguments

- direction:

  A \`integer(1)\` which is the direction of the xxx: forward ('1'),
  backwards ('-1').

- current.pos:

  A \`integer(1)\` which is the current position.

- len:

  A \`integer(1)\` which is the number of steps in the process.

## Value

A \`integer(1)\` which is the new current position.

## Details

\#' @title Status to string \#' \#' @description Converts status code
(intefer) into a readable string. \#' \#' @param i xxx \#' \#' @param
title.style A \`boolean\` to indicate if \#' \#' @return NA \#' @export
\#' @examples \#' NULL GetStringStatus \<- function(i, title.style =
FALSE) txt \<- names(which(stepStatus == i)) if (title.style) txt \<-
paste(substr(txt, 1, 1), tolower(substr(txt, 2, nchar(txt))), sep = "" )
txt

## Examples

``` r
NULL
#> NULL
```
