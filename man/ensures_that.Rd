% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/check_that.R, R/ensure_that.R, R/ensures_that.R
\name{check_that}
\alias{check}
\alias{check_that}
\alias{ensure}
\alias{ensure_that}
\alias{ensures}
\alias{ensures_that}
\title{Ensure Certain Conditions for a Value at Runtime.}
\usage{
check_that(., ...)

check(., ...)

ensure_that(., ..., fail_with = function(e) stop(e), err_desc = "")

ensure(., ..., fail_with = function(e) stop(e), err_desc = "")

ensures_that(..., fail_with = function(e) stop(e), err_desc = "")

ensures(..., fail_with = function(e) stop(e), err_desc = "")
}
\arguments{
\item{.}{The value which is to be ensured.}

\item{...}{conditions which must pass for the ensuring contract to be
  fulfilled. Any named argument will treated as values available when
  evaluating the conditions. To reference the value itself use the
  dot-placeholder, \code{`.`}. See 'Details' for some special named
  arguments.}

\item{fail_with}{Either a unary function (accepting a \code{simpleError})
  or a static value.}

\item{err_desc}{A character string with an additional error description.}
}
\value{
\code{ensures_that} returns an ensuring function; \code{ensure_that}
  returns the value itself on success. \code{check_that} returns \code{TRUE}
  on success, and \code{FALSE} otherwise.
}
\description{
Use \code{ensure_that} (imperitive form) to ensure conditions for a value "on
the fly". The present tense form, \code{ensures_that} is used to make
reusable "contracts" (functions) which can subsequently be applied to values;
see examples below. It is also possible to check (rather than ensure) whether
conditions are satisfied; the \code{check_that} function works like
\code{ensure_that} but will return \code{TRUE} or \code{FALSE}.
}
\details{
It is possible to specify custom error message for specific
conditions to make them more readable and user-friendly. To do this use a
formula \code{condition ~ err.message}, where \code{err.message} is a single
character value.

Existing contracts can be added as a condition argument, which will add the
conditions from the existing contract to the new contract (along with any
assigned values). To do this use (unary) \code{+} to indicate that an
argument is a contract. See example below.

It is important to note that a condition is only satisfied if it evaluates to
\code{TRUE} (tested with \code{isTRUE}), i.e. a vector with several
\code{TRUE}s will fail, so be sure to use \code{all} or \code{any} in such a
case.

The functions \code{ensure} \code{ensures}, and \code{check} are short-hand
aliases for their \code{*_that} counterparts.
}
\examples{
\dontrun{

ensure_that(1:10, is.integer)

# Examples below will use the magrittr pipe
library(magrittr)

# Create a contract which can ensure that a matrix is square.
ensure_square <- ensures_that(NCOL(.) == NROW(.))

# apply it.
A <-
  diag(4) \%>\%
  ensure_square

# Without the pipe operator:
A <- ensure_square(diag(4))

# Ensure on the fly (this will pass the test)
A <-
  matrix(runif(16), 4, 4) \%>\%
  ensure_that(ncol(.) == nrow(.), all(. <= 1))

# This will raise an error
A <-
  matrix(NA, 4, 4) \%>\%
  ensure_that(. \%>\% anyNA \%>\% not)

# Tweak failure:
A <-
  1:10 \%>\%
  ensure_that(all(. < 5), err_desc = "Number tests!")

# A default value for failure situations:
A <-
  1:10 \%>\%
  ensure_that(all(. < 5), fail_with = NA)

# Suppose you had an email function:
email_err <- function(e) {email(e$message); stop(e)}

A <-
  1:10 \%>\%
  ensure_that(all(. < 5), fail_with = email_err)

# Two similar contracts, one extending the other.
# Note also that custom message is used for A
A <- ensures_that(all(.) > 0 ~ "Not all values are positive")
B <- ensures_that(!any(is.na(.)) ~ "There are missing values", +A)

B(c(-5:5, NA))
}
}

