#!/usr/bin/env Rscript
# build_survival_curves.R

# load R libraries
suppressMessages(library(here))
suppressMessages(library(readxl))
suppressMessages(library(dplyr))
suppressMessages(library(tidyr))
suppressMessages(library(data.table))
suppressMessages(library(survival))
suppressMessages(library(survminer))
suppressMessages(library(ggplot2))
suppressMessages(library(ggfortify))
suppressMessages(library(optparse))
set.seed(1988)

# Set script arguments
opt <- list(
  make_option(
    "--input_fp",
    type = "character",
    default = NULL,
    help = "Path to the xlsx input file"
  ),
  make_option(
    c("--model"),
    type = "character",
    default = "1",
    help = "R formula for the survival::survfit() function"
  ),
  make_option(
    c("-o", "--output_dir"),
    type = "character",
    default = here("data"),
    help = "Path to the output directory. Default: data"
  ),
  make_option(
    c("-f", "--fig_dir"),
    type = "character",
    default = NA,
    help = "Path to the output directory for figure. Default: same as --output_dir"
  ),
  make_option(
    "--prism",
    type = "logical",
    default = TRUE,
    help = "Also generate a Graphpad Prism-compatible TXT table? (TRUE or FALSE) Default: TRUE"
  ),
  make_option(
    c("-c", "--colors"),
    type = "character",
    default = NULL,
    help = 'You can specify a comma-delimited set of colors. ex: "#FBB040,#F15A29,#00AEEF,#272BFF"'
  ),
  make_option(
    "--legendpos",
    type = "character",
    default = "right",
    help = "Figure legend position. (top, right, bottom or left) Default: right"
  ),
  make_option(
    c("--figdata"),
    type = "logical",
    default = TRUE,
    help = "Generate a RDS file for the figure? (TRUE or FALSE) Default: TRUE"
  ),
  make_option(
    "--txt",
    type = "character",
    default = "survival_data.txt",
    help = "Name of the output TXT table. Default: survival_data.txt"
  ),
  make_option(
    "--pdf",
    type = "character",
    default = "survival_data.pdf",
    help = "Name of the output PDF figure. Default: survival_data.pdf"
  ),
  make_option(
    "--coxph",
    type = "character",
    default = "coxph.txt",
    help = "Name of the output file for the Cox proportional hazards model. Default: coxph.txt"
  ),
  make_option(
    "--km",
    type = "character",
    default = "km.txt",
    help = "Name of the output file for the Kaplan-Meier survival model. Default: km.txt"
  )
) %>%
  OptionParser(option_list = .,
               description = "Fit the Kaplan-Meier survival curves and a Cox proportional hazards model using the R 'survival' package.") %>%
  parse_args

if (is.na(opt$fig_dir)) {
  opt$fig_dir <- opt$output_dir
}

# Create output directories if not present yet
dir.create(opt$output_dir)
if (opt$output_dir != opt$fig_dir) {
  dir.create(opt$fig_dir)
}

# Test input arguments
if (!file.exists(opt$input_fp)) {
  stop(paste("--input_fp invalid value:", opt$input_fp, "not found."))
}
if (!is.null(opt$colors)) {
  opt$colors <- opt$colors %>%
    strsplit(",") %>%
    unlist
}

suppressMessages(
  readxl::read_xlsx(
    path = opt$input_fp,
    sheet = "data_collection",
    skip = 1,
    col_names = TRUE
  )
) %>%
  {
    if (sum(!is.na(.[2])) == 0) {
      . <- select(., -2)
    }
    if (sum(unlist(unique(.[2])) %in% c("Dead", "Censored", "Alive", "Total", NA)) != length(unlist(unique(.[2])))) {
      stop(paste("Row label other than 'Dead', 'Censored', 'Alive' or 'Total' found. Check file format in", opt$input_fp))
    }
  }

# Convert raw data into a tidy table
input.table <- suppressMessages(
  readxl::read_xlsx(
    path = opt$input_fp,
    sheet = "data_collection",
    skip = 1,
    col_names = TRUE
  )
) %>%
  {
    # Remove 2nd column from xls file if empty
    if (sum(!is.na(.[2])) == 0) {
      . <- select(., -2)
    }
    # Add labels to first non-labeled columns
    names(.)[1:2] <- c("analysisDate", "label")
    # Input analysis data to all rows and verify data type
    . <- mutate(.,
                analysisDate = as.character(.$analysisDate[1]),
                label = as.character(.$label)) %>%
      mutate_at(vars(-analysisDate, -label), list(as.numeric)) %>%
      mutate_at(vars(-analysisDate, -label, -Day), ~ replace(., is.na(.), 0))
    # Set Day 0 value to 0
    .$Day[.$label == "Total"] <- 0
    .$label[.$label == "Total"] <- "Alive"
    # Input Day value to all rows
    j <- 1
    for (i in 1:nrow(.)) {
      if (!is.na(.$Day[i])) {
        .$Day[j:i] <- .$Day[i]
        j <- i + 1
      }
    }
    .
  } %>%
  #ignore data without label or time
  drop_na(label, Day)

