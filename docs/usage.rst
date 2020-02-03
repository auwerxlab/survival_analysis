Usage
-----

The analysis is based on executable scripts found in the ``bin/`` directory. R notebooks found in the ``notebooks/`` directory can also be used.

An IPython notebook (``survival_analysis.ipynb``) is available in the main directory of the project.

This notebook provides a template for the analysis and is the easiest way to get started.
It also provides steps to work with the `SLIMS <https://www.genohm.com/>`_ laboratory information management system.

The ``survival_analysis.ipynb`` notebook has the following structure:
 - Setting up the environment on RENKU
 - Importing data from SLIMS
 - Creating a RENKU dataset
 - Building survival curves using the ``bin/build_survival_curves.R`` R script
 - Creating a RENKU dataset with the results
 - Uploading the results into SLIMS

.. toctree::
   :maxdepth: 3

   build_survival_curves
