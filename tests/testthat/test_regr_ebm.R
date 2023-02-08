test_that("autotest", {
  learner = mlr3::lrn("regr.ebm", interactions = 0L, max_rounds = 1000L)
  expect_learner(learner)
  result = run_autotest(learner)
  expect_true(result, info = result$error)
})

test_that("interactions", {
  learner = mlr3::lrn("regr.ebm", interactions = 1L, max_rounds = 1000L)
  task = tsk("mtcars")
  learner$train(task)
  expect_true(length(learner$model$feature_names) == length(task$feature_names) + 1L)
})

