% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/SPCA_BE.R
\name{spcabe}
\alias{spcabe}
\title{SPCA by Backward Elimination algorithm}
\usage{
spcabe(S, nd = FALSE, ndbyvexp = FALSE, mincard = NULL, thresh = FALSE,
  threshvar = FALSE, threshvaronPC = FALSE, perc = TRUE, unc = TRUE,
  trim = 1, reducetrim = TRUE, startind = NULL, excludeload = FALSE,
  diag = FALSE, choosecard = NULL, eps = 1e-04, msg = TRUE)
}
\arguments{
\item{S}{A correlation or covariance matrix.}

\item{nd}{Integer. Number of dimensions to compute. If FALSE and ndbyvexp <
1 the number of components is determined by the latter value. If FALSE and
ndbyvexp = 1 or = FALSE the program will give an error.}

\item{ndbyvexp}{Real in [0,1] or FALSE. Minimum percentage of total variance
explained by the components computed. If reached before the specified nd, it
takes priority.}

\item{mincard}{Vector of minimal cardinality of each components. If FALSE
and unc[j] = TRUE, the j-th value is set to j, otherwise all values are set
to 1. Takes priority on other controls on trimming.}

\item{thresh}{Vector of values below which loadings are trimmed. Can be
shorter than nd. See details.}

\item{threshvar}{Vector of minimal percentage of variance loss from the full
initial solution allowed for each component. If reached current trimming is
cancelled and solution returned. If FALSE it is set to 1.}

\item{threshvaronPC}{Vector of minimal total percentage of variance loss
from the total variance explained by the PCs allowed to trimming. If reached
current trimming is cancelled and solution returned. If FALSE it is set to
1. It takes priority over threshvar[j], if both specified.}

\item{perc}{Logical: does the threshold refers to the percentage
contributions (the loadings scaled to unitary L1 norm)?}

\item{unc}{Logical vector. If TRUE the corresponding component is computed
uncorrelated, otherwise correlated. Can be shorter than nd. See details.}

\item{trim}{Number of loadings to trim at each iteration. mincard[j] takes
priority if conflicting.}

\item{reducetrim}{Logical. If TRUE and trim > 1 when are left less than trim
+ mincard[j] loadings, trim is reduced to 1 for these last loadings.}

\item{startind}{List of vectors with the initial set of indices for each
component. If NULL, the full set of indices (1:ncol(S)) is assigned to each
component}

\item{excludeload}{Logical: vector (length nd or shorter) should the indices
of non-zero loadings in previous components be excluded from future
searches?}

\item{diag}{Logical: should diagnostic output be returned?.}

\item{choosecard}{NULL or Integer. Setting the value to an integer makes the
function return a full trace of the elimination for that component.  It is
used by the choosecard function.}

\item{eps}{Value below which the absolute value of a loading is considered
zero.}

\item{msg}{Logical: should messages be printed after each component is
computed}
}
\value{
spcabe returns an object of class \emph{spca}. On top of the basic
elements of spca objects, it contains other ones useful for diagnostics and
analysis. Some elements are present only if some of the arguments are
activated. The object contains the following components:
\item{loadings}{Matrix with the loadings scaled to unit \eqn{L_2} norm in
the columns.} If \code{perc = TRUE} \item{contributions}{Matrix of loadings
scaled to unit \eqn{L_1} norm.} \item{vexp}{Vector with the \% variance
explained by each component.} \item{vexpPC}{Vector with the \% variance
explained by each principal component.} \item{cardinality}{Vector with the
cardinalities of each loadings.} \item{ind}{List with the indices of the
non-zero loadings for each component.} \item{unc}{the argument unc passed.}
\item{converged}{Vector with the stop for trimming: 0 by \emph{thresh}, 1 by
\emph{mincard}, 2 by \emph{threshvar} or \emph{threshvaronPC}. The value 3
means that uncorrelatedness could not be achieved because too few indices
were available (see notes).} If any \code{unc[j] = TRUE}
\item{corComp}{Matrix of correlations among the sparse components}
\item{Aunc}{Loadings of components made uncorrelated} If \code{diag == TRUE}
a number of details are returned: \item{vexpo}{Vector with the \% variance
explained by the initial untrimmed components.} \item{totvcloss}{Vector with
the \% loss in total variance explained including each component over that
explained by the corresponding PC (vexpPC - vexp)/vexpPC.}
\item{vlossbe}{Vector with the \% loss in variance explained loss by
trimming over that explained by the initial component (vexpo).}
\item{niter}{Vector with number of iterations for each trimming round.}
\item{eliminated}{List of indices of loadings eliminated for each component}
Call arguments, possibly modified by the algorithm: \item{thresh}{Vector of
tresholds for the size of loadings} \item{threshvar}{Vector of tresholds on
loss of variance explained by each component} \item{ndbyvexp}{Required total
variance explained} \item{stopbyvar}{Logical, did the algorithm terminate
because the required total variance explained was reached?}
\item{mincard}{Minimal cardinalities required}
}
\description{
Computes LS SPCA components by iteratively trimming small loadings.
}
\details{
Sparse loadings are computed by iteratively trimming the ones smaller than
thresh[j] for each component. If \emph{ndbyvexp} < 1, the algorithm will
stop when that percentage of total Vexp is reached with the last component
computed.\cr

Arguments \emph{threshvar}, \emph{threshvaronPC}, \emph{thresh},
\emph{excludeload} and \emph{unc} can be entered with fewer elements than
the number of components to compute, \emph{nd}. In this case, or if
\emph{nd} is determined by the variance explained, the missing elements are
set equal to the last one entered (also if just one value is given). The
same is true for \emph{mincard} but for the components required to be
uncorrelated their values are set equal to the order of the component.

\emph{startind} can be set for the first few components, the following will
be computed on the whole set of variables.

Trimming stops if mincard[j] is reached. Trimming is controlled in two more
optional ways: if the last trimming caused a loss of variance explained from
the initial solution greater than \emph{threshvar} or the loss of proportion
of total variance explained over the corresponding PCA value drops below the
specified percentage \emph{threshvaronPC}. The rules can be used together,
setting the values to FALSE or 1 to avoid them.

When \emph{excludeload} = TRUE or \emph{startindex} is set, the cardinality
of the starting indices could be less than the order of the component to
compute. In this case uncorrelatedness cannot be achieved and the component
will be computed as correlated. The flag \emph{converged} will be set to 3
and a warning message printed.

If vector arguments of length less than the number of components to compute
are passed (hence also if a single one is passed), the last element is
assigned to the missing ones.
}
\examples{
\dontrun{
  "Note the warnings and messages produced by the examples"
  data(anthrop, package = "spca")

  # 3 basic spcabe components with default values,
  # since uncorrelated component these have card = 1, 2, and 3
  myspca1 <- spcabe(anthrop, nd = 3)
  myspca1
  summary(myspca1)
  ## plot the results
  plot(myspca1, plotload = TRUE, onlynonzero = FALSE, mfrowload = 3, variablesnames = TRUE)

  ## spcabe with 3 components trimmed to different thresholds and mincard
  myspca2 <- spcabe(anthrop, nd = 3, thresh = c(0.3, 0.25, 0.15), mincard = c(2,3,3))
  summary(myspca2)
  myspca2
  # show the first two loadings as percentage contributions
  showload(myspca2, cols = 1:2, perc = TRUE)

  ## spcabe requirig explaining at least 75\% of total variance and that each component
  ## explains at least 95\% of variance explained by the pcs (see details)
  myspca3 <- spcabe( anthrop, ndbyvexp = 0.75, threshvaronPC = 0.95)
  summary(myspca3)
  myspca3
  # compare the three solutions
  compare(smpc = myspca1, compareto = list( myspca2, myspca3),
  methodsnames = c("myspca1", "myspca2", "myspca3"))
 }
}
\seealso{
\code{\link{spcabb}, \link{summary.spca}, \link{compare.spca}}.
}
\keyword{Backward}
\keyword{Elimination}

