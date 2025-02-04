% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/power.R
\name{power.de}
\alias{power.de}
\title{Power calculation for a DE gene}
\usage{
power.de(
  nSamples.group0,
  mu.group0,
  RR,
  theta,
  sig.level,
  approach = 3,
  ssize.ratio = 1
)
}
\arguments{
\item{nSamples.group0}{Sample size for group 0}

\item{RR}{effect size of group 1 vs group 0}

\item{theta}{1/dispersion parameter of the negative binomial fit}

\item{sig.level}{Significance threshold}

\item{approach}{Choose between three different methods implemented in the package for the power calculation (1,2,3)}

\item{ssize.ratio}{Sample size ratio between group 0 and 1}

\item{mu.grou0}{Mean value of group 0}
}
\value{
Power to detect the DE gene
}
\description{
This function calculates the power to detect an DE gene (comparsion of two groups 0 and 1)
by using the function power.nb.test of the package MKmisc. The power for a gene with mean of 0
is defined as 0 (the gene will have an expression probability of 0, so the overall detection power is also 0).
}
