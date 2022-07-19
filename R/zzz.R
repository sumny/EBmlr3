#' @import data.table
#' @import paradox
#' @import mlr3misc
#' @import checkmate
#' @importFrom R6 R6Class
#' @importFrom mlr3 mlr_learners LearnerClassif LearnerRegr
"_PACKAGE"

register_mlr3 = function() {
  x = utils::getFromNamespace("mlr_learners", ns = "mlr3")

  # classification learners
  x$add("classif.ebm", LearnerClassifEBM)

  # regression learners
  x$add("regr.ebm", LearnerRegrEBM)
}

.onLoad = function(libname, pkgname) { # nolint
  register_namespace_callback(pkgname, "mlr3", register_mlr3)
  reticulate::use_condaenv("EBmlr3")
  reticulate::py_run_string("from interpret.glassbox import ExplainableBoostingClassifier")
  reticulate::py_run_string("from interpret.glassbox import ExplainableBoostingRegressor")
} # nocov end

leanify_package()
