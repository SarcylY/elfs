#' @import dplyr
#' @import lavaan
#' @import semTools
#' @import kableExtra
#' @import magick
#' @import webshot2
#' @import chromote
#'
#' @export
#' @title Estimates and evaluates latent factor scores for scales
#' @param data data.frame object
#' @param f1_cols,f2_cols,f3_cols,f4_cols,f5_cols,f6_cols Character vector(s) listing column names included in (each) latent factor. Only `f1_cols` is required.
#' @param fg_cols Character vector listing column names included in additionally-specified "general factor" (e.g., for higher-order or bifactor models).
#' @param f1_name,f2_name,f3_name,f4_name,f5_name,f6_name Optional names (character) for each specified latent factor.
#' @param fg_name Optional name (character) for "general factor" (see argument `fg_cols`, defaults to "FactorG").
#' @param ordered Whether to treat measured variables as ordinal (vs. continuous; see [lavaan::sem()]). FALSE by default.
#' @param missing How to treat missing data (listwise deletion by default, see [lavaan::lavOptions()] for alternatives)
#' @param dynamic Whether to estimate dynamic fit indices <a href = "https://pubmed.ncbi.nlm.nih.gov/34694832"/>(McNeish & Wolf, 2023)</a>. To use, download the latest development version from <a href = "https://github.com/melissagwolf/dynamic">Github</a> using `pak::pkg_install("dynamic")` or `devtools::install_github("melissagwolf/dynamic")`. FALSE by default.
#' @param meas_invar Character indicating column name to split-by when conducting measurement invariance across a categorical variable. NULL by default, assuming no measurement invariance analysis.
#' @param modify Additional character or character vector to be attached to the SEM specification prior to model fitting (e.g., specifying correlated residual variances)
#' @param lfs_method Character string indicating method for estimating latent factor scores (for details and default information, see [lavaan::lavPredict()])
#' @param lfs_transform Whether to transform extracted factor scores to match model-implied mean and variance-covariance (for details, see [lavaan::lavPredict()]). TRUE by default, following best practice.
#' @param chrome_bypass Whether to bypass chrome-screenshot method for displaying results from running `elfs()`. If TRUE, prints results. FALSE by default.
elfs <- function(data, f1_cols, f2_cols = NULL, f3_cols = NULL, f4_cols = NULL, f5_cols = NULL, f6_cols = NULL, fg_cols = NULL,
                 f1_name = NULL, f2_name = NULL, f3_name = NULL, f4_name = NULL, f5_name = NULL, f6_name = NULL, fg_name = NULL,
                 ordered = FALSE, missing = "listwise", dynamic = FALSE, meas_invar = NULL, modify = NULL,
                 lfs_method = NULL, lfs_transform = TRUE, chrome_bypass = FALSE) {


  ## required packages

  # require(magrittr)
  # require(dplyr)
  # require(lavaan)
  # require(semTools)
  # require(kableExtra)
  # require(magick)
  #
  # if(chrome_bypass == FALSE) {
  #
  #   require(webshot2)
  #   require(chromote)
  #
  # }

  font_size <- 16 #controlling this is not typically necessary; 16 is an optimal value for clarity + not creating cutoffs in the tables

  options(webshot.quiet = TRUE) #suppresses webshot messages #DON'T DO THIS

  if(ordered == FALSE){

    robust_set <- FALSE

  } else {

    robust_set <- TRUE

  }

  ###column vector creation (redundant if fX_cols are exact columns, required if e.g., starts_with() is used)

  f1_s <- colnames(select(data, all_of(f1_cols)))
  f2_s <- colnames(select(data, all_of(f2_cols)))
  f3_s <- colnames(select(data, all_of(f3_cols)))
  f4_s <- colnames(select(data, all_of(f4_cols)))
  f5_s <- colnames(select(data, all_of(f5_cols)))
  f6_s <- colnames(select(data, all_of(f6_cols)))
  fg_s <- colnames(select(data, all_of(fg_cols)))


  ###use of lav_string to construct lavaan syntax by factor

  f1_n <- ifelse(is.null(f1_name), "Factor1", f1_name)
  f1_c <- lav_string(f1_n, f1_s)
  f1_t <- lav_string_tau(f1_n, f1_s)

  if(!is.null(f2_cols)){

    f2_n <- ifelse(is.null(f2_name), "Factor2", f2_name)
    f2_c <- lav_string(f2_n, f2_s)
    f2_t <- lav_string_tau(f2_n, f2_s)

  } else {

    f2_c <- ""
    f2_t <- ""

  }

  if(!is.null(f3_cols)){

    f3_n <- ifelse(is.null(f3_name), "Factor3", f3_name)
    f3_c <- lav_string(f3_n, f3_s)
    f3_t <- lav_string_tau(f3_n, f3_s)

  } else {

    f3_c <- ""
    f3_t <- ""

  }

  if(!is.null(f4_cols)){

    f4_n <- ifelse(is.null(f4_name), "Factor4", f4_name)
    f4_c <- lav_string(f4_n, f4_s)
    f4_t <- lav_string_tau(f4_n, f4_s)

  } else {

    f4_c <- ""
    f4_t <- ""

  }

  if(!is.null(f5_cols)){

    f5_n <- ifelse(is.null(f5_name), "Factor5", f5_name)
    f5_c <- lav_string(f5_n, f5_s)
    f5_t <- lav_string_tau(f5_n, f5_s)

  } else {

    f5_c <- ""
    f5_t <- ""

  }

  if(!is.null(f6_cols)){

    f6_n <- ifelse(is.null(f6_name), "Factor6", f6_name)
    f6_c <- lav_string(f6_n, f6_s)
    f6_t <- lav_string_tau(f6_n, f6_s)

  } else {

    f6_c <- ""
    f6_t <- ""

  }

  if(!is.null(fg_cols)){

    fg_n <- ifelse(is.null(fg_name), "FactorG", fg_name)
    fg_c <- lav_string(fg_n, fg_s)
    fg_t <- lav_string_tau(fg_n, fg_s)

  } else {

    fg_c <- ""
    fg_t <- ""

  }

  cfa_string <- paste(f1_c, f2_c, f3_c, f4_c, f5_c, f6_c, fg_c, sep = "\n") #combine factor strings with line breaks
  cfa_string_tau <- paste(f1_t, f2_t, f3_t, f4_t, f5_t, f6_t, fg_t, sep = "\n")

  if(!is.null(modify)){ #logical statement to append modifications to lavaan character string

    if(!is.character(modify)){

      stop("The argument 'modify' must be a character string or vector of character strings representing lavaan modification indices.")

    }

    cfa_string <- paste(cfa_string, modify, sep = "\n")

  }

  ## set orthogonal value

  if(is.null(fg_cols)){

    orthogonal = FALSE

  } else {

    orthogonal = TRUE
    message("Because a bifactor model has been specified, orthogonal = TRUE for all models.")

  }

  ### FIT MODEL ###

  if(ordered == FALSE) {
  #fitting for continuous indicators
    cfa_model <- cfa(cfa_string, data, ordered = ordered, orthogonal = orthogonal, missing = missing, std.lv=TRUE) # CFA object

  } else {
  #fitting for ordinal indicators
    cfa_model <- cfa(cfa_string, data, ordered = ordered, orthogonal = orthogonal, missing = missing, estimator = "WLSMV", std.lv=TRUE)

  }

  cfa_summ <- summary(cfa_model, fit.measures = TRUE, rsquare = TRUE, standardized = TRUE) # summary of CFA object
  cfa_modind <- modificationIndices(cfa_model, sort. = TRUE) # modification indices, sorted from biggest to smallest

  if(is.null(lfs_method)){

    lfs <- lavPredict(cfa_model, transform = lfs_transform) #estimated latent factor scores;
    #transform = TRUE best practice when factor scores will be used in a follow-up regression analysis (see documentation)

  } else {

    lfs <- lavPredict(cfa_model, method = lfs_method, transform = lfs_transform)

  }

  ### BOX 1: FIT ASSESSMENT ###

  if(dynamic == TRUE){

    require(dynamic)

    if(ordered == FALSE){

      cfa_dynamic <- DDDFI(cfa_model)

    } else {

      cfa_dynamic <- DDDFI(cfa_model, data = data, estimator = "WLSMV", scale = "categorical")

    }

  } else {
  #dynamic == FALSE
    cfa_dynamic <- "To request dynamic fit indices, install the 'dynamic' package (https://github.com/cran/dynamic) and set dynamic = TRUE in this function or visit https://dynamicfit.app/ and provide the necessary inputs."

  }

  cfa_matrix <- cfa.tab(x = cfa_model, robust = robust_set)
  colnames(cfa_matrix) <- c("Chi\u00B2", "df", "p", "CFI", "RMSEA", "RMSEA_lo", "RMSEA_hi", "SRMR")

  lfs_fit <- cfa_matrix |>
    kbl() |>
    kable_styling(bootstrap_options = c("striped"), font_size = font_size) |>
    add_footnote(c(paste0("Example text for reporting: The fit statistics for the estimated latent variable model are: \u03C7\u00B2(", cfa_matrix[1,2], ") = ", cfa_matrix[1,1], ", p ", ifelse(as.numeric(cfa_matrix[1,3]) < .001, "< .001", paste0("= ", cfa_matrix[1,3])), ", CFI = ", cfa_matrix[1,4], ", RMSEA = ", cfa_matrix[1,5], " (90% CI[", cfa_matrix[1,6], ", ", cfa_matrix[1,7], "]), SRMR = ", cfa_matrix[1,8], "."), "At minimum, report the CFI, RMSEA, and SRMR in your manuscript. To evaluate fit, Dynamic Fit Indices (McNeish & Wolf, 2023) are recommended. Reference the 'dynamic' object in the output list for output or for information about how to install this package.", "If ordered = TRUE or missing = \"ml\", robust CFI and RMSEA values are given above.", paste0("Modification indices (in the \"modind\" object) can be referenced to understand which parameters might be freed in the model to improve model fit. A data-driven approach to improving fit is generally not recommended for existing scales, but some adjustments might be justifiable (e.g., correlated residuals due to item similarities). Adjustments can be specified using the \"modify\" argument. In this model, setting modify = \"", paste(cfa_modind[1,1], cfa_modind[1,2], cfa_modind[1,3]), "\" would reduce the \u03C7\u00B2 of the model by ", format(round(cfa_modind[1,4])), ".")))

  if(chrome_bypass == FALSE){

    lfs_fit_img <- box_output(lfs_fit, "#E69F00")

  } else {

    lfs_fit <- head_output(lfs_fit, "#E69F00")

  }

  ### BOX 2: SAMPLE SIZE, RELIABILITY, AVE ###


  h <- h(cfa_model) #coefficient H
  omega <- unlist(compRelSEM(cfa_model), use.names = FALSE) # McDonald's omega, a reliability measure that does not assume tau-equivalence
  lfs_ave <- AVE(cfa_model) #average variance extracted

  h_omega_ave <- cbind(h, omega, lfs_ave) |>
    round(2)

  colnames(h_omega_ave) <- c("Coefficient H", "McDonald's Omega", "Average Variance Extracted (AVE)")

  cfa_rel <- h_omega_ave |>
    kbl() |>
    kable_styling(bootstrap_options = c("striped"), font_size = font_size) |>
    add_footnote(c("Rules of thumb for reliability are H > .7 and Omega > .7.", "Coefficient H is the preferred reliability statistic for latent factor scores; McDonald's Omega is the preferred reliability statistic for sum/mean scores.", paste0(cfa_summ$data[[2]], " of ", ifelse(length(cfa_summ$data)==2,cfa_summ$data[[2]], cfa_summ$data[[3]]), " cases were used. Listwise deletion is specified by default. If using continuous indicators, missing = \"ml\" can be used to handle missing values with Full Information Maximum Likelihood (not imputation). This approach is only valid if data are missing completely at random (MCAR) or missing at random (MAR), but has the advantage of yielding an \"lfs\" matrix with cases equal to the input data frame.", "When using listwise deletion, if latent factor scores and the input data frame have different numbers of rows, filter rows with missing data prior to latent factor score estimation."))) ### note for future; incorporate H

  if(chrome_bypass == FALSE){

    cfa_rel_img <- box_output(cfa_rel, "#56B4E9")

  } else {

    cfa_rel <- head_output(cfa_rel, "#56B4E9")

  }

  ### BOX 3: MEASUREMENT INVARIANCE ###

  if(!is.null(meas_invar)){

    if(!is.character(meas_invar)){

      stop("The argument 'meas_invar' needs to be a character string representing a grouping variable.")

    }

    if(ordered == FALSE){

      cfa_config <- cfa(cfa_string, data, ordered = ordered, orthogonal = orthogonal, missing = missing, group = meas_invar, std.lv=TRUE)
      cfa_weak <- cfa(cfa_string, data, ordered = ordered, orthogonal = orthogonal, missing = missing, group = meas_invar, group.equal = c("loadings"), std.lv=TRUE)
      cfa_strong <- cfa(cfa_string, data, ordered = ordered, orthogonal = orthogonal, missing = missing, group = meas_invar, group.equal = c("loadings", "intercepts"), std.lv=TRUE)
      cfa_strict <- cfa(cfa_string, data, ordered = ordered, orthogonal = orthogonal, missing = missing, group = meas_invar, group.equal = c("loadings", "intercepts", "residuals"), std.lv=TRUE)

    } else {

      cfa_config <- cfa(cfa_string, data, ordered = ordered, orthogonal = orthogonal, missing = missing, group = meas_invar, std.lv=TRUE)
      cfa_weak <- cfa(cfa_string, data, ordered = ordered, orthogonal = orthogonal, missing = missing, group = meas_invar, group.equal = c("loadings"), std.lv=TRUE)
      cfa_strong <- cfa(cfa_string, data, ordered = ordered, orthogonal = orthogonal, missing = missing, group = meas_invar, group.equal = c("loadings", "thresholds"), std.lv=TRUE)
      cfa_strict <- cfa(cfa_string, data, ordered = ordered, orthogonal = orthogonal, missing = missing, group = meas_invar, group.equal = c("loadings", "thresholds", "residuals"), std.lv=TRUE)

    }

    if(is.null(lfs_method)){

      lfs_config <- lavPredict(cfa_config, transform = lfs_transform)
      lfs_weak <- lavPredict(cfa_weak, transform = lfs_transform)
      lfs_strong <- lavPredict(cfa_strong, transform = lfs_transform)
      lfs_strict <- lavPredict(cfa_strict, transform = lfs_transform)

    } else {

      lfs_config <- lavPredict(cfa_config, method = lfs_method, transform = lfs_transform)
      lfs_weak <- lavPredict(cfa_weak, method = lfs_method, transform = lfs_transform)
      lfs_strong <- lavPredict(cfa_strong, method = lfs_method, transform = lfs_transform)
      lfs_strict <- lavPredict(cfa_strict, method = lfs_method, transform = lfs_transform)

    }

    model_group <- list(cfa_config, cfa_weak, cfa_strong, cfa_strict)
    lfs_group <- list(lfs_config, lfs_weak, lfs_strong, lfs_strict)

    lfs_meas_invar_test <- lavTestLRT(cfa_config, cfa_weak, cfa_strong, cfa_strict)

    lfs_meas_invar_fit <- cfa.tab.multi(x = cfa_config, y = cfa_weak, z = cfa_strong, a = cfa_strict, robust = robust_set)

    if(missing == "listwise") {

      lfs_meas_invar_fit <- lfs_meas_invar_fit |>
        cbind(c("", as.character(round(lfs_meas_invar_test[2,5], 2)), as.character(round(lfs_meas_invar_test[3,5], 2)),  as.character(round(lfs_meas_invar_test[4,5], 2)))) |>
        cbind(c("", as.character(round(lfs_meas_invar_test[2,7], 2)), as.character(round(lfs_meas_invar_test[3,7], 2)),  as.character(round(lfs_meas_invar_test[4,7], 2)))) |>
        cbind(c("", as.character(round(lfs_meas_invar_test[2,8], 3)), as.character(round(lfs_meas_invar_test[3,8], 3)),  as.character(round(lfs_meas_invar_test[4,8], 3)))) |>
        cbind(c("", as.character(round((as.numeric(lfs_meas_invar_fit[2,4]) - as.numeric(lfs_meas_invar_fit[1,4])), 3)), as.character(round((as.numeric(lfs_meas_invar_fit[3,4]) - as.numeric(lfs_meas_invar_fit[2,4])), 3)),  as.character(round((as.numeric(lfs_meas_invar_fit[4,4]) - as.numeric(lfs_meas_invar_fit[3,4])), 3)))) |>
        cbind(c("", as.character(round(lfs_meas_invar_test[2,6], 3)), as.character(round(lfs_meas_invar_test[3,6], 3)),  as.character(round(lfs_meas_invar_test[4,6], 3))))

      if(ordered == FALSE) {

        mi_cfi_rmsead_text <- "\u0394CFI > -.01 and RMSEA\u1D05 < .08 can be interpreted as evidence of measurement invariance."

      } else {

        mi_cfi_rmsead_text <- "WARNING: although \u0394CFI > -.01 and RMSEA\u1D05 < .08 can be interpreted as evidence of measurement invariance with continuous indicators, these thresholds may not apply for ordered indicators. Proceed with caution (see Bowen & Masa, 2015)."

      }

    } else {

      lfs_meas_invar_fit <- lfs_meas_invar_fit |>
        cbind(c("", as.character(round(lfs_meas_invar_test[2,5], 2)), as.character(round(lfs_meas_invar_test[3,5], 2)),  as.character(round(lfs_meas_invar_test[4,5], 2)))) |>
        cbind(c("", as.character(round(lfs_meas_invar_test[2,6], 2)), as.character(round(lfs_meas_invar_test[3,6], 2)),  as.character(round(lfs_meas_invar_test[4,6], 2)))) |>
        cbind(c("", as.character(round(lfs_meas_invar_test[2,7], 3)), as.character(round(lfs_meas_invar_test[3,7], 3)),  as.character(round(lfs_meas_invar_test[4,7], 3)))) |>
        cbind(c("", as.character(round((as.numeric(lfs_meas_invar_fit[2,4]) - as.numeric(lfs_meas_invar_fit[1,4])), 3)), as.character(round((as.numeric(lfs_meas_invar_fit[3,4]) - as.numeric(lfs_meas_invar_fit[2,4])), 3)),  as.character(round((as.numeric(lfs_meas_invar_fit[4,4]) - as.numeric(lfs_meas_invar_fit[3,4])), 3)))) |>
        cbind(c("", "NA", "NA", "NA"))

      if(ordered == FALSE) {

        mi_cfi_rmsead_text <- "\u0394CFI > -.01 can be interpreted as evidence of measurement invariance. RMSEA\u1D05 is only requested when missing = \"listwise\"."

      } else {

        mi_cfi_rmsead_text <- "WARNING: although \u0394CFI > -.01 can be interpreted as evidence of measurement invariance with continuous indicators, these thresholds may not apply for ordered indicators. Proceed with caution (see Bowen & Masa, 2015). RMSEA\u1D05 is only requested when missing = \"listwise\"."

      }

    }

    rownames(lfs_meas_invar_fit) <- c("Config", "Weak", "Strong", "Strict")
    colnames(lfs_meas_invar_fit) <- c("Chi\u00B2", "df", "p", "CFI", "RMSEA", "RMS_lo", "RMS_hi", "SRMR", "\u0394Chi\u00B2", "\u0394df", "\u0394p", "\u0394CFI", "RMSEA\u1D05")

    lfs_meas_invar <- lfs_meas_invar_fit |>
      kbl() |>
      kable_styling(bootstrap_options = c("striped"), font_size = font_size) |>
      add_footnote(c(paste0("Measurement Invariance for ", meas_invar, ". Guidelines for evaluating measurement invariance differ, but a few guidelines are given below. See Putnick & Bornstein (2016) for details as well as more information about partial invariance and probing items for sources of non-invariance."), "If LRT tests (i.e., \u0394Chi\u00B2) are not significant, measurement invariance has been demonstrated. However, this test is conservative.", mi_cfi_rmsead_text))

    if(chrome_bypass == FALSE){

      lfs_meas_invar_img <- box_output(lfs_meas_invar, "#009E73")

    } else {

      lfs_meas_invar <- head_output(lfs_meas_invar, "#009E73")

    }

  } else {

    model_group <- "If the \"meas_invar\" argument is used, this object contains a list of models testing different levels of measurement invariance."
    lfs_group <- "If the \"meas_invar\" argument is used, this object contains a list of latent factor score matrices corresponding with the four models used to test measurement invariance."

    lfs_meas_invar_fit <- matrix(, nrow = 4, ncol = 13)

    rownames(lfs_meas_invar_fit) <- c("Config", "Weak", "Strong", "Strict")
    colnames(lfs_meas_invar_fit) <- c("Chi\u00B2", "df", "p", "CFI", "RMSEA", "RMS_hi", "RMS_lo", "SRMR", "\u0394Chi\u00B2", "\u0394df", "\u0394p", "\u0394CFI", "RMSEA\u1D05")

    lfs_meas_invar <- lfs_meas_invar_fit |>
      kbl() |>
      kable_styling(bootstrap_options = c("striped"), font_size = font_size) |>
      add_footnote(c(paste0("Measurement invariance was not evaluated for any grouping variable. If you would like to evaluate measurement invariance, use the \"meas_invar\" argument to do so.")))

    if(chrome_bypass == FALSE){

      lfs_meas_invar_img <- box_output(lfs_meas_invar, "#009E73")

    } else {

      lfs_meas_invar <- head_output(lfs_meas_invar, "#009E73")

    }

  }


  ### BOX 4: MULTIPLE CORRELATED CONSTRUCTS ###

  lfs_corr_matrix <- round(cor(lfs, use = "na.or.complete"), 2)

  lfs_corr <- lfs_corr_matrix |>
    kbl() |>
    kable_styling(bootstrap_options = c("striped"), font_size = font_size) |>
    add_footnote(c(paste0("Correlation matrix for all latent factors. To the extent that factors are correlated, estimation of latent factor scores will better approximate true scores than sum/mean scores.")))

  if(chrome_bypass == FALSE){

    lfs_corr_img <- box_output(lfs_corr, "#0072B2")

  } else {

    lfs_corr <- head_output(lfs_corr, "#0072B2")

  }

  ### BOX 5: VARIABILITY OF FACTOR LOADINGS ###

  tau_model <- cfa(cfa_string_tau, data, ordered = ordered, missing = missing, std.lv=TRUE)

  cfa_tau_test <- lavTestLRT(cfa_model, tau_model)

  tau_fit <- cfa.tab.multi(x = cfa_model, y = tau_model, robust = robust_set)

  if(missing == "listwise") {

    tau_fit <- tau_fit |>
      cbind(c("", as.character(round(cfa_tau_test[2,5], 2)))) |>
      cbind(c("", as.character(round(cfa_tau_test[2,7], 2)))) |>
      cbind(c("", as.character(round(cfa_tau_test[2,8], 3)))) |>
      cbind(c("", as.character(round((as.numeric(tau_fit[2,4]) - as.numeric(tau_fit[1,4])), 3)))) |>
      cbind(c("", as.character(round(cfa_tau_test[2,6], 3))))

    tau_cfi_rmsead_text <- "However, for cases in which researchers are otherwise motivated to use sum/mean scores, a sufficiently small \u0394CFI and RMSEA\u1D05 (i.e., close to 0) might be used to justify this decision."

  } else {

    tau_fit <- tau_fit |>
      cbind(c("", as.character(round(cfa_tau_test[2,5], 2)))) |>
      cbind(c("", as.character(round(cfa_tau_test[2,6], 2)))) |>
      cbind(c("", as.character(round(cfa_tau_test[2,7], 3)))) |>
      cbind(c("", as.character(round((as.numeric(tau_fit[2,4]) - as.numeric(tau_fit[1,4])), 3)))) |>
      cbind(c("", "NA"))

    tau_cfi_rmsead_text <- "However, for cases in which researchers are otherwise motivated to use sum/mean scores, a sufficiently small \u0394CFI and RMSEA\u1D05 (i.e., close to 0) might be used to justify this decision. RMSEA\u1D05 is only requested when missing = \"listwise\"."

  }

  rownames(tau_fit) <- c("Free Loadings", "Equal Loadings")
  colnames(tau_fit) <- c("Chi\u00B2", "df", "p", "CFI", "RMSEA", "RMS_lo", "RMS_hi", "SRMR", "\u0394Chi\u00B2", "\u0394df", "\u0394p", "\u0394CFI", "RMSEA\u1D05")

  if(ordered == FALSE){

    cfa_tau <- tau_fit |>
      kbl() |>
      kable_styling(bootstrap_options = c("striped"), font_size = font_size) |>
      add_footnote(c(paste0("Likelihood Ratio Test comparing the tau-equivalent (i.e., equal loadings) model and the model with freely estimated loadings. If this test is not significant, sum/mean scores are recommended. If this test is significant, latent factor scores are generally recommended.", tau_cfi_rmsead_text)))

  } else {

    cfa_tau <- tau_fit |>
      kbl() |>
      kable_styling(bootstrap_options = c("striped"), font_size = font_size) |>
      add_footnote(c(paste0("Likelihood Ratio Test comparing the tau-equivalent (i.e., equal loadings) model and the model with freely estimated loadings. If this test is not significant, sum/mean scores are recommended. If this test is significant, latent factor scores are generally recommended.", tau_cfi_rmsead_text, "The equal loadings model often produces very poor fit with ordinal indicators.")))

  }

  if(chrome_bypass == FALSE){

    cfa_tau_img <- box_output(cfa_tau, "#CC79A7")

  } else {

    cfa_tau <- head_output(cfa_tau, "#CC79A7")

  }


  ### APPEND IMAGES ###

  if(chrome_bypass == FALSE){

    all_tables <- image_append(c(lfs_fit_img, cfa_rel_img, lfs_meas_invar_img, lfs_corr_img, cfa_tau_img), stack = TRUE)

    resize_height <- paste0("x", as.character(image_info(all_tables)$height))

    full_chart <- image_append(c(image_scale(image_read(system.file("extdata", "flowchart.jpg", package = "elfs")), resize_height), all_tables))

  } else {

    full_chart <- image_scale(image_read(system.file("extdata", "flowchart.jpg", package = "elfs")), as.character(500))

  }

  output_list <- list(full_chart, lfs, cfa_model, cfa_summ, cfa_dynamic, cfa_modind, lfs_fit, cfa_rel, lfs_meas_invar, lfs_corr, cfa_tau, model_group, lfs_group)
  names(output_list) <- c("flowchart", "lfs", "model", "summary", "dynamic", "modind", "fit", "rel", "meas_invar", "corr", "tau", "group_models", "group_lfs")

  if(chrome_bypass == FALSE){

    return(c(output_list, message("\n\nRun 'print([elfs_object]$flowchart)' to evaluate which scoring method best fits your data. If latent factor scores are recommended, merge the 'lfs' vector with your data.")))

  } else {

    return(c(output_list, message("\n\nRun 'print([elfs_object])' to evaluate which scoring method best fits your data. If latent factor scores are recommended, merge the 'lfs' vector with your data.")))

  }

}

