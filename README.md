# Explainable Boosting Machine as mlr3 Learner

```r
reticulate::install_miniconda()
# Execute and restart R afterwards
reticulate::conda_create(envname = "EBmlr3", packages = "python=3.8")
reticulate::conda_install(envname = "EBmlr3", packages = "interpret", pip = TRUE)
reticulate::use_condaenv("EBmlr3")
```

```r
library(mlr3)
library(EBmlr3)
task = tsk("spam")
learner = lrn("classif.ebm")
learner$train(task)
learner$predict(task)
```

