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
    # the regex below should match lines that begin with > or +
    # and extract the command without trailing space
    lines <- readLines(IN, warn=FALSE)
    lines <- grep("^[>+]", lines, value=TRUE)
    lines <- sub("\\s*$", "", lines)

    index <- cumsum(grepl(lines, pattern="^>"))
  
    blocks <- split(lines, index)

    # drop prompt and parse
    f <- function(x) parse(text=sub("^[>+]", "", x) )
    lapply(blocks, function(x) list(txt=x, expr=f(x)))


  })
  

  e <- new.env(parent=.GlobalEnv)
  
  # A primitive read-eval-print loop
  tryCatch(error=print,
    for(b in blocks) {
      cat(b$txt, sep="\n")
      if(!length(b$expr)) next;
      result <- withVisible(eval(b$expr, e))
      with(result, 
        if(visible) (if(isS4(value)) methods::show else print)(value)
      )
    }  
  )

  invisible()

}

