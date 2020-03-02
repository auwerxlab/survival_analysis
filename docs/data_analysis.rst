2. Data analysis
================

This R project provides :ref:`R scripts` and :ref:`R notebooks` to perform basic analyses on survival datasets.

:ref:`IPython notebooks` that include all the environment setup and data analysis steps in simplified workflows are also provided in the main directory.
**It is the easiest way to get started** |:smiley:|.

This section summarizes details these tools to help you choose the most appropriate solution for your project.

.. note:: Try to keep the code, data and result organized along the existing directory tree:

    .. include:: directory_tree.rst

.. seealso:: The :ref:`*C. elegans* drug response` tutorial is a great way to start!

.. include:: ../bin/README.rst

:Documentation:
    .. toctree::
       :maxdepth: 3

       build_survival_curves

.. include:: ../notebooks/README.rst

:Documentation:
    .. toctree::
       :maxdepth: 3

       build_survival_curves_nb

IPython notebooks
-----------------

:Location: Main directory of the project.
:When to use:
  - Whenever keeping a trace of the global analysis process is needed.
  - In general, whenever using R scripts is appropriate.
:When not to use:
  - In general, when using a R notebook is appropriate.
:Documentation:
  .. toctree::
     :maxdepth: 3

     renku_simple_workflow_ipynb
     auwerxlab_workflow_ipynb
