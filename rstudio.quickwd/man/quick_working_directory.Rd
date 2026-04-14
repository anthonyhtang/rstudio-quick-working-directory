\name{quick_working_directory}
\alias{quick_working_directory}
\alias{quick_working_directory_active_file}
\alias{quick_working_directory_clipboard}
\title{Set the Working Directory from the Clipboard or Active File in RStudio}
\description{
Convenience wrappers for interactive RStudio use. They set the working
directory from either a clipboard path or the on-disk path of the active
source editor tab, then update the Files pane to match.
}
\usage{
quick_working_directory(source = c("default", "clipboard", "active"))

quick_working_directory_clipboard()

quick_working_directory_active_file()
}
\arguments{
  \item{source}{One of \code{"default"}, \code{"clipboard"}, or
  \code{"active"}. The default mode prefers a valid clipboard path and
  falls back to the active source file.}
}
\value{
Returns the normalized absolute path used for navigation, invisibly.
}
\details{
These helpers are intended for interactive use inside RStudio. The
\code{clipboard} mode reads the first clipboard line as a file-system path.
The \code{active} mode uses the current source editor tab and sets the
working directory to the file's parent folder.
}
\examples{
if (rstudioapi::isAvailable()) {
  quick_working_directory("active")
}
}
