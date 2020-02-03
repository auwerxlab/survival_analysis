Data collection and data format
===============================

This project intends to simplify data collection by using a XLSX spreadsheet.

Use the XLSX template in ``templates/survival_data_collection.xlsx`` to collect data.

The data collection spreadsheet structure looks like:

::

    templates/survival_data_collection.xlsx
    |── data_collection
    └── experimental_model


``data_collection`` sheet
-------------------------

Insert the counts of "Deads" and "Censored" at each time point.

Format:

- First row: User's comments (this row will be ignored during the analysis)
- "Day" column: Data collection time points.
- "Condition..." column(s): Use one column per condition.

CAUTION: Make sure that the "Dead" or "Censored" labels, as well as the "Day" value are present at each collection date, otherwise data will be ignored!

``experimental_model`` sheet
----------------------------

Describe the experimental design.

Format:

- First row: columns names
- First column: Experimental group. The column name must be "ExperimentalGroup" and the row values must fit exactly the headers found in the `data_collection` sheet.
- Next columns: Any experimental variable.
