#' @title Explainable Boosting Machine Regression Learner
#'
#' @name mlr_learners_regr.ebm
#'
#' @description
#' Explainable boosting machine.
#' Uses `ExplainableBoostingRegression` from `interpret` module.
#'
#' `n_jobs` is set to 1 instead of 2. `random_state` is set to `42` (like in `interpret`).
#'
#' @templateVar id regr.ebm
#' @template learner
#'
#' @references
#' `r format_bib("nori2019", "lou2013")`
#'
#' @export
#' @template seealso_learner
#' @template example
LearnerRegrEBM = R6Class("LearnerRegrEBM",
  inherit = LearnerRegr,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {
      reticulate::py_run_string("from interpret.glassbox import ExplainableBoostingRegressor")
      ps = ps(
        max_bins                     = p_int(lower = 1L, default = 256L, tags = "train"),
        max_interaction_bins         = p_int(lower = 1L, default = 32L, tags = "train"),
        binning                      = p_fct(levels = c("uniform", "quantile", "quantile_humanized"), default = "quantile", tags = "train"),
        mains                        = p_uty(default = "all", tags = "train"),
        interactions                 = p_uty(default = 10L, tags = "train"),
        outer_bags                   = p_int(lower = 1L, default = 8L, tags = "train"),
        inner_bags                   = p_int(lower = 0L, default = 0L, tags = "train"),
        learning_rate                = p_dbl(lower = 0L, default = 0.01, tags = "train"),
        validation_size              = p_dbl(lower = 0L, upper = 1L, default = 0.15, tags = "train"),
        early_stopping_rounds        = p_int(lower = 1L, default = 50L, tags = "train"),
        early_stopping_tolerance     = p_dbl(lower = 0, default = 0.0001, tags = "train"),
        max_rounds                   = p_int(lower = 1L, default = 5000L, tags = "train"),
        min_samples_leaf             = p_int(lower = 1L, default = 2L, tags = "train"),
        max_leaves                   = p_int(lower = 1L, default = 3L, tags = "train"),
        n_jobs                       = p_int(lower = 1L, default = 1L, tags = c("train", "threads")),
        random_state                 = p_int(default = 42L, special_vals = list(NULL), tags = c("train", "predict"))
      )

      ps$values = ps$default

      super$initialize(
        id = "regr.ebm",
        param_set = ps,
        predict_types = "response",
        feature_types = c("integer", "numeric", "character", "factor", "ordered"),
        properties = "weights",  # FIXME: importance
        packages = "EBmlr3",
        man = "EBmlr3::mlr_learners_regr.ebm"
      )
    }
  ),

  private = list(
    .train = function(task) {
      pv = self$param_set$get_values(tags = "train")

      feature_types = map_chr(task$feature_types$type, function(type) {
        switch(type, "integer" = "categorical", "numeric" = "continuous", "character" = "categorical", "factor" = "categorical", "ordered" = "categorical")
      })
      sample_weight = task$weights$weight
      if (is.null(sample_weight)) {
        sample_weight = data.table(sample_weight = rep(1, task$nrow))
      }

      model = reticulate::py$ExplainableBoostingRegressor(feature_names = task$feature_names, feature_types = feature_types,
        max_bins = pv$max_bins, max_interaction_bins = pv$max_interaction_bins, binning = pv$binning, mains = pv$mains, interactions = pv$interactions,
        outer_bags = pv$outer_bags, inner_bags = pv$inner_bags, learning_rate = pv$learning_rate, validation_size = pv$validation_size, early_stopping_rounds = pv$early_stopping_rounds,
        early_stopping_tolerance = pv$early_stopping_tolerance, max_rounds = pv$max_rounds, min_samples_leaf = pv$min_samples_leaf, max_leaves = pv$max_leaves, n_jobs = pv$n_jobs, random_state = pv$random_state)
      model$fit(X = task$data(cols = task$feature_names), y = task$data(cols = task$target_names), sample_weight = as.matrix(sample_weight))
      model
    },

    .predict = function(task) {
      pv = self$param_set$get_values(tags = "predict")
      cols = names(self$state$data_prototype)
      newdata = task$data(cols = intersect(cols, task$feature_names))
      prediction = self$model$predict(X = newdata)
      list(response = prediction)
    }
  )
)
