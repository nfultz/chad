# Internal helper fn, keeps down on parens
systemf <- function(..., ignore.stdout=FALSE) system(sprintf(...), ignore.stdout=ignore.stdout)

# Run a single chad script from inconn and write to outconn
processFile <- function(inconn=stdin(), outconn=stdout()) {
  # the regex below should match lines that begin with --, and extract the following command
  lines <- na.omit(str_extract(readLines(inconn), perl("(?<=^--).*")))
  e <- new.env(parent=.GlobalEnv)
  on.exit(sink())
  sink(outconn)
  # A primitive read-eval-print loop
  tryCatch(error=print,
    for(line in lines) {
      cat('--', line, '\n', sep='')
      eval(parse(text=line), e)
    }  
  )
}

