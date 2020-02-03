bin/build_survival_curves.R
---------------------------

::

    Usage: bin/build_survival_curves.R [options]
    Fit the Kaplan-Meier survival curves and a Cox proportional hazards model using the R 'survival' package.

    Options:
	    --input_fp=INPUT_FP
		    Path to the xlsx input file

    	--model=MODEL
	    	R formula for the survival::survfit() function

	    -t TXT, --txt=TXT
	    	Path to the output TXT table. Default: data/survival_data.txt

	    -p PRISM, --prism=PRISM
	    	Also generate a Graphpad Prism-compatible TXT table? (TRUE or FALSE) Default: TRUE

	    -f FIG, --fig=FIG
    		Path to the output figure. Default: figs/survival.pdf

    	-c COLORS, --colors=COLORS
	    	You can specify a comma-delimited set of colors. ex: "#FBB040,#F15A29,#00AEEF,#272BFF"

    	--legendpos=LEGENDPOS
	    	Figure legend position. (top, right, bottom or left) Default: right

	    --figdata=FIGDATA
	    	Generate a RDS file for the figure? (TRUE or FALSE) Default: TRUE

	    --coxph=COXPH
	    	Path to the output file for the Cox proportional hazards model. Default: data/coxph.txt

	    --km=KM
	    	Path to the output file for the Kaplan-Meier survival model. Default: data/km.txt

	    -h, --help
	    	Show this help message and exit
