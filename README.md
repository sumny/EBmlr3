# Explainable Boosting Machine as mlr3 Learner

```r
reticulate::install_python(version = "3.8.0")
reticulate::virtualenv_create("EBmlr3", version = "3.8.0")
```

```
# source install for development
git clone https://github.com/interpretml/interpret.git
source .virtualenvs/EBmlr3/bin/activate.fish
cd interpret/scripts
make install
cd ../python/interpret-core
pip install -e .[required,debug,notebook,plotly,lime,sensitivity,shap,ebm,linear,decisiontree,treeinterpreter,dash,skoperules,testing]
```

```r
# install via pip in condaenv
reticulate::install_miniconda()
# Execute and restart R afterwards
reticulate::conda_create(envname = "EBmlr3", packages = "python=3.8")
reticulate::conda_install(envname = "EBmlr3", packages = "interpret", pip = TRUE)
```

```r
# reticulate::use_condaenv("EBmlr3")
# reticulate::use_virtualenv("EBmlr3")
library(mlr3)
library(EBmlr3)
task = tsk("spam")
learner = lrn("classif.ebm")
learner$train(task)
learner$predict(task)
```

