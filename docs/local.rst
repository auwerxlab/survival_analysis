Local setup
===========

General settings to use this project on most UNIX systems.

Requirements
------------

- R scripts and R notebooks:

  - R 3.5.2
  - RStudio or RStudio server

- IPython notebooks:

  - Python 3
  - Python libraries:

    .. include:: ../requirements.txt
       :literal:


Getting this R project
----------------------

Use git to clone this project where you need it.

::

    $ git clone https://github.com/auwerxlab/survival_analysis.git

.. include:: update_readme.rst

Keep track of your work
-----------------------

|:boom:| **CAUTION** |:boom:| **: Understand what you are doing. Hosting your project on the wrong repository can expose sensitive information and data!**

Use a version control system like `git <https://git-scm.com/>`_ to keep track of your work.

First, create a new git remote repository (ex: on GitHub).

Then, set its url in the project:

::

    $ git remote set-url origin https://<your_new_remote_url>.git

Tracking data and figures may be disabled by default. So modify the ``.gitignore`` file accordingly:

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

    $ git push

.. include:: upstream.rst

.. include:: install_r_pkg.rst

Run the following commands in the R console to enable packrat and install the required libraries:

::

    > packrat::on()
    > packrat::restore()
