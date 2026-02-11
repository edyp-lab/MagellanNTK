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

  xxx

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    url <- "http://www.prostar-proteomics.org/md/versionNotes.md"
    shiny::runApp(release_notes(url))
}
```
