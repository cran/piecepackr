% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils-misc.R
\name{pp_utils}
\alias{pp_utils}
\alias{is_color_invisible}
\alias{inch}
\alias{cleave}
\alias{file2grob}
\title{Miscellaneous \code{piecepackr} utility functions}
\usage{
is_color_invisible(col)

inch(inches)

cleave(s, sep = ",", float = FALSE, color = FALSE)

file2grob(file, distort = TRUE)
}
\arguments{
\item{col}{Color}

\item{inches}{Number representing number of inches}

\item{s}{String to convert}

\item{sep}{Delimiter (defaults to ",")}

\item{float}{If \code{TRUE} cast to numeric}

\item{color}{if \code{TRUE} convert empty strings to \code{"transparent"}}

\item{file}{Filename of image}

\item{distort}{Logical value of whether one should preserve the aspect ratio
or distort to fit the area it is drawn in}
}
\description{
\code{cleave()} converts a delimiter separated string into a vector.
\code{inch(x)} is equivalent to \code{grid::unit(x, "in")}.
\code{is_color_invisible()} tells whether the color is transparent (and hence need not be drawn).
}
\examples{
 cleave("0.5,0.2,0.4,0.5", float=TRUE)
 cleave("black,darkred,#050EAA,,", color=TRUE)

 is_color_invisible("transparent")
 is_color_invisible(NA)
 is_color_invisible("blue")
 is_color_invisible("#05AE9C")

 if (requireNamespace("grid", quietly = TRUE)) {
     identical(inch(1), grid::unit(1, "inch"))
 }

}
