#' Run Chad scripts on entire directory
#'
#' This will run \code{chad} on every chadscript in a folder (optionally including subfolders); 
#'
#' @param path  Path of directory to process 
#' @param recursive include subfolders
#' @param ask   At each failure, ask if to accept
#' @param quiet Suppress logging
#' 
#' @return TRUE if all tests passes. Additional test data is also provided as attributes.
#' 
#' @seealso chad
#' @export
chadRecur <- function(path='.', recursive=TRUE, ask=FALSE, quiet=FALSE) {
  
  start <- Sys.time()
  
  tests <- data.frame(file=dir(path, "[.]chad$", recursive = recursive), 
                      status=NA, time=NA, stringsAsFactors = FALSE);

  old <- setwd(path)
  on.exit(setwd(old))
  
  for(i in seq(nrow(tests))){
    tests$time[i] <- system.time(  tests$status[i] <- chad(tests$file[i], ask, quiet)   )[3] # Element 3 is total time
  }
  
  structure(all(tests$status == 0), 
            tests = tests, 
            start.time = start, finish.time = Sys.time(),
            call = match.call(),
            path = path, class = 'chadResults')
  
  
}

#' @export
print.chadResults <- function(x, ...){
  print(attr(x, 'tests'))
}

#' @export
summary.chadResults <- function(object, ...){
  tests <- attr(object,"tests")
  structure(list(
      tests = tests[tests$status != 0, ],
      x = sum(tests$status == 0),
      n = nrow(tests),
      time = ceiling(difftime(attr(object, "finish.time"), attr(object, "start.time"), "minutes")),
      call = attr(object, "call")
    ), 
    class = "summary.chadResults"
  )
  
  
}

#' @export
print.summary.chadResults <- function(x,...){
  msg <-sprintf("%d tests of %d passed in < %d minutes", x$x, x$n, x$time)

  
  cat("Call:",   
      deparse(x$call),
      "",
      msg,
      gsub(".", '-', msg),
      sep = "\n")

  if(nrow(x$tests) > 0) {
    cat("FAILURES:\n")
    print(x$tests)
  }
  
  invisible(NULL)
}




