#' Diff two files
#' 
#' Invoke the \code{diff} UNIX utility to compare two files.
#' 
#' @param file1   a file path
#' @param file2   another file path
#' @param verbose print diff output
diff.files <- function(file1, file2, verbose) {
  color <- getOption("chad.color", FALSE)
  d <- paste("diff -u '%s' '%s'", if(color) "|colorout")
  d <- systemf(d, file1, file2, ignore.stdout=!verbose)
  d
}