## Additional helper functions

#' @title Generating lavaan-readable single-factor string from model specifications
#' @param lfs_name Name of latent factor
#' @param lfs_cols Column(s) loading onto latent factor
#' @returns single-factor string readable by lavaan
lav_string <- function(lfs_name, lfs_cols){

  string <- paste0(lfs_name,' =~ ', paste0(lfs_cols, collapse = " + "))
  return(string)
}

#' @title Generating lavaan-readable tau-equivalent single-factor string from model specifications
#' @param lfs_name Name of latent factor
#' @param lfs_cols Column(s) loading onto latent factor
#' @returns single-factor string readable by lavaan
lav_string_tau <- function(lfs_name, lfs_cols){

  string <- paste0(lfs_name,' =~ 1*', paste0(lfs_cols, collapse = " + 1*"))
  return(string)
}

#' @title Generating APA-formatted tables of results
#' @param x lavaan model object
#' @param robust Whether robust RMSEAs are calculated. Defaults to FALSE.
#' @returns data.frame object in APA format
cfa.tab <- function(x, robust = FALSE) ##adapted from tabledown; 3 decimals needed for change CFI
{
  ifelse(robust == TRUE, {
    Model <- lavaan::fitmeasures(x, c("chisq", "df", "pvalue",
                                      "cfi.robust", "rmsea.robust",
                                      "rmsea.ci.upper.robust", "rmsea.ci.lower.robust",
                                      "srmr"))
  }, {
    Model <- lavaan::fitmeasures(x, c("chisq", "df", "pvalue",
                                      "cfi", "rmsea", "rmsea.ci.lower",
                                      "rmsea.ci.upper", "srmr"))
  })
  Model <- MOTE::apa(Model, 3, TRUE)
  Model <- as.data.frame(Model)
  Model <- (t(Model))
  colnames(Model) <- c("Chi-square", "df", "p",
                       "CFI", "RMSEA", "RMSEA-Upper", "RMSEA-Lower",
                       "SRMR")
  Model
}