# Convert the tidy table into a survival table
survival.data <- input.table %>%
  drop_na(Day, label) %>%
  {
    lapply(unique(.$Day), function(y) {
      filter(., Day == y) %>%
        {
          lapply(select(., -one_of("analysisDate", "label", "Day")) %>% names,
                 function(x) {
                   if (sum(.$label != "Alive") != 0) {
                     n <- sum(.[.$label %in% c("Dead", "Censored"), x])
                     event <- .[.$label == "Dead", x]
                     censored <- .[.$label == "Censored", x]
                     # 1 = event, 0 = censored
                     data.frame(
                       time = rep(.$Day[1], n),
                       status = c(rep(1, event), rep(0, censored)),
                       ExperimentalGroup = rep(x, n)
                     )
                   }
                 }) %>%
            do.call(rbind, .)
        }
    }) %>%
      do.call(rbind, .)
  } %>%
  # Add last survivors data to the survival table
  rbind(lapply(unique(.$ExperimentalGroup), function(x) {
    n <-
      input.table[input.table$Day == 0, as.character(unlist(x))] - filter(., ExperimentalGroup == x) %>%
      nrow
    data.frame(
      time = rep(max(.$time), n),
      status = rep(0, n),
      ExperimentalGroup = rep(x, n)
    )
  }) %>%
    do.call(rbind, .)) %>%
  # Add the experimental model
  mutate(ExperimentalGroup = as.character(ExperimentalGroup)) %>%
  full_join(
    readxl::read_xlsx(
      path = opt$input_fp,
      sheet = "experimental_model",
      col_names = TRUE
    ),
    by = "ExperimentalGroup"
  ) %>%
  # reorder ExperimentalGroup levels
  mutate(ExperimentalGroup = factor(ExperimentalGroup,
                                    levels = select(
                                      input.table,
                                      -one_of("analysisDate",
                                              "label",
                                              "Day")
                                    ) %>%
                                      names))

#Export the survival table
fwrite(survival.data, file.path(opt$output_dir, opt$txt), sep = "\t")

# Export the survival table for prism
if (opt$prism == TRUE) {
  survival.data %>%
    mutate(id = 1:nrow(.)) %>%
    spread(ExperimentalGroup, status) %>%
    `row.names<-`(.$id) %>%
    select(one_of("time",
                  survival.data$ExperimentalGroup %>%
                    levels)) %>%
    fwrite(file.path(opt$output_dir, paste0(opt$txt, "-PRISM.txt")), sep = "\t")
}

# Fit the Kaplan-Meier survival curves
fit <-
  survfit(as.formula(paste("Surv(time, status) ~ ", opt$model)),
          data = survival.data)

# Fit a Cox proportional hazards model
coxfit <-
  coxph(as.formula(paste("Surv(time, status) ~", opt$model)),
        data = survival.data)
sink(file.path(opt$output_dir, opt$coxph))
summary(coxfit)
sink()

# Derive some variables from the Kaplan-Meier survival model:
# - median and mean survival time
# - survival time quartiles
# - Maximum Reported Age at Death (MRAD)
survival.variables <- fit %>%
  {
    cbind(
      survival:::survmean(., rmean = max(survival.data$time))$matrix %>%
        as.data.frame %>%
        # survmean adds buggy empty spaces at the end of row.names. Remove them...
        `row.names<-`(gsub(" *$", "", row.names(.))) %>%
        {
          model.matrix <- row.names(.) %>%
            strsplit(", ") %>%
            lapply(function(x) {
              strsplit(x, "=") %>%
                as.data.frame %>%
                `names<-`(unlist(.[1,])) %>%
                slice(-1)
            }) %>%
            do.call(rbind, .)
          
          mrad <-  model.matrix %>%
            apply(1, function(x) {
              d <- survival.data
              for (n in names(x)) {
                d <- filter_at(d, vars(n), any_vars(. == x[[n]]))
              }
              d %>% filter(status == 1) %>%
                select(time) %>%
                max
            }) %>%
            data.frame(MRAD = .)
          cbind(model.matrix, mrad, .)
        },
      survival:::quantile.survfit(.)
    )
  }
fwrite(survival.variables, file.path(opt$output_dir, opt$km), sep = "\t")

