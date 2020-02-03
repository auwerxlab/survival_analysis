Use in RENKU
============

Getting this R project
----------------------

Go to RENKU's GitLab then: ``New project`` > ``Import project`` > ``git Repo by URL``.

.. include:: upstream.rst

.. include:: install_r_pkg.rst

This step is done automatically by the Dockerfile.

When opening the project in RENKU for the first time, migrate the packrat libraries on the docker image using the python ``renku-r-tools`` package:

::

    $ renku-r ln-packrat-lib -p /home/rstudio/survival_analysis -s /home/rstudio/packrat

