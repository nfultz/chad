#' Equip a package with Chad
#'
#' Adds a chad test hook to a packages \code{tests/}, and \code{DESCRIPTION} (if you have devtools).
#' Run this from a package's source root directory.
#'
#' @param pkg package path
#'
#' @export
useChad <- function(pkg='.') {
  message("Creating tests/chad/ ...")
  dir.create(file.path(pkg, "tests", "chad"), recursive=TRUE, showWarnings=FALSE)

  message("Copying test stub ...")
  files <- c("tests/chad.R", "tests/chad/hello.chad")
  mapply(file.copy, system.file(package="chad", files), files)

  if (requireNamespace("devtools", quietly = TRUE)) {
    message("Adding chad to DESCRIPTION ...")
    devtools::use_package("chad", "Suggests")
  } else message("Please add chad to DESCRIPTION")

  message("testing chad")
  chadCheck()
  
  invisible(TRUE)
}
