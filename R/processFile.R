# Internal helper fn, keeps down on parens
systemf <- function(fmt, ..., ignore.stdout=FALSE) 
  system(sprintf(fmt, ...), ignore.stdout=ignore.stdout)

# Run a single chad script from inconn and write to outconn
processFile <- function(IN=stdin(), OUT=stdout()) {

  if(OUT != stdout()) {
    on.exit(sink())
    sink(OUT)
  }
  
  blocks <- local({    
    # the regex below should match lines that begin with --, 
    # and extract the command without trailing space
    lines <- readLines(IN, warn=FALSE)
    lines <- na.omit(str_extract(lines, perl("(?<=^--).*?(?=\\s*$)")))
  
    # Final line in a block will not end in a {
    index <- grep(lines, pattern="[{]$", invert=TRUE)
    ret <- list()
    first <- 1
    for(last in index) {
      ret <- c(ret, list(lines[first:last]))
      first <- last + 1
    }
    ret
  })
  
  


  e <- new.env(parent=.GlobalEnv)
  
  # A primitive read-eval-print loop
  tryCatch(error=print,
    for(block in blocks) {
      cat(paste0('--', block, '\n'), sep="")
      eval(parse(text=block), e)
    }  
  )
}

