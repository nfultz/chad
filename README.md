# chad - A lightweight acceptance test framework

This provides a way to run acceptance tests for/from R, along with some scripting glue for updating them.

*Goal*: Never waste time writing `assert()`s again.

Unit tests are great for developers, but a time sink for data scientists.

## How it works

The `chad` function tests itself for idempotency:

    f(f(x)) = f(x)
    
By substitution, we also have

    f(u) = u 
    
where `u` is the chad script: a combination of code and output. 

Any test where that does not hold is automatically 
considered a failure.

Side note: When `f` is a computer and `u` a program and the above holds, `u` is a *quine*. 
See _Godel, Escher, Bach_ for a deep dive on quines.
 
## Requirements

In addition to R, this package needs a `diff` program on the search path. On Windows, you may need to install Rtools.
For a nicer experience, you could use `git` and `colordiff` instead.
 

## Example

Chad scripts are basically R output from the console. Here is `error.chad`:

    > #Error testing
    > f <- function(x) stopifnot("yo mama" == x)
    > g <- function(x) f(x)
    > h <- function() g(22)
    > h()

When we run it with `chad()`, `h` throws an error. The chad output looks like this:

    > chad("tests/chad/error.chad")
    Chadding	error.chad	...	
    --- error.chad	2015-11-01 10:21:41.111617856 -0800
    +++ error.chad.out	2015-12-20 11:41:47.237606610 -0800
    @@ -3,3 +3,4 @@
     > g <- function(x) f(x)
     > h <- function() g(22)
     > h()
    +<simpleError: "yo mama" == x is not TRUE>

If this was an expected change, we could update the test at the AAG prompt:

    Difference in output; accept as golden? [y/n/git]n


Additionally, you can run an entire directory with `chadRecur()`:
    
    > chadRecur('.')
    Chadding  error.chad	...	SUCCESS
    Chadding	example.chad	...	FAIL
              file status  time
    1   error.chad      0 0.017
    2 example.chad      1 0.026
    
## Package Development

To use chad scripts for package testing, run

    useChad()
    
from the package root. A test stub and example test will be placed in the 'tests/' folder.    

## Chad Notebooks

By setting the MIME type of `.chad` files to `text/html` , we can have a web browser render any html content a chad script contains.

It usually looks best if you start the file with a code tag to style the rest of the document and break lines correctly:

    ># Example Notebook <pre><code>;

You can use the `chadPlot()` to inline images:

    >png(); barplot(1:10); chadPlot()
    <img src="data:image/png;base64,iVBORw0KGgoAAAAN...uQmCC"/>




###Dedicated to Chad Whipkey.


