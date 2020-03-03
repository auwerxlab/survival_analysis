Tracking data and figures may be disabled by default, so first modify the ``.gitignore`` file accordingly.
This can be done using UNIX cammands from a Terminal:

::

    $ sed -i "/\/data\/\*/d" .gitignore
    $ sed -i "/\/figs\/\*/d" .gitignore
    $ sed -i "/\*\.nb\.html/d" .gitignore

OR

::

    $ sed -i "/\/data\/\*/d;/\/figs\/\*/d;/\*\.nb\.html/d" .gitignore