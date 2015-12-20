#' Run chad scripts for a package
#'
#' A helper function to run all tests in the current directory, and print out a summary of the results.
#' 
#' @return data frame containing the results
#' @seealso chadRecur
#' @export
chadCheck <- function() {
  results <- chadRecur(quiet = TRUE)
  attr(results, "call") <- match.call()
  print(summary(results))
  invisible(results)
}
