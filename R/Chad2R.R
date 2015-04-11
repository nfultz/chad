#' @export
Chad2R <- function(file, out=paste0(file, ".R")) {
  cat(str_extract(readLines(file), perl("(?<=^--).*|$")), file=out, sep="\n")
}
