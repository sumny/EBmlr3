test_that("autotest", {
  learner = mlr3::lrn("classif.ebm", interactions = 0L, max_rounds = 1000L)
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("interactions", {
  learner = mlr3::lrn("classif.ebm", interactions = 1L, max_rounds = 1000L)
  learner$predict_type = "prob"
  task = tsk("iris")
  learner$train(task)
  expect_true(length(learner$model$feature_names) == length(task$feature_names))  # multi-class no support
  expect_true(learner$predict(task)$score(msr("classif.mauc_aunu")) > 0.5)

  task = tsk("german_credit")
  learner$train(task)
  expect_true(length(learner$model$feature_names) == length(task$feature_names) + 1L)
  expect_true(learner$predict(task)$score(msr("classif.auc")) > 0.5)
})

