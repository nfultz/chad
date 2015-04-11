#' Equip a package with Chad
#'
#' Adds a chad test hook to a packages \code{tests/} and \code{DESCRIPTION}.
#' Run this from a package's source root directory.
#'
#' @export
equipChad <- function() {
  message("Creating tests/chad/ ...")
  dir.create("tests/chad", recursive=TRUE, showWarnings=FALSE)

  message("Copying test stub ...")
  for(f in c("tests/chad.R", "tests/chad/meta", "tests/chad/hello.chad")) {
    file.copy(system.file(package="chad", f), f)
  }

  if (requireNamespace("devtools", quietly = TRUE)) {
    message("Adding chad to DESCRIPTION ...")
    devtools::use_package("chad", "Suggests")
  }

  message("testing chad")
  setwd("tests/chad")
  chad("meta")
  setwd("../..")

  invisible(TRUE)
}
