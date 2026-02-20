# mod_release_notes_ui and mod_release_notes_server

A shiny Module.

## Usage

``` r
mod_release_notes_ui(id)

mod_release_notes_server(id, URL_releaseNotes)

release_notes(URL_releaseNotes)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- URL_releaseNotes:

  The path to the Rmd file to display. It can be a path to a file on the
  computer or a link to a file over internet.

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    url <- "http://www.prostar-proteomics.org/md/versionNotes.md"
    shiny::runApp(release_notes(url))
}
```
