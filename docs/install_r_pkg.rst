4. Install R packages
---------------------

This R project uses `packrat <https://rstudio.github.io/packrat>`_ to manage R packages.

The R packages sources are provided along with this project.
However, compiled R libraries are not.

Therefore, the R libraries first need to be compiled from the provided sources using the ``packrat::restore()`` command.
