templates/survival_data_collection.xlsx
=======================================

:File: `templates/survival_data_collection.xlsx <https://github.com/auwerxlab/survival_analysis/raw/master/templates/survival_data_collection.xlsx>`_
:Location: ``templates/`` directory
:Spreadsheet structure: The spreadsheet must contain two sheets named ``data_collection`` and ``experimental_model``:

    ::

        templates/survival_data_collection.xlsx
        |── data_collection
        └── experimental_model

The ``data_collection`` sheet
-----------------------------

        Insert the counts of "Deads" and "Censored" at each time point.

        :First row: User's comments (this row will be ignored during the analysis)
        :"Day" column: Data collection time points.
        :"Condition..." column(s): Use one column per condition.

        .. note::
          - Warnings (!) are displayed if negative counts are found.
          - Cells that need fixed values/format are protected to avoid issues.

        .. Warning:: Make sure that the "Day" values are present at each collection date, otherwise data will be ignored!

The ``experimental_model`` sheet
--------------------------------

        Describe the experimental design.

        :First row: columns names
        :First column: Experimental group. The column name must be "ExperimentalGroup" and the row values must fit exactly the headers found in the `data_collection` sheet.
        :Next columns: Any experimental variable.
