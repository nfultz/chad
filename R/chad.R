#' Chad a file
#' 
#' @section Options:
#' \code{chad.diff} - the diff program to use, defaulting to \code{diff -u}
#' 
#' @param file.name  path to a chad script
#' @param ask        if there is a failure, prompt the user to accept as golden
#'
#' @export
chad <- function(file.name, ask=interactive()) {
  
  message("Chadding\t", file.name, "\t...\t", appendLF = ask)
  out.file <- paste0(file.name, ".out")
  processFile(file.name, out.file) 
  d <- diff.files(file.name, out.file, ask)
  if(d != 0L) {
    if(ask) {
      aag <- readline("\nDifference in output; accept as golden? [y/n/git]")
      if(aag %in% c('y', 'git')){
        file.rename(out.file, file.name)
        message("ACCEPTED")
      } 
      if(aag == 'git') git.commit(file.name) 
    } else {
      message("FAIL")
    }
  } else {
    message("SUCCESS")
    file.remove(out.file)
  }
  invisible(d)
}



