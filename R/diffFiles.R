#' Diff two files
#' 
#' Invoke the \code{diff} UNIX utility to compare two files.
#' 
#' @param file1   a file path
#' @param file2   another file path
#' @param verbose print diff output
diffFiles <- function(file1, file2, verbose) {
  systemf("%s '%s' '%s'", getOption("chad.diff", "diff -u"),
          file1, file2, ignore.stdout=!verbose)
}
