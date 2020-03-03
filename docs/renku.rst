Working on RENKU
================

This section describes the general steps to setup this project in `RENKU <https://renkulab.io/>`_.

*Tested with RENKU release* `0.5.1 <https://github.com/SwissDataScienceCenter/renku/releases/tag/0.5.1>`_

1. Import the R project "template" into RENKU
---------------------------------------------

Go to RENKU's GitLab then:  |button01| -> |button02| -> |button03|.

.. |button01| image:: images/gitlab_button_01.png
    :width: 90 px

.. |button02| image:: images/gitlab_button_02.png
    :width: 90 px

.. |button03| image:: images/gitlab_button_03.png
    :width: 90 px

Use *https://github.com/auwerxlab/survival_analysis.git* as the ``Git repository URL`` and fill the other fields according to your needs:

.. image:: images/gitlab_screenshot_01.png
   :width: 100 %

2. Build the working environment image
--------------------------------------

You need a first commit to trigger the build of the project's docker image.

A simple way to get a first commit is to update the README.rst with your author's information and a short description.

You can do it directly in GitLab by selecting the README.rst file and using the |button04| button.

Once you are done, click on |button05|.

This will trigger the build of the project's docker image - have a cup of |:coffee:| as this can take a while.

.. |button04| image:: images/gitlab_button_04.png
    :width: 50 px

.. |button05| image:: images/gitlab_button_05.png
    :width: 110 px

3. Launch an Interactive Environment
------------------------------------

After creating the project in RENKU's GitLab, it will appear in your projects list in the RENKU web interface.

Launch a new Interactive Environment to start working on the project:

.. image:: images/ui_screenshot_01.png
   :width: 100 %

.. include:: install_r_pkg.rst

This step is done automatically by the Dockerfile |:smiley:|.

When opening the project in RENKU for the first time, migrate the packrat libraries on the docker image using the python ``renku-r-tools`` package.
This can be done from a Terminal within a running Interactive Environment:

::

    $ renku-r ln-packrat-lib -p /home/rstudio/survival_analysis -s /home/rstudio/packrat

5. Save your work !
-------------------

.. warning:: Work done within a running Interactive Environment gets **lost** when the environment is stoped, unless it is **saved** using git! |:boom:|

.. danger::

    Understand what you are doing. Hosting your project on the wrong repository can **expose sensitive information and data**! |:boom:|

    It usually boils down to the following points:

    - Understand the project's privacy requirments.
    - Know who has access to the git repository.
    - If you whitness a breach, immediatly inform the responsible persons and fix the breach (make sure to also delete all sensitive information from previous versions and logs).


Renku uses GitLab/git for version control and to save the work that is done within a running Interactive Environment.

.. inlcude:: gitignore_edition.rst

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

|:thumbsup:| That is it!
