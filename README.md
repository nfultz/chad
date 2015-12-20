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

It usually looks best if you start the file with code tag, to render the rest of the document as code:

  ># Example Notebook <pre><code>

You can use the `chadPlot()` to inline images:

    >png(); barplot(1:10); chadPlot()
    
<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAeAAAAHgCAMAAABKCk6nAAACK1BMVEUAAAABAQECAgIDAwMFBQUGBgYHBwcJCQkKCgoLCwsMDAwNDQ0ODg4PDw8RERETExMWFhYXFxcZGRkaGhobGxseHh4fHx8iIiIkJCQlJSUnJycoKCgpKSkqKiorKyssLCwtLS0uLi4vLy8wMDAxMTEyMjIzMzM1NTU3Nzc4ODg5OTk7Ozs+Pj4/Pz9AQEBBQUFERERGRkZISEhJSUlKSkpLS0tMTExNTU1OTk5PT09QUFBSUlJTU1NVVVVWVlZXV1dcXFxfX19gYGBhYWFiYmJjY2NkZGRlZWVnZ2doaGhra2tsbGxubm5vb29wcHBxcXFycnJzc3N0dHR2dnZ3d3d6enp8fHx9fX1/f3+AgICBgYGFhYWGhoaHh4eIiIiJiYmKioqLi4uMjIyNjY2Ojo6Pj4+Tk5OUlJSVlZWWlpaXl5eZmZmampqcnJydnZ2enp6fn5+kpKSoqKipqamqqqqrq6usrKytra2urq6vr6+wsLCxsbGysrKzs7O0tLS1tbW3t7e6urq7u7u8vLy9vb2+vr7AwMDBwcHDw8PFxcXGxsbHx8fJycnKysrLy8vMzMzOzs7Q0NDR0dHU1NTV1dXW1tbX19fY2Nja2trb29vc3Nzd3d3e3t7f39/h4eHi4uLj4+Pk5OTl5eXm5ubo6Ojp6enq6urr6+vs7Ozu7u7v7+/w8PDx8fHy8vL19fX29vb39/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7///9mt850AAAJgUlEQVR4nO3d63dU1R3G8Wi0WpWi1SqXqmgQpSUhWhRFQ6tGEdRShVqUGhJvVSPiBSqKKBjxhgYvxWopFYMlQUFME5Lz57X7zPqlZsLe2SeemTnn8ft9way1z8PMyXwWQ8IbmhKSrqnRN0C1DWDxABYPYPEAFg9g8QAWD2DxABYPYPEAFg9g8QAWD2DxABYPYPEAFg9g8QAWD2DxABYPYPEAFg9g8QAWD2DxABYPYPEAFg9g8QAWD2DxABYPYPEAFg9g8QAWD2DxABYPYPEAFg9g8QAWD2DxABYPYPEAFg9g8QAWD2DxABYvCnj82Fit74Nq1PTA326ce2ZT85wHh+twN5R70wPf2v7W0MjQO8s763A3lHvTA88aSB+Oz671rVAtmh64ZXP6sHVhrW+FatH0wP0Xz+/oXHnZhfvqcDeUexHfRY/2be7q7Rv9/8FnW9Oe/bB2t/Xj7v2twT7K8lwz+Tn4o960VQ/N4PdSREvX/iHQ6pVZnusH/EPHi0/O/PdSqKVv7gm0PWfgT63qCwDXqvoC/6bp7IvSqi8AXKvqC5zcuebU5wDXqjoD9/Wc+hzgWlVnYF8A1yqAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA7i8bbp0UajWdARweVv/ZMhuT1s6Ari8ASwewOIBLB7A4gEsHsDiASwewOIBLB7A4gEsHsDiASwewOIBLB7A4gEsHsDiASwewOIBLB7A4gEsHsDiASwewOIBLB7A4hUV+Juvp54BPIMKCLx/6S1DN/ykeelA9QWAZ1ABgZesuX/2uuETd99UfQHgGVRA4LO+On7aiSQZPG/i5O31aSseyPjFiXdgfbANI25UQOBf9O1t2psku385cXJkX9rDj2T6+uXbtqIn1BVH3KiAwE+dcd5TP7/jtlnbqy/wET25bfcE7VqLCpx8fjj5tPvhv005B3hypQX2BfDkABYPYPEAFg9g8QAWD2DxABYPYPEAFg9g8QAWD2DxABYPYPEAFg9g8QAWD2DxABYPYPEAFg9g8QAWD2DxABYPYPEAFg9g8QAWD+AS98WBUAfH3Abg8vblBa2hLtnlRgCXt39dG2S56zU3Ari8ASwewOIBLB7A4gEsHsDiASwewOIBLB7A4gEsHsDiASwewOIBLB7A4gEsHsDiASwewOIBLB7A4gEsHsDiASwewOIBLB7A4ukDH/l66hnAGsB/b/v4i8XNZ7Qdqr4AsAbwNWuHb17z3fDvr6++ALAG8DlfJXM+S5LBcydOXmpPW3BflhcqbLe3B3vZbaSBr3t0fNXTSfL8VRMno0fTtmj8CV6wI9TGDW4jDTxw1fwbT29rveD96gsiH9EtwXf8sQ1uIw2cjH/wXPdfdg5POQfYKjmwL4AtgIscwL4AtgAucgD7AtgCuMgB7AtgC+AiB7AvgC2AixzAvgC2AC5yAPsC2AK4yAHsC2AL4CIHsC+ALYCLHMC+ALYALnIA+wLYArjIAewLYAvgIgewL4AtgIscwL4AtgAucgD7AtgCuMgB7Kv4wPvfCLY/HQHsq/jAy29bFahzWToC2FcJgF8LvVG7AA4HsAVwgwIYYID9AWwB3KAABhhgfwBbADcogAEG2B/AFsANCmCAAfYHsAVwgwIYYID9AWwB3KAABhhgfwBbADcogAEG2B/AFsANCmCAAfYHsAVwgwIYYID9AWwB3KAAjgfeW8b/XhbgeODZh6YcAWyVG/inza6m05urLwBslRt4/686DgwO/uzjwYmTv7anLVib5YVy7pnLF4VqSUcAR31En3x83uuF+4h+6NHgGwWwFfV38D/afncuwP5KD5yM9f52aMohwFb5gU8ZwBbA+QdwZAAD7AtgC+D8AzgygAH2BbAFcP4BHBnAAPsC2AI4/wCODGCAfQFsAZx/AEcGMMC+ALYAzj+AIwMYYF8AWwDnH8CRAQywL4AtgPMP4MgABtgXwBbA+QdwZAAD7AtgC+D8AzgygAH2VSvgw13Buk+4EcCRFRB417KeUFf/040AjqyIwKuC78F1AGd5NwEG2BfAFsCZAhhggKMDGGBfAFsAZwpggAGODmCAfQFsAZwpgAEGODqAAfYFsAVwpgAGGODoAAbYF8AWwJkCGGCAowMYYF8AWwBnCmCAAY4OYIB9AWwBnCmAAQY4OoABTo6O/++Xk4PVxwBb5Qb+5NLTLtmZJAenLAG2yg386z/95+2L+r8PPHI0bcsTWV6o0rGjwcbcBuD6Ap99LEleWXTye8A7OtIW35flhdK+Ob811NztbgRwfYGv3JYk4yv+mMtH9NCS4Jd374tuBHB9gXefs/jfyeDCFoC9lRs4OfzC8SQZfmFd9TnAVsmBfQFsAWwBDDDAALsRwJEBDLAvgC2ALYABBhhgNwI4MoAB9gWwBbAFMMAAA+xGAEcGMMC+ALYAtgAGGGCA3QjgyAAG2BfAFsAWwAADDLAbARwZwAD7AtgC2AIYYIABdiOAIwMYYF9VwOs6gm1zG4BLDLxkR6jH7ncbgEsM3Ba886cBBhhggPcADLALYAtggH0BbAEMMMAugAEGGGAXwBbAAPsC2AIYYIBdAAMMMMAugC2AAfYFsAUwwAC7AAYYYIBdAFsAA+wLYAtggAF2AQwwwAC7ALYABtgXwFbpgcePjQEcqNzA326ce2ZT85wHhwH2VW7gW9vfGhoZemd558TJl2+kPdA9abe4J9S9FeAFwdHNFeBlwdHVFeDVwdG8CvDG0ObPFeB5wSdaXQFeFBzdUAFeERxdUQG+Jzi6pgIc3GzIGXjWQPpwfPbEyd6utHWvTto91xXsXbcZ7QmPUruB8GbTCTfqD49601vaGR7tSEfPhEf9bvPdpvDokBsdDG+6R9zovfBoS3pLL4VHu/IFbtmcPmxdmOVpqShND9x/8fyOzpWXXbivDndDuRfxXfRo3+au3r7R2t8L1aAf8HMwlSGAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWDyAxQNYPIDFA1g8gMUDWLz/AiTmc/mNgyqxAAAAAElFTkSuQmCC"/>




###Dedicated to Chad Whipkey.


