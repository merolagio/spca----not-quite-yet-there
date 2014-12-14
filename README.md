---
title: "spca package"
author: "Giovanni Merola<br>
RMIT International University Vietnam<br>
email: lsspca@gmail.com<br>
bug reports: https://github.com/merolagio/spca----pre-release/issues/new"
output:
  rmarkdown::html_document:
    toc: true
    theme: united
    highlight: haddock
---

### Intro  
`spca` is an R package for running Sparse Principal Component Analysis. It implements the LS SPCA approach that computes the Least Squares estimates of sparse PCs ([Merola, 2014. arXiv](http://arxiv.org/abs/1406.1381 "Pre-print")). Unlike other SPCA methods, these solutions maximise the variance of the data explained. 


I had difficulties publishing the LS SPCA paper, possibly because LS SPCA improves on existing methods. This is confirmed by the fact that Technometrics' chief editor, Dr Qiu, rejected the paper endorsing a report stating that: **the LS criterion is a new measure used ad-hoc  :-D** This on top of a number of blatantly wrong arguments. This is possible, I believe, because of the widespread ignorance about PCA. Beside, the reports ignored 200 years of usage of LS.  

### Sparse Principal Component Analysis
Principal Component Analysis is used for analysing a multivariate dataset with two or three uncorrelated components that explain the most variance of the data. 

In some situations more than three components are used. But this simply reduces a problem into a lower dimensional one, which is still difficult to analyse.

SPCA aims to obtain interpretable components.  In factor Analayis literature there is plenty of discussion about the  definition of interpretable and simple solutions (as qualities and in mathematical terms).

* **Simplicity** can be defined by different measures, being linked to **sparsness**, **variance explained** and **size of the loadings**. 

* **interpretability** is, instead, also linked to **which variables are included** in the solution  and is not measurable.
    * it usually requires **expert knowledge**.

For these reasons, usually there exist different competing solutions and it is necessary to choose the *best* ones among these. You can think of this as a sort of model selection in regression analysis.

### Optimisation Models  
Finding the optimal indices for an *spca* solution is an intractable NP-hard problem.  

Therefore, we find the solutions through two greedy algorthms: Branch-and-Bound (**BB**) and Backward Elimination (**BE**).

* **BB** searches for the solutions that sequentially maximise the variance explained under the constraints. The solutions may not be a global maximum when more than one component is computed. The BB algorithm is a modification of Farcomeni's (2010) (thanks!).

* **BE** has the goal of attaining larger contributions while minimising the LS criteria. It sequentially eliminates the smallest contributions (in absolute value) from a non-sparse solution. This will generally lead to explaining less variance than the **BB** search. However, the **BE** algorithm is much faster than the **BB** one, and the solutions usually have large loadings.

The **BE** algorthm is illustrated in `vignettes("BE algorithm", package = "spca")`

### Use of the package

**SPCA aims to obtain interpretable solutions**

Interpretability is not univocally defined. Hence, for a problem there exist a number of competing solutions. In factor Analayis literature there is plenty of discussion about the  definition of *interpretable* and *simple* solution (as qualities and in mathematical terms). 

* *Simplicity* can be defined by different measures, being linked to sparsness, variance explained and size of the loadings. 

* *interpretability* is also linked to which of the variables are included in the solution  and is not measurable.
    * it usually requires expert knowledge.
    
Therefore, for a given problem there usually exist several competing *interpretable* solutions. 

`spca` **is implemented as an exploratory data analysis tool** 

The cardinality of the components can be chosen interactively after inspecting trace and plots of solutions of different cardinality.

Furthermore, the solutions can be automatically computed so as to:

* be uncorrelated with the others or not.

* have a minimal cardinality. 

* reproduce a given proportion of the variance explained by the full PCs. 

* have only contributions larger than a given threshold.

Solutions obtained under different settings can be easily compared.

`spca` can be helpful also in a confirmatory stage of the analysis, since the sparse components can be constrained to be made up of only chosen variables.

Beside this quick tour of the package, there are vignettes with examples and explanations. You can start with `vignette("Introduction to spca", package = "spca"), which is similar to this but more detailed.` Other vignettes contain an extended example and a navigable help. 

### Functions

The workhorse of the package is the function `spca`, which computes the optimal solutions for a given set of indices.

The functions `spcabb` and `spcabe` implement the **BB** and **BE** searches, rispectively.

The package contains methods for plotting, printing and comparing spca solutions.

With`help(spcabb)` and `help(spcabe)` you will find examples of using spca and the utilities. Calling `vignettes("Advanced Example", package = "spca")` you will find a more complete example and details on the methods.

### Methods

- `choosecard`: interactive method for choosing the cardinality. It plots and prints statistics for comparing solutions of different cardinality.

- `print`: shows a formatted matrix of sparse loadings or *contributions* of a solution. Contributions are loadings expressed as percentages, while the loadings are scaled to unit sum of squares.

- `showload`: prints only the non-zero sparse loadings. This is useful when the number of variables is large.

- `summary`: shows formatted summary statistics of a solution

- `plot`: plots the cumulative variance explained by the sparse solutions versus that explained by the PCs, whish is their upper bound. It can also plot the contributions in different ways.

- `compare`: plots and prints comparison of two or more *spca* objects.

### Installing the package

The latest development version from github with

```R
if (packageVersion("spca") < 0.4.0) {
  install.packages("devtools")
}
devtools::install_github("merolagio/spca")
```

###Comments
This is the first release and will surely contain some bugs, even though I tried to test it. Please do let me know if you find any or can suggest improvements. Please use the *Github* tools for submitting bugs [Bug report][https://github.com/merolagio/spca/] or contributions.

For now most of the plots are produced with the basic plotting functions. In a later release i will produce them with ggplt2 (requires learning the package better).

The code is implemented in R, so it will not work for large datasets. 
I have in mind to develop C routines at least for the matrix algebra. Anybody willing to help, please, let me know. 
