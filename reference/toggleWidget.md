# Hide/show a widget w.r.t a condition.

Wrapper for the \`toggleWidget')\` function of the package \`shinyjs\`

## Usage

``` r
toggleWidget(widget, condition)
```

## Arguments

- widget:

  The id of a \`Shiny\` widget

- condition:

  A \`logical()\` to hide/show the widget.

## Value

NA

## Details

\#' @title \#' Basic check workflow directory \#' \#' @description \#'
This function checks if the directory contains well-formed directories
and files \#' It must contains 3 directories: 'md', 'R' and 'data'. \#'
The 'R' directory must contains two directories: \#' \* 'workflows' that
contains the source files for workflows, \#' \* 'other' that contains
additional source files used by workflows. This directory \#' can be
empty. For each \#' file in the 'R/workflows' directory, there must
exists a \*.md file with the same filename \#' in the 'md' directory.
\#' The 'data' directory can be empty.

\#' \#' @param path A \`character()\` \#' \#' @return A \`boolean(S)\`
\#' \#' @export \#' @examples \#' NULL CheckWorkflowDir \<-
function(path) is.valid \<- TRUE \# Checks if 'path' contains the 3
directories dirs \<- list.files(path) cond \<- all.equal(rep(TRUE, 3),
c("R", "md", "data") is.valid \<- is.valid && cond if (!cond)
message("atat") dirs \<- list.files(file.path(path, "R")) cond \<-
all.equal(rep(TRUE, 2), c("workflows", "other") is.valid \<- is.valid &&
cond if (!cond) message("atat") \# Checks the correspondance between
files in 'R' and 'md' directories files.R \<- list.files(file.path(path,
"R/workflows")) files.md \<- list.files(file.path(path, "md")) \# Remove
the definition of root pipelines which does not have a \# corresponding
md file (their description is contained in a separate file) files.R \<-
files.R\[grepl("\_", files.R)\] files.R \<- gsub(".R", "", files.R)
files.md \<- gsub(".Rmd", "", files.md) n.R \<- length(files.R) n.md \<-
length(files.md) cond \<- n.R == n.md is.valid \<- is.valid && cond if
(!cond) message("Lengths differ between xxx") else cond \<-
all.equal(rep(TRUE, n.R), c("R", "md", "data") if (!cond)
message("titi") is.valid \<- is.valid && cond return(is.valid)

## Author

Samuel Wieczorek

## Examples

``` r
NULL
#> NULL
```
