6. Keep up to date with the last version of the project "template"
------------------------------------------------------------------

To keep updated with the last version of the code, set an ``upstream`` remote repository and use the ``git rebase`` command.


Set the ``upstream`` remote repository:

::

    $ git remote add upstream https://github.com/auwerxlab/survival_analysis.git


Whenever you need the latest updates from the ``upstream`` repository, run:

::

    $ git fetch upstream
    $ git rebase upstream/master
