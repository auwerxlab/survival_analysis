Usage
=====

The analysis is based on R scripts and R notebooks.

An IPython notebook that summarizes all the analysis steps is also available. It is the easiest way to get started.

R scripts
---------

- **Location:** ``bin/`` directory.
- **When to use:**

  - For analyses that will repeat many times.

- **When not to use:**

  - For custom analyses that will repeate only once.
  - When the details of the analysis process have to be showcased.
  - When testing new methods.

- **Documentation:**

  .. toctree::
     :maxdepth: 3

     build_survival_curves

R notebooks
-----------

- **Location:** ``notebooks/`` directory.
- **When to use:**

  - For custom analyses that will repeate only once.
  - When the details of the analysis process have to be showcased.
  - When testing new methods.

- **When not to use:**

  - For analyses that will repeat many times.

- **Documentation:**

  - `notebooks/build_survival_curves.Rmd <https://github.com/auwerxlab/survival_analysis/blob/master/notebooks/build_survival_curves.Rmd>`_

IPython notebooks
-----------------

- **Location:** Main directory of the project.
- **When to use:**

  - When keeping a trace of the global analysis process is needed.

- **When not to use:**

  - Well, there are no real reasons not to use it.

- **Documentation:**

  .. toctree::
     :maxdepth: 3

     survival_analysis_ipynb



