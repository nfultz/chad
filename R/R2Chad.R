#' @export
R2Chad <- function(file, out=paste0(file, ".chad")){
  cat(paste0("--", readLines(file), "\n"), file=out, sep="")
}
