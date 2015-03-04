# chad - A lightweight acceptance test framework

This provides a way to run acceptance tests for/from R, along with some scripting glue for updating them.
 
##Requirements:
In addition to R, this package needs a `diff` program on the search path. Optionally, it can also use `git` and `colordiff` for a nicer experience.
 
Dedicated to Chad Whipkey.

##Example

`chad()` can run a single test:

    > chad("error.chad")
    Chadding  error.chad	...	
    --- error.chad	2015-03-03 23:19:09.000000000 +0000
    +++ error.chad.out	2015-03-03 23:21:16.000000000 +0000
    @@ -3,3 +3,4 @@
     -- g <- function(x) f(x)
     -- h <- function() g(22)
     -- h()
    +<simpleError: "yo mama" == x is not TRUE>

Additionally, you can run an entire directory with `chadRecur()`:
    
    > chadRecur('.')
    Chadding  error.chad	...	SUCCESS
    Chadding	example.chad	...	FAIL
              file status  time
    1   error.chad      0 0.017
    2 example.chad      1 0.026