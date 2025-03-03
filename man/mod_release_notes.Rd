% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mod_release_notes.R
\name{mod_release_notes}
\alias{mod_release_notes}
\alias{mod_release_notes_ui}
\alias{mod_release_notes_server}
\alias{release_notes}
\title{mod_release_notes_ui and mod_release_notes_server}
\usage{
mod_release_notes_ui(id)

mod_release_notes_server(id, URL_releaseNotes)

release_notes(URL_releaseNotes)
}
\arguments{
\item{id}{shiny id}

\item{URL_releaseNotes}{xxx}
}
\description{
A shiny Module.
}
\examples{
\dontrun{
url <- "http://www.prostar-proteomics.org/md/versionNotes.md"
shiny::runApp(release_notes(url))
}

}
