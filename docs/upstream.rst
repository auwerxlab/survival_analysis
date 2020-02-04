Keeping up to date with the last version of the code
----------------------------------------------------

To keep updated with the last version of the code, set an ``upstream`` remote repository and use the ``git rebase`` command.


Set the ``upstream`` remote repository:

::

    $ git remote add upstream https://github.com/auwerxlab/survival_analysis.git


Get updates from the ``upstream`` repository:

::

    $ git fetch upstream
    $ git rebase upstream/master
