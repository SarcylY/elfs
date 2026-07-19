# Estimates and evaluates latent factor scores for scales

Estimates and evaluates latent factor scores for scales

## Usage

``` r
elfs(
  data,
  f1_cols,
  f2_cols = NULL,
  f3_cols = NULL,
  f4_cols = NULL,
  f5_cols = NULL,
  f6_cols = NULL,
  fg_cols = NULL,
  f1_name = NULL,
  f2_name = NULL,
  f3_name = NULL,
  f4_name = NULL,
  f5_name = NULL,
  f6_name = NULL,
  fg_name = NULL,
  ordered = FALSE,
  missing = "listwise",
  dynamic = FALSE,
  meas_invar = NULL,
  modify = NULL,
  lfs_method = NULL,
  lfs_transform = TRUE,
  chrome_bypass = FALSE
)
```

## Arguments

- data:

  data.frame object

- f1_cols, f2_cols, f3_cols, f4_cols, f5_cols, f6_cols:

  Character vector(s) listing column names included in (each) latent
  factor. Compatible with
  [`dplyr::starts_with()`](https://tidyselect.r-lib.org/reference/starts_with.html)
  code. Only `f1_cols` is required.

- fg_cols:

  Character vector listing column names included in
  additionally-specified "general factor" (i.e., bifactor models).

- f1_name, f2_name, f3_name, f4_name, f5_name, f6_name:

  Optional names (character) for each specified latent factor.

- fg_name:

  Optional name (character) for "general factor" (see argument
  `fg_cols`, defaults to "FactorG").

- ordered:

  Whether to treat measured variables as ordinal (vs. continuous; see
  [`lavaan::sem()`](https://rdrr.io/pkg/lavaan/man/sem.html)). FALSE by
  default.

- missing:

  How to treat missing data (listwise deletion by default, see
  [`lavaan::lavOptions()`](https://rdrr.io/pkg/lavaan/man/lavOptions.html)
  for alternatives)

- dynamic:

  Whether to estimate dynamic fit indices
  [](https://pubmed.ncbi.nlm.nih.gov/34694832)(McNeish & Wolf, 2023). To
  use, download the latest development version from
  [Github](https://github.com/melissagwolf/dynamic) using
  `pak::pkg_install("dynamic")` or
  `devtools::install_github("melissagwolf/dynamic")`. FALSE by default.

- meas_invar:

  Character indicating column name to split-by when conducting
  measurement invariance across a categorical variable. NULL by default,
  assuming no measurement invariance analysis.

- modify:

  Additional character or character vector to be attached to the SEM
  specification prior to model fitting (e.g., specifying correlated
  residual variances)

- lfs_method:

  Character string indicating method for estimating latent factor scores
  (for details and default information, see
  [`lavaan::lavPredict()`](https://rdrr.io/pkg/lavaan/man/lavPredict.html))

- lfs_transform:

  Whether to transform extracted factor scores to match model-implied
  mean and variance-covariance (for details, see
  [`lavaan::lavPredict()`](https://rdrr.io/pkg/lavaan/man/lavPredict.html)).
  TRUE by default, following best practice when latent factor scores are
  used in subsequent regression analysis.

- chrome_bypass:

  Whether to bypass chrome-screenshot method for displaying results from
  running `elfs()`. FALSE by default.
