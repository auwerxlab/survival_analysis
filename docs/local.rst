Working locally
===============

This section describes the general steps to setup this project on most UNIX systems.

1. Requirements
---------------

- R scripts and R notebooks:

  - R 3.5.2
  - RStudio or RStudio server

- IPython notebooks:

  - Python 3
  - Python libraries:

    .. include:: ../requirements.txt
       :literal:


2. Get the R project "template"
-------------------------------

Use git to clone this project where you need it.

::

    $ git clone https://github.com/auwerxlab/survival_analysis.git

3. Update the README file
-------------------------

Now that the project is ready to start, update its README.rst file with your author's information and a short description.

.. include:: install_r_pkg.rst

Run the following commands in the R console to enable packrat and install the required libraries:

::

    > packrat::on()
    > packrat::restore()

5. Keep track of your work
--------------------------

.. danger::

    Understand what you are doing. Hosting your project on the wrong repository can **expose sensitive information and data**! |:boom:|

    It usually boils down to the following points:

    - Understand the project's privacy requirments.
    - Know who has access to the git repository.
    - If you whitness a breach, immediatly inform the responsible persons and fix the breach (make sure to also delete all sensitive information from previous versions and logs).

Use a version control system like `git <https://git-scm.com/>`_ to keep track of your work.

First, create a new git remote repository (ex: on GitHub).

Then, set its url in the project:

::

    $ git remote set-url origin https://<your_new_remote_url>.git

Tracking data and figures may be disabled by default, so first modify the ``.gitignore`` file accordingly.
This can be done using UNIX cammands from a Terminal:

::

    $ sed -i "/data\/\*/d" .gitignore
    $ sed -i "/figs\/\*/d" .gitignore
    $ sed -i "/\*\.nb\.html/d" .gitignore

OR

::

    $ sed -i "/data\/\*/d;/figs\/\*/d;/\*\.nb\.html/d" .gitignore

When you are ready to save changes made to the project, take a snapshot of all its files:

::

    $ git add -A

Then, commit the changes:

::

    $ git commit -m "<your_short_description>"

And finally, push the committed changes to the remote git repository:

::

    $ git push origin master

.. include:: upstream.rst


|:thumbsup:| That is it!
