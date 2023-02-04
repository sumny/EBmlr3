# Explainable Boosting Machine as mlr3 Learner

```r
# install via pip in condaenv
reticulate::install_miniconda()
# Execute and restart R afterwards
reticulate::conda_create(envname = "EBmlr3", packages = "python=3.8")
reticulate::conda_install(envname = "EBmlr3", packages = "interpret==0.2.7", pip = TRUE)
```

```r
reticulate::use_condaenv("EBmlr3")
library(mlr3)
library(EBmlr3)
task = tsk("spam")
learner = lrn("classif.ebm")
learner$train(task)
learner$predict(task)
```

