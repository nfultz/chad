#' Run Chad scripts on entire directory tree
#'
#' This will run \code{chad} on every chadscript in a folder (including subfolders); 
#'
#' @param path  Path of directory to process 
#' @param meta  metadata to attach to the result
#' @param ask   At each failure, ask if to accept
#' @seealso chad
#' @export
chadRecur <- function(path='.', meta=list(start=Sys.time()), ask=FALSE) {
  
  tests <- data.frame(file=dir(path, "[.]chad$", recursive = TRUE), status=NA, time=NA, stringsAsFactors = FALSE);
  attr(tests, "meta") <- meta
  
  for(i in seq(nrow(tests))){
    tests$time[i] <- system.time(  tests$status[i] <- chad(tests$file[i], ask)   )[3] # Element 3 is total time
  }
  
  tests
  
  
}