#' @title Generating Concatenated APA-formatted tables of results
#' @param x,y,z,a,b lavaan model object(s)
#' @param robust Whether robust RMSEAs are calculated. Defaults to FALSE.
#' @returns data.frame object in APA format
cfa.tab.multi <- function (x, y, z = NULL, a = NULL, b = NULL, robust = FALSE) ##adapted from tabledown
{
  if (is.null(z) & is.null(a) & is.null(b)) {
    ifelse(robust == TRUE, {
      table1 <- cfa.tab(x, robust = TRUE)
      table2 <- cfa.tab(y, robust = TRUE)
    }, {
      table1 <- cfa.tab(x, robust = FALSE)
      table2 <- cfa.tab(y, robust = FALSE)
    })
    table <- rbind(table1, table2)
    rownames(table) <- c("Model1", "Model2")
  }
  else if (is.null(a) & is.null(b)) {
    ifelse(robust == TRUE, {
      table1 <- cfa.tab(x, robust = TRUE)
      table2 <- cfa.tab(y, robust = TRUE)
      table3 <- cfa.tab(z, robust = TRUE)
    }, {
      table1 <- cfa.tab(x, robust = FALSE)
      table2 <- cfa.tab(y, robust = FALSE)
      table3 <- cfa.tab(z, robust = FALSE)
    })
    table <- rbind(table1, table2, table3)
    rownames(table) <- c("Model1", "Model2", "Model3")
  }
  else if (is.null(b)) {
    ifelse(robust == TRUE, {
      table1 <- cfa.tab(x, robust = TRUE)
      table2 <- cfa.tab(y, robust = TRUE)
      table3 <- cfa.tab(z, robust = TRUE)
      table4 <- cfa.tab(a, robust = TRUE)
    }, {
      table1 <- cfa.tab(x, robust = FALSE)
      table2 <- cfa.tab(y, robust = FALSE)
      table3 <- cfa.tab(z, robust = FALSE)
      table4 <- cfa.tab(a, robust = FALSE)
    })
    table <- rbind(table1, table2, table3, table4)
    rownames(table) <- c("Model1", "Model2", "Model3", "Model4")
  }
  else {
    ifelse(robust == TRUE, {
      table1 <- cfa.tab(x, robust = TRUE)
      table2 <- cfa.tab(y, robust = TRUE)
      table3 <- cfa.tab(z, robust = TRUE)
      table4 <- cfa.tab(a, robust = TRUE)
      table5 <- cfa.tab(b, robust = TRUE)
    }, {
      table1 <- cfa.tab(x, robust = FALSE)
      table2 <- cfa.tab(y, robust = FALSE)
      table3 <- cfa.tab(z, robust = FALSE)
      table4 <- cfa.tab(a, robust = FALSE)
      table5 <- cfa.tab(b, robust = FALSE)
    })
    table <- rbind(table1, table2, table3, table4, table5)
    rownames(table) <- c("Model1", "Model2", "Model3", "Model4",
                         "Model5")
  }
  table
}

