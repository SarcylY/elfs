# Short Dark Triad Example Dataset

## Introduction

The following vignette showcases the use of
[`elfs()`](https://sarcyly.github.io/elfs/reference/elfs.md) when
applied to data from the Short Dark Triad (SD3; Paulhus & Jones, 2001),
collected from the Open-Source Psychometrics Project. First, the dataset
is loaded; responses were filtered to retain complete data, after
converting responses of 0 to NA.

``` r

library(elfs)
library(dplyr)
library(magrittr)

SD3_data <- elfs::ShortDarkTriad_data
```

### Multi-factor Model

For our first model, we can conduct the most simplistic model on the
SD3. Treating each of the factors of the Dark Triad (Machiavellianism,
Narcissism, and Psychopathy) as separate factors measured by 9 items
each. In the following model, all latent factors are allowed to be
covary (i.e., oblique rotation).

``` r

#column selection can take in a traditional character vector, or use "starts_with()" or "ends_with()"
SD3_elf_oblique <- elfs(data = SD3_data,
                        f1_cols = starts_with("M"), f1_name = "Machiavellianism",
                        f2_cols = c("N1", "N2", "N3", "N4", "N5", "N6", "N7", "N8", "N9"), f2_name = "Narcissism",
                        f3_cols = starts_with("P"), f3_name = "Psychopathy", 
                        chrome_bypass = T)
```

The resulting
[`elfs()`](https://sarcyly.github.io/elfs/reference/elfs.md) output
contains information about your fitted model. By initiating specific
calls, you can output information regarding:

``` r

#Model Fit
SD3_elf_oblique$fit
```

|  | Chi² | df | p | CFI | RMSEA | RMSEA_lo | RMSEA_hi | SRMR |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Model | 26228.214 | 321.000 | 0.000 | 0.848 | 0.067 | 0.067 | 0.068 | 0.060 |
| ^(a) Example text for reporting: The fit statistics for the estimated latent variable model are: χ²( 321.000) = 26228.214, p \< .001, CFI = 0.848, RMSEA = 0.067 (90% CI\[ 0.067, 0.068\]), SRMR = 0.060. |  |  |  |  |  |  |  |  |
| ^(b) At minimum, report the CFI, RMSEA, and SRMR in your manuscript. To evaluate fit, Dynamic Fit Indices (McNeish & Wolf, 2023) are recommended. Reference the ‘dynamic’ object in the output list for output or for information about how to install this package. |  |  |  |  |  |  |  |  |
| ^(c) If ordered = TRUE or missing = “ml”, robust CFI and RMSEA values are given above. |  |  |  |  |  |  |  |  |
| ^(d) Modification indices (in the “modind” object) can be referenced to understand which parameters might be freed in the model to improve model fit. A data-driven approach to improving fit is generally not recommended for existing scales, but some adjustments might be justifiable (e.g., correlated residuals due to item similarities). Adjustments can be specified using the “modify” argument. In this model, setting modify = “M3  N5” would reduce the χ² of the model by 1800. |  |  |  |  |  |  |  |  |

``` r


#Individual Factor Reliabilities
SD3_elf_oblique$rel
```

|  | Coefficient H | McDonald’s Omega | Average Variance Extracted (AVE) |
|:---|---:|---:|---:|
| Machiavellianism | 0.88 | 0.86 | 0.44 |
| Narcissism | 0.81 | 0.35 | 0.31 |
| Psychopathy | 0.83 | 0.70 | 0.31 |
| ^(a) Rules of thumb for reliability are H \> .7 and Omega \> .7. |  |  |  |
| ^(b) Coefficient H is the preferred reliability statistic for latent factor scores; McDonald’s Omega is the preferred reliability statistic for sum/mean scores. |  |  |  |
| ^(c) 17738 of 17738 cases were used. Listwise deletion is specified by default. If using continuous indicators, missing = “ml” can be used to handle missing values with Full Information Maximum Likelihood (not imputation). This approach is only valid if data are missing completely at random (MCAR) or missing at random (MAR), but has the advantage of yielding an “lfs” matrix with cases equal to the input data frame.When using listwise deletion, if latent factor scores and the input data frame have different numbers of rows, filter rows with missing data prior to latent factor score estimation. |  |  |  |

``` r


#Latent Factor Correlations
SD3_elf_oblique$corr
```

|  | Machiavellianism | Narcissism | Psychopathy |
|:---|---:|---:|---:|
| Machiavellianism | 1.00 | 0.65 | 0.90 |
| Narcissism | 0.65 | 1.00 | 0.73 |
| Psychopathy | 0.90 | 0.73 | 1.00 |
| ^(a) Correlation matrix for all latent factors. To the extent that factors are correlated, estimation of latent factor scores will better approximate true scores than sum/mean scores. |  |  |  |

``` r


#Comparison to Tau-equivalent Model Assumed by Cronbach's Alpha
SD3_elf_oblique$tau
```

|  | Chi² | df | p | CFI | RMSEA | RMS_lo | RMS_hi | SRMR | ΔChi² | Δdf | Δp | ΔCFI | RMSEAᴅ |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Free Loadings | 26228.214 | 321.000 | 0.000 | 0.848 | 0.067 | 0.067 | 0.068 | 0.060 |  |  |  |  |  |
| Equal Loadings | 96512.633 | 348.000 | 0.000 | 0.435 | 0.125 | 0.124 | 0.125 | 0.550 | 70284.42 | 27 | 0 | -0.413 | 0.383 |
| ^(a) Likelihood Ratio Test comparing the tau-equivalent (i.e., equal loadings) model and the model with freely estimated loadings. If this test is not significant, sum/mean scores are recommended. If this test is significant, latent factor scores are generally recommended.However, for cases in which researchers are otherwise motivated to use sum/mean scores, a sufficiently small ΔCFI and RMSEAᴅ (i.e., close to 0) might be used to justify this decision. |  |  |  |  |  |  |  |  |  |  |  |  |  |

If latent factor scores are ultimately decided on, they can be easily
extracted and incorporated into a dataset (here, the original
dataframe):

``` r

head(SD3_elf_oblique$lfs, 10)
#>       Machiavellianism  Narcissism Psychopathy
#>  [1,]       0.28655501 -0.32015485   0.4784436
#>  [2,]      -1.76882225 -1.82334348  -1.1416649
#>  [3,]      -1.07060832 -1.82631970  -1.1771523
#>  [4,]       1.51997447  2.50507743   1.8157381
#>  [5,]       0.16469075  0.16374078  -0.1846107
#>  [6,]      -1.10243694 -0.92272210  -0.2118951
#>  [7,]       0.30836232  0.09699356   0.3730168
#>  [8,]       1.39972340  2.15563754   1.0648364
#>  [9,]       0.08157957 -0.66193056   0.3727990
#> [10,]       1.56845746  2.53830204   2.0781236

SD3_clean <- SD3_data %>%
  bind_cols(SD3_elf_oblique$lfs)
glimpse(SD3_clean)
#> Rows: 17,738
#> Columns: 32
#> $ M1               <dbl> 4, 2, 3, 5, 4, 4, 4, 5, 5, 5, 5, 5, 5, 2, 5, 4, 4, 5,…
#> $ M2               <dbl> 4, 1, 3, 5, 4, 2, 4, 5, 3, 5, 5, 4, 1, 2, 3, 5, 3, 2,…
#> $ M3               <dbl> 4, 5, 3, 4, 2, 2, 4, 5, 4, 5, 5, 4, 2, 3, 4, 4, 3, 4,…
#> $ M4               <dbl> 4, 2, 5, 5, 5, 4, 2, 5, 4, 3, 5, 3, 2, 4, 4, 5, 4, 4,…
#> $ M5               <dbl> 4, 2, 1, 5, 5, 2, 4, 5, 4, 5, 5, 5, 1, 3, 3, 4, 2, 5,…
#> $ M6               <dbl> 4, 1, 1, 5, 5, 3, 4, 5, 4, 5, 4, 5, 2, 3, 4, 4, 2, 4,…
#> $ M7               <dbl> 4, 2, 5, 5, 4, 5, 4, 5, 4, 5, 1, 5, 4, 4, 5, 5, 5, 5,…
#> $ M8               <dbl> 3, 2, 5, 5, 1, 2, 3, 4, 2, 5, 5, 3, 1, 2, 4, 4, 2, 3,…
#> $ M9               <dbl> 4, 3, 3, 5, 4, 2, 5, 5, 4, 5, 4, 5, 2, 4, 5, 5, 4, 4,…
#> $ N1               <dbl> 2, 1, 2, 5, 3, 2, 4, 4, 3, 5, 4, 5, 2, 2, 5, 3, 3, 1,…
#> $ N2               <dbl> 4, 5, 5, 1, 4, 5, 4, 1, 5, 1, 3, 2, 4, 2, 2, 4, 3, 2,…
#> $ N3               <dbl> 2, 1, 1, 5, 3, 2, 3, 5, 2, 5, 4, 5, 2, 2, 4, 2, 2, 1,…
#> $ N4               <dbl> 3, 1, 1, 5, 1, 2, 3, 5, 1, 5, 3, 5, 1, 2, 3, 4, 1, 1,…
#> $ N5               <dbl> 4, 5, 1, 5, 5, 2, 4, 5, 4, 5, 5, 3, 2, 3, 4, 5, 3, 3,…
#> $ N6               <dbl> 4, 5, 5, 1, 4, 4, 3, 1, 5, 1, 1, 1, 2, 3, 5, 5, 4, 4,…
#> $ N7               <dbl> 2, 1, 1, 5, 3, 1, 2, 4, 2, 5, 4, 4, 4, 2, 2, 5, 3, 1,…
#> $ N8               <dbl> 3, 5, 5, 1, 2, 3, 4, 1, 3, 1, 2, 1, 4, 2, 4, 4, 2, 4,…
#> $ N9               <dbl> 4, 2, 5, 5, 5, 5, 4, 5, 4, 5, 3, 5, 4, 3, 3, 3, 4, 3,…
#> $ P1               <dbl> 3, 1, 3, 5, 4, 3, 3, 2, 5, 5, 3, 4, 2, 1, 5, 2, 2, 1,…
#> $ P2               <dbl> 4, 1, 5, 1, 5, 5, 2, 5, 2, 2, 3, 2, 2, 3, 2, 2, 3, 4,…
#> $ P3               <dbl> 3, 1, 3, 5, 3, 4, 4, 2, 4, 5, 3, 2, 2, 3, 3, 2, 1, 3,…
#> $ P4               <dbl> 2, 5, 1, 2, 1, 4, 2, 5, 3, 5, 3, 1, 4, 1, 3, 1, 2, 2,…
#> $ P5               <dbl> 4, 4, 3, 5, 4, 2, 4, 5, 4, 5, 4, 5, 4, 4, 2, 2, 3, 1,…
#> $ P6               <dbl> 4, 1, 1, 5, 3, 2, 3, 5, 4, 5, 3, 5, 2, 4, 3, 1, 2, 2,…
#> $ P7               <dbl> 4, 5, 2, 5, 5, 1, 4, 2, 1, 5, 2, 2, 4, 1, 3, 5, 3, 5,…
#> $ P8               <dbl> 4, 3, 3, 1, 4, 1, 4, 5, 2, 3, 3, 1, 1, 1, 3, 1, 3, 1,…
#> $ P9               <dbl> 4, 2, 1, 5, 1, 5, 3, 3, 1, 5, 4, 1, 1, 2, 3, 1, 2, 2,…
#> $ country          <chr> "GB", "US", "US", "GB", "GB", "IT", "GB", "GB", "US",…
#> $ source           <dbl> 1, 1, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1, 3, 1, 3, 1, 3, 1,…
#> $ Machiavellianism <dbl> 0.28655501, -1.76882225, -1.07060832, 1.51997447, 0.1…
#> $ Narcissism       <dbl> -0.32015485, -1.82334348, -1.82631970, 2.50507743, 0.…
#> $ Psychopathy      <dbl> 0.4784436, -1.1416649, -1.1771523, 1.8157381, -0.1846…
```

### Ordinal Measured Variables

An additional specification that measured variables should be treated as
ordinal variables (i.e., using the DWLS estimator, instead of ML) can be
specified using the typical `ordered = T` syntax from *lavaan*.

``` r

#column selection can take in a traditional character vector, or use "starts_with()" or "ends_with()"
SD3_elf_ordered <- elfs(data = SD3_data,
                        f1_cols = starts_with("M"), f1_name = "Machiavellianism",
                        f2_cols = starts_with("N"), f2_name = "Narcissism",
                        f3_cols = starts_with("P"), f3_name = "Psychopathy", 
                        ordered = T, 
                        chrome_bypass = T)
#> Warning in ifelse(as.numeric(cfa_matrix[1, 3]) < 0.001, "< .001", paste0("= ",
#> : NAs introduced by coercion
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=2.01228e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=2.00482e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=2.00127e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9979e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.99781e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=8.04913e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=8.04913e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=7.64668e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=3.82334e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=3.72775e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=2.81971e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=2.36569e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=2.13868e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=2.02517e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=2.02234e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=2.02099e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=2.00818e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=2.00178e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.99858e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9985e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.99846e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9981e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.99792e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.99783e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.99783e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.99781e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.99781e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
#> Warning in pchisq(x2, df = df, ncp = lambda): pnchisq(x=2.01228e+06, f=348,
#> theta=1.9978e+06, ..): not converged in 1000000 iter.
```

Note that when `ordered = T`, nonconvergence in the tau-equivalent model
is much more likely, restricting potential comparisons.

The resulting tables displaying model fit are modified accordingly:

``` r

#Model Fit
SD3_elf_ordered$fit
```

|  | Chi² | df | p | CFI | RMSEA | RMSEA_lo | RMSEA_hi | SRMR |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Model | 33551.660 | 321.000 | NA | 0.822 | 0.083 | 0.083 | 0.082 | 0.064 |
| ^(a) Example text for reporting: The fit statistics for the estimated latent variable model are: χ²( 321.000) = 33551.660, p NA, CFI = 0.822, RMSEA = 0.083 (90% CI\[ 0.083, 0.082\]), SRMR = 0.064. |  |  |  |  |  |  |  |  |
| ^(b) At minimum, report the CFI, RMSEA, and SRMR in your manuscript. To evaluate fit, Dynamic Fit Indices (McNeish & Wolf, 2023) are recommended. Reference the ‘dynamic’ object in the output list for output or for information about how to install this package. |  |  |  |  |  |  |  |  |
| ^(c) If ordered = TRUE or missing = “ml”, robust CFI and RMSEA values are given above. |  |  |  |  |  |  |  |  |
| ^(d) Modification indices (in the “modind” object) can be referenced to understand which parameters might be freed in the model to improve model fit. A data-driven approach to improving fit is generally not recommended for existing scales, but some adjustments might be justifiable (e.g., correlated residuals due to item similarities). Adjustments can be specified using the “modify” argument. In this model, setting modify = “M3  N5” would reduce the χ² of the model by 3451. |  |  |  |  |  |  |  |  |

``` r


#Comparison to Tau-equivalent Model Assumed by Cronbach's Alpha
SD3_elf_ordered$tau
```

|  | Chi² | df | p | CFI | RMSEA | RMS_lo | RMS_hi | SRMR | ΔChi² | Δdf | Δp | ΔCFI | RMSEAᴅ |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Free Loadings | 33551.660 | 321.000 | NA | 0.822 | 0.083 | 0.083 | 0.082 | 0.064 |  |  |  |  |  |
| Equal Loadings | 2012282.904 | 348.000 | NA | NaN | Inf | NA | NA | 0.497 | 257213.89 | 27 | 0 | NaN | 2.033 |
| ^(a) Likelihood Ratio Test comparing the tau-equivalent (i.e., equal loadings) model and the model with freely estimated loadings. If this test is not significant, sum/mean scores are recommended. If this test is significant, latent factor scores are generally recommended.However, for cases in which researchers are otherwise motivated to use sum/mean scores, a sufficiently small ΔCFI and RMSEAᴅ (i.e., close to 0) might be used to justify this decision.The equal loadings model often produces very poor fit with ordinal indicators. |  |  |  |  |  |  |  |  |  |  |  |  |  |

### Bi-factor Model

[`elfs()`](https://sarcyly.github.io/elfs/reference/elfs.md) also
contains baseline functionality to fit bifactor models. For example, we
can specify a general “Evil” factor explaining leftover variance in the
original model:

``` r

SD3_elf_bifac <- elfs(data = SD3_data,
                      f1_cols = starts_with("M"), f1_name = "Machiavellianism",
                      f2_cols = starts_with("N"), f2_name = "Narcissism",
                      f3_cols = starts_with("P"), f3_name = "Psychopathy", 
                      fg_cols = c(starts_with("M"), starts_with("N"), starts_with("P")), fg_name = "Evil",
                      chrome_bypass = T)
```

The resulting models must set covariances between latent factors to 0 to
identify the model. The
[`elfs()`](https://sarcyly.github.io/elfs/reference/elfs.md) output is
then updated:

``` r

#Model Fit
SD3_elf_bifac$fit
```

|  | Chi² | df | p | CFI | RMSEA | RMSEA_lo | RMSEA_hi | SRMR |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Model | 17174.142 | 297.000 | 0.000 | 0.901 | 0.057 | 0.056 | 0.057 | 0.043 |
| ^(a) Example text for reporting: The fit statistics for the estimated latent variable model are: χ²( 297.000) = 17174.142, p \< .001, CFI = 0.901, RMSEA = 0.057 (90% CI\[ 0.056, 0.057\]), SRMR = 0.043. |  |  |  |  |  |  |  |  |
| ^(b) At minimum, report the CFI, RMSEA, and SRMR in your manuscript. To evaluate fit, Dynamic Fit Indices (McNeish & Wolf, 2023) are recommended. Reference the ‘dynamic’ object in the output list for output or for information about how to install this package. |  |  |  |  |  |  |  |  |
| ^(c) If ordered = TRUE or missing = “ml”, robust CFI and RMSEA values are given above. |  |  |  |  |  |  |  |  |
| ^(d) Modification indices (in the “modind” object) can be referenced to understand which parameters might be freed in the model to improve model fit. A data-driven approach to improving fit is generally not recommended for existing scales, but some adjustments might be justifiable (e.g., correlated residuals due to item similarities). Adjustments can be specified using the “modify” argument. In this model, setting modify = “M3  N5” would reduce the χ² of the model by 1999. |  |  |  |  |  |  |  |  |

``` r


#Individual Factor Reliabilities
SD3_elf_bifac$rel
```

|  | Coefficient H | McDonald’s Omega | Average Variance Extracted (AVE) |
|:---|---:|---:|---:|
| Machiavellianism | 0.50 | 0.87 | NA |
| Narcissism | 0.67 | 0.34 | NA |
| Psychopathy | 0.51 | 0.69 | NA |
| Evil | 0.93 | 0.86 | NA |
| ^(a) Rules of thumb for reliability are H \> .7 and Omega \> .7. |  |  |  |
| ^(b) Coefficient H is the preferred reliability statistic for latent factor scores; McDonald’s Omega is the preferred reliability statistic for sum/mean scores. |  |  |  |
| ^(c) 17738 of 17738 cases were used. Listwise deletion is specified by default. If using continuous indicators, missing = “ml” can be used to handle missing values with Full Information Maximum Likelihood (not imputation). This approach is only valid if data are missing completely at random (MCAR) or missing at random (MAR), but has the advantage of yielding an “lfs” matrix with cases equal to the input data frame.When using listwise deletion, if latent factor scores and the input data frame have different numbers of rows, filter rows with missing data prior to latent factor score estimation. |  |  |  |

``` r


#Latent Factor Correlations
SD3_elf_bifac$corr
```

|  | Machiavellianism | Narcissism | Psychopathy | Evil |
|:---|---:|---:|---:|---:|
| Machiavellianism | 1.00 | -0.11 | -0.05 | 0.01 |
| Narcissism | -0.11 | 1.00 | 0.21 | 0.00 |
| Psychopathy | -0.05 | 0.21 | 1.00 | -0.01 |
| Evil | 0.01 | 0.00 | -0.01 | 1.00 |
| ^(a) Correlation matrix for all latent factors. To the extent that factors are correlated, estimation of latent factor scores will better approximate true scores than sum/mean scores. |  |  |  |  |

``` r


#Comparison to Tau-equivalent Model Assumed by Cronbach's Alpha
SD3_elf_bifac$tau
```

|  | Chi² | df | p | CFI | RMSEA | RMS_lo | RMS_hi | SRMR | ΔChi² | Δdf | Δp | ΔCFI | RMSEAᴅ |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Free Loadings | 17174.142 | 297.000 | 0.000 | 0.901 | 0.057 | 0.056 | 0.057 | 0.043 |  |  |  |  |  |
| Equal Loadings | 87476.389 | 345.000 | 0.000 | 0.488 | 0.119 | 0.119 | 0.120 | 0.246 | 70302.25 | 48 | 0 | -0.413 | 0.287 |
| ^(a) Likelihood Ratio Test comparing the tau-equivalent (i.e., equal loadings) model and the model with freely estimated loadings. If this test is not significant, sum/mean scores are recommended. If this test is significant, latent factor scores are generally recommended.However, for cases in which researchers are otherwise motivated to use sum/mean scores, a sufficiently small ΔCFI and RMSEAᴅ (i.e., close to 0) might be used to justify this decision. |  |  |  |  |  |  |  |  |  |  |  |  |  |

As before, if latent factor scores are decided on, they can be easily
extracted and attached to any dataset:

If latent factor scores are ultimately decided on, they can be easily
extracted and incorporated into a dataset (here, the original
dataframe):

``` r

head(SD3_elf_bifac$lfs, 10)
#>       Machiavellianism Narcissism Psychopathy         Evil
#>  [1,]      -0.86832037 -1.2835437 -0.59324053  0.664142004
#>  [2,]      -2.86865068 -1.7733927  1.21553096 -1.093610448
#>  [3,]       0.05496015 -1.7790123  0.09653891 -1.082214057
#>  [4,]      -0.04542044  1.8496839 -0.50546601  1.788632174
#>  [5,]      -0.05190292 -0.3505321 -1.30680433  0.252686858
#>  [6,]       0.15472905 -0.9790001  1.06460322 -0.771570526
#>  [7,]      -0.79015846 -0.4784772  0.10674231  0.509469015
#>  [8,]       0.65916346  1.8970909  0.06040592  1.188954340
#>  [9,]       0.26916445 -1.3389688  1.76933307  0.008358853
#> [10,]      -0.44362360  1.7445607  0.17154627  1.932921615

SD3_clean_bifac <- SD3_data %>%
  bind_cols(SD3_elf_bifac$lfs)
glimpse(SD3_clean_bifac)
#> Rows: 17,738
#> Columns: 33
#> $ M1               <dbl> 4, 2, 3, 5, 4, 4, 4, 5, 5, 5, 5, 5, 5, 2, 5, 4, 4, 5,…
#> $ M2               <dbl> 4, 1, 3, 5, 4, 2, 4, 5, 3, 5, 5, 4, 1, 2, 3, 5, 3, 2,…
#> $ M3               <dbl> 4, 5, 3, 4, 2, 2, 4, 5, 4, 5, 5, 4, 2, 3, 4, 4, 3, 4,…
#> $ M4               <dbl> 4, 2, 5, 5, 5, 4, 2, 5, 4, 3, 5, 3, 2, 4, 4, 5, 4, 4,…
#> $ M5               <dbl> 4, 2, 1, 5, 5, 2, 4, 5, 4, 5, 5, 5, 1, 3, 3, 4, 2, 5,…
#> $ M6               <dbl> 4, 1, 1, 5, 5, 3, 4, 5, 4, 5, 4, 5, 2, 3, 4, 4, 2, 4,…
#> $ M7               <dbl> 4, 2, 5, 5, 4, 5, 4, 5, 4, 5, 1, 5, 4, 4, 5, 5, 5, 5,…
#> $ M8               <dbl> 3, 2, 5, 5, 1, 2, 3, 4, 2, 5, 5, 3, 1, 2, 4, 4, 2, 3,…
#> $ M9               <dbl> 4, 3, 3, 5, 4, 2, 5, 5, 4, 5, 4, 5, 2, 4, 5, 5, 4, 4,…
#> $ N1               <dbl> 2, 1, 2, 5, 3, 2, 4, 4, 3, 5, 4, 5, 2, 2, 5, 3, 3, 1,…
#> $ N2               <dbl> 4, 5, 5, 1, 4, 5, 4, 1, 5, 1, 3, 2, 4, 2, 2, 4, 3, 2,…
#> $ N3               <dbl> 2, 1, 1, 5, 3, 2, 3, 5, 2, 5, 4, 5, 2, 2, 4, 2, 2, 1,…
#> $ N4               <dbl> 3, 1, 1, 5, 1, 2, 3, 5, 1, 5, 3, 5, 1, 2, 3, 4, 1, 1,…
#> $ N5               <dbl> 4, 5, 1, 5, 5, 2, 4, 5, 4, 5, 5, 3, 2, 3, 4, 5, 3, 3,…
#> $ N6               <dbl> 4, 5, 5, 1, 4, 4, 3, 1, 5, 1, 1, 1, 2, 3, 5, 5, 4, 4,…
#> $ N7               <dbl> 2, 1, 1, 5, 3, 1, 2, 4, 2, 5, 4, 4, 4, 2, 2, 5, 3, 1,…
#> $ N8               <dbl> 3, 5, 5, 1, 2, 3, 4, 1, 3, 1, 2, 1, 4, 2, 4, 4, 2, 4,…
#> $ N9               <dbl> 4, 2, 5, 5, 5, 5, 4, 5, 4, 5, 3, 5, 4, 3, 3, 3, 4, 3,…
#> $ P1               <dbl> 3, 1, 3, 5, 4, 3, 3, 2, 5, 5, 3, 4, 2, 1, 5, 2, 2, 1,…
#> $ P2               <dbl> 4, 1, 5, 1, 5, 5, 2, 5, 2, 2, 3, 2, 2, 3, 2, 2, 3, 4,…
#> $ P3               <dbl> 3, 1, 3, 5, 3, 4, 4, 2, 4, 5, 3, 2, 2, 3, 3, 2, 1, 3,…
#> $ P4               <dbl> 2, 5, 1, 2, 1, 4, 2, 5, 3, 5, 3, 1, 4, 1, 3, 1, 2, 2,…
#> $ P5               <dbl> 4, 4, 3, 5, 4, 2, 4, 5, 4, 5, 4, 5, 4, 4, 2, 2, 3, 1,…
#> $ P6               <dbl> 4, 1, 1, 5, 3, 2, 3, 5, 4, 5, 3, 5, 2, 4, 3, 1, 2, 2,…
#> $ P7               <dbl> 4, 5, 2, 5, 5, 1, 4, 2, 1, 5, 2, 2, 4, 1, 3, 5, 3, 5,…
#> $ P8               <dbl> 4, 3, 3, 1, 4, 1, 4, 5, 2, 3, 3, 1, 1, 1, 3, 1, 3, 1,…
#> $ P9               <dbl> 4, 2, 1, 5, 1, 5, 3, 3, 1, 5, 4, 1, 1, 2, 3, 1, 2, 2,…
#> $ country          <chr> "GB", "US", "US", "GB", "GB", "IT", "GB", "GB", "US",…
#> $ source           <dbl> 1, 1, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1, 3, 1, 3, 1, 3, 1,…
#> $ Machiavellianism <dbl> -0.86832037, -2.86865068, 0.05496015, -0.04542044, -0…
#> $ Narcissism       <dbl> -1.283543666, -1.773392737, -1.779012302, 1.849683890…
#> $ Psychopathy      <dbl> -0.59324053, 1.21553096, 0.09653891, -0.50546601, -1.…
#> $ Evil             <dbl> 0.664142004, -1.093610448, -1.082214057, 1.788632174,…
```
