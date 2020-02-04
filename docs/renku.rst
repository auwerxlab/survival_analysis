RENKU setup
===========

General settings to use this project in `RENKU <https://renkulab.io/>`_.

Requirements
------------

All the requirements are automatically handled by the Dockerfile |:smiley:|.

Getting this R project
----------------------

Go to RENKU's GitLab then: ``New project`` > ``Import project`` > ``git Repo by URL``.

.. include:: update_readme.rst

Keep track of your work
-----------------------

|:boom:| **CAUTION** |:boom:| **: Understand what you are doing. Hosting your project on the wrong repository can expose sensitive information and data!**

Renku uses GitLab for version control.

Tracking data and figures may be disabled by default. So modify the ``.gitignore`` file accordingly:

::

    $ sed -i "/data\/\*/d;/figs\/\*/d;/\*\.nb\.html/d" .gitignore

When you are ready to save changes made to the project, take a snapshot of all its files:

::

    $ git add -A

Then, commit the changes:

::

    $ git commit -m "<your_short_description>"

And finally, push the committed changes to the remote git repository in the RENKU GitLab:

::

    $ git push

.. include:: upstream.rst

.. include:: install_r_pkg.rst

This step is done automatically by the Dockerfile |:smiley:|.

When opening the project in RENKU for the first time, migrate the packrat libraries on the docker image using the python ``renku-r-tools`` package:

::

    $ renku-r ln-packrat-lib -p /home/rstudio/survival_analysis -s /home/rstudio/packrat