#' @title Calculating Coefficient H
#' @description adapted from <a href = "https://github.com/jsakaluk/scripty">jsakaluk/psyscores</a>
#' @param model lavaan fitted model object
#' @returns numeric indicating Coefficient H
h <- function(model){

  lfs_vector <- unique(filter(standardizedsolution(model), op == "=~")$lhs)

  h_vector <- vector()

    for(i in 1:length(lfs_vector)){

      loads <- dplyr::filter(standardizedsolution(model), lhs == lfs_vector[i] & op == "=~")
      indicator_vector <- loads$rhs
      errors <- dplyr::filter(standardizedsolution(model), lhs %in% indicator_vector)

      #H
      loads <- dplyr::mutate(loads, I2 = (est.std^2)/(1-est.std^2))
      sumI2 <- sum(loads$I2)
      mind <- 1/sumI2
      majd <- 1+mind
      H <- 1/majd

      h_vector[i] <- H

    }

  return(h_vector)

}

### BOX_OUTPUT
#' @title Generating readable image output
#' @param table data table
#' @param border Colour used to surround data table
#' @returns image of data table with coloured border
box_output <- function(table, border){

  #file = paste0("elfs_figures/", deparse(substitute(table)), ".png") #scrap for as_image files going into folder

  table |>
    as_image() |>
    image_read() |>
    image_convert(format = "jpg") |>
    image_border(color = "white", geometry = "1.5x1.5") |>
    image_border(color = border, geometry = "3x3") |>
    image_border(color = "white", geometry = "3x3")

}

### HEAD_OUTPUT
#' @title Generating readable output
#' @param table data table
#' @param color Colour used to surround data table
#' @returns data table with coloured border
head_output <- function(table, color){

  table |>
    row_spec(row = 0, background = color)

}
