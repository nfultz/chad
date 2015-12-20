#' Print a data url'd image to console
#'
#' This functions switches off the current graphics device, then prints out an image 
#'tag with a data url of the file. This is intended for use in chad notebooks.
#'
#' @export
#' @importFrom grDevices dev.off
chadPlot <- function() {
  d <- .Device
  f <- sprintf(attr(d, "filepath"), 1)
  dev.off()
  
  cat(sprintf(
    '<img src="data:image/%s;base64,%s"/>\n',
    d,
    paste0(system2("base64", f, TRUE), collapse='')
  ))
  file.remove(f)
  invisible(NULL)
}