#' Chad a file
#' 
#' @section Options:
#' \code{chad.diff} - the diff program to use, defaulting to \code{diff -u}
#' 
#' @param file.name  path to a chad script
#' @param ask        if there is a failure, prompt the user to accept as golden
#' @param quiet      suppress logging messages
#'
#' @export
chad <- function(file.name, ask=interactive(), quiet=!ask) {
  message2 <- function(...) if(!quiet) message(...)
  
  
  old <- setwd(dirname(normalizePath(file.name)))
  on.exit(setwd(old))
  
  file.name <- basename(file.name)
  
  message2("Chadding\t", file.name, "\t...\t", appendLF = ask)
  out.file <- paste0(file.name, ".out")
  processFile(file.name, out.file) 
  d <- diffFiles(file.name, out.file, ask)
  if(d != 0L) {
    if(ask) {
      aag <- readline("\nDifference in output; accept as golden? [y/n/git]")
      if(aag %in% c('y', 'git')){
        file.rename(out.file, file.name)
        message2("ACCEPTED")
      } 
      if(aag == 'git') gitCommit(file.name) 
    } else {
      message2("FAIL")
    }
  } else {
    message2("SUCCESS")
    file.remove(out.file)
  }
  invisible(d)
}



