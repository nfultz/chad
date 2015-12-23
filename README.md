# chad - A lightweight acceptance test framework

This provides a way to run acceptance tests for/from R, along with some scripting glue for updating them.

*Goal*: Never waste time writing `assert()`s again.

Unit tests are great for developers, but a time sink for data scientists.

## How it works

The `chad` function tests itself for idempotency:

    f(f(x)) = f(x)
    
where f is chad and x is your R code. By substitution, we also have

    f(u) = u 
    
where `u` is a chad script: a combination of code and output. 

Any chad script where that does not hold is automatically 
considered a test failure.

Side note: When `f` is a computer and `u` a program and the above holds, `u` is a *quine*. 
See _Godel, Escher, Bach_ for a deep dive on quines.
 
## Requirements

In addition to R, this package needs a `diff` program on the search path. On Windows, you may need to install Rtools.
For a nicer experience, you can use `git` and `colordiff` instead.
 

## Example

Chad scripts are basically R output from the console. Here is `anova.chad`:

    > anova(lm(extra~., sleep))
    Analysis of Variance Table
    
    Response: extra
              Df Sum Sq    Mean Sq  F value    Pr(>F)   
    group      1 10.482 12.4820000 16.50088 0.0028329 **
    ID         9 58.078  6.4531111  8.53085 0.0019014 **
    Residuals  9  6.808  0.7564444                      
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

When we run it with `chad('anova.chad')`, ir reruns the code and generates any output. If any of
it had changed, it would display it in standard diff notation:

    > chad('inst/tests/chad/sleep.chad')
    Chadding	sleep.chad	...	
    --- sleep.chad	2015-12-22 16:08:50.886015712 -0800
    +++ sleep.chad.out	2015-12-22 16:09:13.942504368 -0800
    @@ -6,7 +6,7 @@
     
     Response: extra
               Df Sum Sq    Mean Sq  F value    Pr(>F)   
    -group      1 10.482 12.4820000 16.50088 0.0028329 **
    +group      1 12.482 12.4820000 16.50088 0.0028329 **
     ID         9 58.078  6.4531111  8.53085 0.0019014 **
     Residuals  9  6.808  0.7564444                      
     ---
    
The + and minus signs indicated the lines that have changed. Here, a 10.482 has
changed to a 12.482. If this was an expected change (perhaps the data set was updated or
a bug was fixed), we could update the test at the AAG prompt:

    Difference in output; accept as golden? [y/n/git]

Choosing y will update the test to the newer output. The git option will 
additionally commit the change. Because chad scripts are 
human readable text, they play nicely with VCSs.

Additionally, you can chad an entire directory with `chadRecur()`:
    
    > chadRecur('.')
    Chadding  error.chad	...	FAIL
    Chadding	example.chad	...	SUCCESS
              file status  time
    1   error.chad      1 0.017
    2 example.chad      0 0.026

Following UNIX tradition status 0 is a pass, anything else is a failure.
    
## Package Development

To use chad scripts for package testing, run

    useChad()
    
from the package root. A test stub and example test will be copied to the 'tests/' folder.    


## Chad Notebooks

Valid chad scripts are by definition reproducible research and are easy to share. 

By setting the MIME type of `.chad` files to `text/html` , we can have a web browser render any html content a chad script contains.

It looks better if you start the file with a code tag to style the rest of the document and break lines correctly:

    ># Example Notebook <pre><code>

You can use the `chadPlot()` to inline images:

    >png(); barplot(1:10); chadPlot()
    <img src="data:image/png;base64,iVBORw0KGgoAAAAN...uQmCC"/>


## Differences from R CMD check

R has related testing mechanism based around `R CMD check` output. 

  * check requires two files: .R (code) and  .Rout.save (output); they can easily get out of sync while developing.
  * Each check test runs in it's own Rsession. This is 'safer' but slower, and no setup/teardown can be shared between tests.
  * check has to hack around the MOTD headers R emits when it is started.
  * check runs R, chad runs inside R
  * check is part of base,  chad is an add-on package.
  

###Dedicated to Chad Whipkey.


