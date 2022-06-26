test_that("regr.ebm", {
  learner = mlr3::lrn("regr.ebm", interactions = 0L, max_rounds = 5L)
  expect_learner(learner)
  task = mlr3::tsk("boston_housing")
  learner$train(task)
  learner$predict(task)
})
