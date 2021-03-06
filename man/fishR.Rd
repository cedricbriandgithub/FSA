% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FSAUtils.R
\name{fishR}
\alias{fishR}
\title{Opens web pages associated with the fishR website.}
\usage{
fishR(where = c("home", "IFAR", "general", "books", "AIFFD", "posts", "news"))
}
\arguments{
\item{where}{A string that indicates a particular page on the fishR website to open.}
}
\value{
None, but a webpage will be opened in the default browser.
}
\description{
Opens web pages associated with the \href{http://derekogle.com/fishR/}{fishR website} in a browser.  The user can open the main page or choose a specific page to open.
}
\examples{
## ONLY RUN IN INTERACTIVE MODE
if (interactive()) {

fishR()            # home page
fishR("IFAR")      # Introduction to Fisheries Analysis with R page
fishR("general")   # exapmles page
fishR("books")     # examples page
fishR("AIFFD")     # Analysis & Interpretation of Freshwater Fisheries Data page
fishR("posts")     # blog posts (some examples) page

} ## END IF INTERACTIVE MODE

}
\author{
Derek H. Ogle, \email{derek@derekogle.com}
}
\keyword{misc}
