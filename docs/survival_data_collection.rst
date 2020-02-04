templates/survival_data_collection.xlsx
=======================================

Spreadsheet structure
---------------------

The spreadsheet must contain two sheets named ``data_collection`` and ``experimental_model``:

::

        templates/survival_data_collection.xlsx
        |── data_collection
        └── experimental_model

The ``data_collection`` sheet
-----------------------------

Insert the counts of "Deads" and "Censored" at each time point.

Format:

- **First row:** User's comments (this row will be ignored during the analysis)
- **"Day" column:** Data collection time points.
- **"Condition..." column(s):** Use one column per condition.

**CAUTION: Make sure that the "Dead" or "Censored" labels, as well as the "Day" value are present at each collection date, otherwise data will be ignored!**

The ``experimental_model`` sheet
--------------------------------

Describe the experimental design.

Format:

- **First row:** columns names
- **First column:** Experimental group. The column name must be "ExperimentalGroup" and the row values must fit exactly the headers found in the `data_collection` sheet.
- **Next columns:** Any experimental variable.
