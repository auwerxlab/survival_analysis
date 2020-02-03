# Survival analysis

[![Apache2 license](http://img.shields.io/badge/license-apache2-brightgreen.svg)](https://github.com/auwerxlab/survival_analysis/blob/master/)
[![GitHub release](https://img.shields.io/github/v/release/auwerxlab/survival_analysis)](https://GitHub.com/auwerxlab/survival_analysis/releases/)

A R project for survival analysis based on the R [survival](https://cran.r-project.org/web/packages/survival/index.html) package.

Features:

- Kaplan-Meier survival curves
- Cox proportional hazards regression model

The project is readily compatible with (RENKU)[https://renkulab.io/].

# Resources

- Git clone URL: https://github.com/auwerxlab/survival_analysis.git
- Documentation: https://github.com/auwerxlab/survival_analysis
- R package 'survival': https://cran.r-project.org/web/packages/survival/index.html

# Getting this R project

Use git to clone this project where you need it.

```sh
$ git clone https://github.com/auwerxlab/survival_analysis.git
```

When using RENKU, go to RENKU's GitLab then: ``New project``>``Import project``>``git Repo by URL``.

To keep updated with the last version of the codes, set an ``upstream`` remote repository and use the ``git rebase`` command:

```sh
$ git remote add upstream https://github.com/auwerxlab/survival_analysis.git
```

```sh
$ git fetch upstream
$ git rebase upstream/master
```

# Data collection and data format

This project intends to simplify data collection by using a XLSX spreadsheet.
Please use the XLSX template in `templates/survival_data_collection.xlsx` to collect data.

The spreadsheet structure looks like:

<pre>
templates/survival_data_collection.xlsx
|── data_collection
└── experimental_model
</pre>

### data_collection sheet

Insert the counts of "Deads" and "Censored" at each time point.

Format:

- First row: User's comments (this row will be ignored during the analysis)
- "Day" column: Data collection time points.
- "Condition..." column(s): Use one column per condition.

CAUTION: Make sure that the "Dead" or "Censored" labels, as well as the "Day" value are present at each collection date, otherwise data will be ignored!

### experimental_model sheet

Describe the experimental design.

Format:

- First row: columns names
- First column: Experimental group. The column name must be "ExperimentalGroup" and the row values must fit exactly the headers found in the `data_collection` sheet.
- Next columns: Any experimental variable.

# Installing R packages

This R project uses [packrat]() to manage R packages.
The R packages sources are provided along with this project.
However, compiled R libraries are not.

Therefore, the R libraries first need to be compiled from the provided sources using the ``packrat::restore()`` command.
Run the following commands in the R console to enable packrat and install the required libraries:

```R
> packrat::on()
> packrat::restore()
```

When using RENKU, this step is not required as it is done automatically.
Instead, when opening the project for the first time, migrate the packrat libraries on the docker image using the python renku-r-tools package:

```sh
$ renku-r ln-packrat-lib -p /home/rstudio/survival_analysis -s /home/rstudio/packrat
```

# What's in this project

The project's structure looks like:

<pre>
survival_analysis
|── bin        Executable scripts
|── figs       Figures
|── notebooks  R notebooks
|── packrat    R packages
|── templates  Contains the spreadsheet template for data collection 
└── data       Raw and processed data
</pre>

# Usage

The analysis is based on executable scripts found in the `bin/` directory and R notebooks found in the `notebooks/` directory.

A Jupyter notebook (``survival_analysis.ipynb``) is also available in the main directory of the project.
This notebook provides directions for the analysis and steps to integrate with SLIMS and RENKU:
 - Setup for RENKU
 - Import data from SLIMS
 - Create a RENKU dataset
 - Build survival curves using the bin/build_survival_curves.R R script
 - Create a dataset with the results
 - Upload the results into SLIMS

#### bin/build_survival_curves.R

<pre>
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
</pre>

# Tutorial

The `data/tutorial_data.xlsx` file contains a sample survival analysis dataset for *Caenorhabditis elegans*.
A hundred *C. elegans* belonging to two different strains (StrainA and StrainB) were submitted to two different treatments (T1 and T2), as summarized below:

| n   | Strain  | Treatment |
|-----|---------|-----------|
| 100 | StrainA | T1        |
| 100 | StrainA | T2        |
| 100 | StrainB | T1        |
| 100 | StrainB | T2        |

To fit the Kaplan-Meier survival curves and a Cox proportional hazards model, run the `build_survival_curves.R` script. Using the `--model Strain+Treatment` option will specify an additive linear model using "Strain" and "Treatement" as covariates.

```sh
$ bin/build_survival_curves.R --input_fp data/tutorial_data.xlsx --model Strain+Treatment --txt data/tutorial_data.txt --fig figs/tutorial.pdf --coxph data/tutorial_coxph.txt --km data/tutorial_km.txt
```

When using RENKU, prepend `renku run` to the command to track the inputs/outputs with the knowledge graph.

The results will look like:

<pre>
survival_analysis
|── data
|   |── tutorial_data.txt            A tidy data table
|   |── tutorial_data.txt-PRISM.txt  PRISM.txt - A data table in a Graphpad Prism-compatible format
|   |── tutorial_coxph.txt           The results of the Cox regression analysis
|   └── tutorial_km.txt              A data table of variable for the Kaplan-Meier model
└── figs
    |── tutorial.pdf                 The figures, including survival curves
    └── tutorial.rds                 The figures data in RDS format
</pre>

`tutorial.rds` is a list containing the following elements:

- km: Kaplan-Meier survival curves

- km.straight: Straight-line version of the Kaplan-Meier survival curves

- n.risk: Number of individuals at risk over time

- perc.risk: Number of individuals at risk over time as a percentage of initial number

- median: Median survival time with 0.95 confidence interval

- mean: Mean survival time with Standard Error

- mrad: Maximum reported age at death

- quartiles: Survival time quartiles and Maximum reported age at death

- coxph: Cox proportional hazard ratio for each covariate