# Plot survival curves and associated statistics
suvival.plot <- {
  survplot <- ggsurvplot(fit,
                         conf.int = TRUE,
                         surv.median.line = "hv")
  
  list(
    # Plot the Kaplan-Meier survival curves
    km = survplot$plot +
      theme(legend.position = "right"),
    
    # Plot a straight line version of the Kaplan-Meier survival curves
    km.straight =   survplot$data.survplot %>%
      ggplot(aes(
        x = time, y = surv, color = strata
      )) +
      geom_ribbon(
        aes(
          ymin = lower,
          ymax = upper,
          fill = strata
        ),
        alpha = 0.2,
        color = NA
      ) +
      geom_line(size = 1) +
      geom_point(shape = 3,
                 size = 2) +
      labs(x = "Time",
           y = "Survival probability") +
      geom_hline(yintercept = 0.5,
                 linetype = "dashed") +
      expand_limits(x = 0, y = 0),
    
    # Plot the number of individuals at risk along time
    n.risk = survplot$data.survplot %>%
      ggplot(aes(
        x = time, y = n.risk, color = strata
      )) +
      geom_line(size = 1) +
      geom_point(shape = 3,
                 size = 2) +
      labs(x = "Time",
           y = "Individuals at risk") +
      expand_limits(x = 0, y = 0),
    
    # Plot the percentage of individuals at risk along time
    perc.risk = survplot$data.survplot %>%
      group_by(strata) %>%
      mutate(perc.risk = n.risk * 100 / max(n.risk)) %>%
      ungroup() %>%
      ggplot(aes(
        x = time, y = perc.risk, color = strata
      )) +
      geom_line(size = 1) +
      geom_point(shape = 3,
                 size = 2) +
      labs(x = "Time",
           y = "Individuals at risk (% of initial)") +
      geom_hline(yintercept = 50,
                 linetype = "dashed") +
      expand_limits(x = 0, y = 0),
    
    # Plot the median survival time
    median = survival.variables %>%
      ggplot(aes(
        x = row.names(.), y = median, group = 1
      ), ) +
      geom_point(size = 3) +
      geom_errorbar(aes(ymin = `0.95LCL`, ymax = `0.95UCL`),
                    width = 0.25) +
      labs(x = NULL,
           y = "Median survival time (+-0.95 confidence)") +
      coord_flip() +
      scale_y_continuous(limits = c(0, NA)),
    
    # Plot the mean survival time
    mean = survival.variables %>%
      ggplot(aes(
        x = row.names(.), y = `*rmean`, group = 1
      ), ) +
      geom_point(size = 3) +
      geom_errorbar(
        aes(
          ymin = `*rmean` - `*se(rmean)`,
          ymax = `*rmean` + `*se(rmean)`
        ),
        width = 0.25
      ) +
      labs(x = NULL,
           y = "Mean survival time (+-SE)") +
      coord_flip() +
      scale_y_continuous(limits = c(0, NA)),
    
    # Plot the Maximum Reported Age at Death (MRAD)
    mrad = survival.variables %>%
      mutate(rownames = row.names(.)) %>%
      ggplot(aes(
        x = rownames, y = MRAD, group = 1
      ), ) +
      geom_point(size = 3) +
      geom_segment(aes(
        y = 0, yend = MRAD, xend = rownames
      )) +
      labs(x = NULL,
           y = "MRAD") +
      coord_flip() +
      scale_y_continuous(limits = c(0, NA)),
    
    # Plot survival time quartiles (with whiskers set at 0 and MRAD)
    quartiles = survival.variables %>%
      select(quantile.25, quantile.50, quantile.75, MRAD) %>%
      mutate(rownames = row.names(.)) %>%
      ggplot(
        aes(
          x = rownames,
          ymin = 0,
          ymax = MRAD,
          lower = quantile.25,
          middle = quantile.50,
          upper = quantile.75
        )
      ) +
      geom_boxplot(stat = "identity",
                   width = 0.25) +
      geom_point(aes(y = MRAD),
                 size = 3) +
      labs(x = NULL,
           y = "Time") +
      coord_flip() +
      scale_y_continuous(limits = c(0, NA)),
    
    # Visualize the Cox proportional hazard model
    coxph = ggforest(coxfit, data = survival.data)
  )
}

# Store the survival curve object and pdf
if (opt$fig_dirdata == TRUE) {
  saveRDS(suvival.plot, file.path(opt$fig_dir,
                                  paste0(sub(
                                    "\\.[^.]*$",
                                    "",
                                    opt$pdf
                                  ),
                                  ".rds")))
}
pdf(file.path(opt$fig_dir, opt$pdf))
invisible(lapply(suvival.plot, print))
invisible(dev.off())
rm(list = ls())
