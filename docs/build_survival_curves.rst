bin/build_survival_curves.R
===========================

:File: `build_survival_curves.R <https://github.com/auwerxlab/survival_analysis/blob/master/bin/build_survival_curves.R>`_

:Usage: bin/build_survival_curves.R [options]

	Fit the Kaplan-Meier survival curves and a Cox proportional hazards model using the R 'survival' package.

:Options:
	--input_fp=INPUT_FP
		Path to the xlsx input file

	--model=MODEL
		R formula for the survival::survfit() function

	-o OUTPUT, --output_dir=OUTPUT_DIR
		Path to the output directory. Default: data

	-f FIG_DIR, --fig_dir=FIG_DIR
		Path to the output directory for figure. Default: same as --output_dir

	--prism=PRISM
		Also generate a Graphpad Prism-compatible TXT table? (TRUE or FALSE) Default: TRUE

	-c COLORS, --colors=COLORS
		You can specify a comma-delimited set of colors. ex: "#FBB040,#F15A29,#00AEEF,#272BFF"

	--legendpos=LEGENDPOS
		Figure legend position. (top, right, bottom or left) Default: right

	--figdata=FIGDATA
		Generate a RDS file for the figure? (TRUE or FALSE) Default: TRUE

	--txt=TXT
		Name of the output TXT table. Default: survival_data.txt

	--pdf=PDF
		Name of the output PDF figure. Default: survival_data.pdf

	--coxph=COXPH
		Name of the output file for the Cox proportional hazards model. Default: coxph.txt

	--km=KM
		Name of the output file for the Kaplan-Meier survival model. Default: km.txt

	-h, --help
		Show this help message and exit

:Outputs:

    - A tidy data table. Default to ``data/survival_data.txt``.
    - If ``--prism`` is ``TRUE``, a data table in a Graphpad Prism-compatible format. Default to ``data/survival_data.txt-PRISM.txt``.
	- The results of the Cox regression analysis. Default to ``data/coxph.txt``.
	- A data table of variable for the Kaplan-Meier model. Default to ``data/km.txt``.
	- The figures, including survival curves. Default to ``data/survival_data.pdf``.
	- IF ``--figdata`` is ``TRUE``, the figures data in RDS format. Default to ``data/survival_data.rds``.
	The RDS file contains a list with the following elements:
		- **km:** Kaplan-Meier survival curves
		- **km.straight:** Straight-line version of the Kaplan-Meier survival curves
		- **n.risk:** Number of individuals at risk over time
		- **perc.risk:** Number of individuals at risk over time as a percentage of initial number
		- **median:** Median survival time with 0.95 confidence interval
		- **mean:** Mean survival time with Standard Error
		- **mrad:** Maximum reported age at death
		- **quartiles:** Survival time quartiles and Maximum reported age at death
		- **coxph:** Cox proportional hazard ratio for each covariate
