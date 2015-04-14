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
    lines <- grep("^[>+]", lines, value=TRUE)

    index <- cumsum(grepl(lines, pattern="^>"))
    lines <- na.omit(str_extract(lines, perl("(?<=^[>+]).*?(?=\\s*$)")))
  
    # Final line in a block will not end in a {
    split(lines, index)
  })
  
  


  e <- new.env(parent=.GlobalEnv)
  prefix <- `[<-`(rep("+", 100), 1, ">")
  
  # A primitive read-eval-print loop
  tryCatch(error=print,
    for(block in blocks) {
      cat(paste0(head(prefix, length(block)), block), sep="\n")
      eval(parse(text=block), e)
    }  
  )
}

