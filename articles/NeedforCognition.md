# Need for Cognition Example Dataset

## Introduction

The following vignette showcases the use of
[`elfs()`](https://sarcyly.github.io/elfs/reference/elfs.md) when
applied to data from the Need for Cognition scale (Cacioppo & Petty,
1982), using data collected and originally analyzed by Hussey and Hughes
(2020). First, the dataset is loaded.

``` r

library(elfs)
library(dplyr)
library(magrittr)

nfc_data <- elfs::NeedforCognition_HusseyHughes_data
```

### One-factor Model

For our first model, we conduct the most simplistic model on the scale
(all 18 items load onto the same factor).

``` r

nfc_elf <- elfs(data = nfc_data,
                f1_cols = starts_with("nfc"), f1_name = "NeedforCognition",
                chrome_bypass = T)
```

The resulting
[`elfs()`](https://sarcyly.github.io/elfs/reference/elfs.md) output
contains information about your fitted model. By initiating specific
calls, you can output information regarding:

``` r

#Model Fit
nfc_elf$fit
```

|  | Chi² | df | p | CFI | RMSEA | RMSEA_lo | RMSEA_hi | SRMR |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Model | 4110.060 | 135.000 | 0.000 | 0.894 | 0.067 | 0.065 | 0.068 | 0.047 |
| ^(a) Example text for reporting: The fit statistics for the estimated latent variable model are: χ²( 135.000) = 4110.060, p \< .001, CFI = 0.894, RMSEA = 0.067 (90% CI\[ 0.065, 0.068\]), SRMR = 0.047. |  |  |  |  |  |  |  |  |
| ^(b) At minimum, report the CFI, RMSEA, and SRMR in your manuscript. To evaluate fit, Dynamic Fit Indices (McNeish & Wolf, 2023) are recommended. Reference the ‘dynamic’ object in the output list for output or for information about how to install this package. |  |  |  |  |  |  |  |  |
| ^(c) If ordered = TRUE or missing = “ml”, robust CFI and RMSEA values are given above. |  |  |  |  |  |  |  |  |
| ^(d) Modification indices (in the “modind” object) can be referenced to understand which parameters might be freed in the model to improve model fit. A data-driven approach to improving fit is generally not recommended for existing scales, but some adjustments might be justifiable (e.g., correlated residuals due to item similarities). Adjustments can be specified using the “modify” argument. In this model, setting modify = “nfc1  nfc13” would reduce the χ² of the model by 384. |  |  |  |  |  |  |  |  |

``` r


#Individual Factor Reliabilities
nfc_elf$rel
```

|  | Coefficient H | McDonald’s Omega | Average Variance Extracted (AVE) |
|:---|---:|---:|---:|
| NeedforCognition | 0.9 | 0.89 | 0.32 |
| ^(a) Rules of thumb for reliability are H \> .7 and Omega \> .7. |  |  |  |
| ^(b) Coefficient H is the preferred reliability statistic for latent factor scores; McDonald’s Omega is the preferred reliability statistic for sum/mean scores. |  |  |  |
| ^(c) 6649 of 6649 cases were used. Listwise deletion is specified by default. If using continuous indicators, missing = “ml” can be used to handle missing values with Full Information Maximum Likelihood (not imputation). This approach is only valid if data are missing completely at random (MCAR) or missing at random (MAR), but has the advantage of yielding an “lfs” matrix with cases equal to the input data frame.When using listwise deletion, if latent factor scores and the input data frame have different numbers of rows, filter rows with missing data prior to latent factor score estimation. |  |  |  |

``` r


#Latent Factor Correlations
nfc_elf$corr
```

|  | NeedforCognition |
|:---|---:|
| NeedforCognition | 1 |
| ^(a) Correlation matrix for all latent factors. To the extent that factors are correlated, estimation of latent factor scores will better approximate true scores than sum/mean scores. |  |

``` r


#Comparison to Tau-equivalent Model Assumed by Cronbach's Alpha
nfc_elf$tau
```

|  | Chi² | df | p | CFI | RMSEA | RMS_lo | RMS_hi | SRMR | ΔChi² | Δdf | Δp | ΔCFI | RMSEAᴅ |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Free Loadings | 4110.060 | 135.000 | 0.000 | 0.894 | 0.067 | 0.065 | 0.068 | 0.047 |  |  |  |  |  |
| Equal Loadings | 5939.161 | 153.000 | 0.000 | 0.845 | 0.075 | 0.074 | 0.077 | 0.300 | 1829.1 | 18 | 0 | -0.049 | 0.123 |
| ^(a) Likelihood Ratio Test comparing the tau-equivalent (i.e., equal loadings) model and the model with freely estimated loadings. If this test is not significant, sum/mean scores are recommended. If this test is significant, latent factor scores are generally recommended.However, for cases in which researchers are otherwise motivated to use sum/mean scores, a sufficiently small ΔCFI and RMSEAᴅ (i.e., close to 0) might be used to justify this decision. |  |  |  |  |  |  |  |  |  |  |  |  |  |

If latent factor scores are ultimately decided on, they can be easily
extracted and incorporated into a dataset (here, the original
dataframe):

``` r

head(nfc_elf$lfs, 10)
#>       NeedforCognition
#>  [1,]        0.6254162
#>  [2,]        0.9601112
#>  [3,]        0.7459077
#>  [4,]        0.3976529
#>  [5,]        0.8550442
#>  [6,]       -2.2095997
#>  [7,]        1.7841862
#>  [8,]        1.4903356
#>  [9,]        0.8083299
#> [10,]        1.3583262

nfc_clean <- nfc_data %>%
  bind_cols(nfc_elf$lfs)
glimpse(nfc_clean)
#> Rows: 6,649
#> Columns: 26
#> $ user_id                          <int> 450, 1563, 1990, 6833, 7457, 7518, 88…
#> $ session_id                       <dbl> 212593, 340349, 344216, 285714, 34645…
#> $ datetime_ymdhms                  <dttm> 2005-04-22 22:25:16, 2006-01-24 14:5…
#> $ age                              <dbl> 41, 21, 21, 53, 25, 55, 42, 50, 24, 5…
#> $ sex                              <chr> "m", "f", "f", "f", "m", "m", "f", "f…
#> $ individual_differences_measure   <fct> "NFC", "NFC", "NFC", "NFC", "NFC", "N…
#> $ individual_differences_sum_score <dbl> 88, 94, 91, 84, 92, 50, 108, 102, 92,…
#> $ nfc1                             <dbl> 3, 4, 5, 5, 6, 4, 6, 5, 6, 6, 3, 5, 6…
#> $ nfc2                             <dbl> 5, 6, 5, 6, 5, 4, 6, 6, 6, 6, 4, 5, 6…
#> $ nfc3                             <dbl> 6, 5, 5, 5, 6, 2, 6, 6, 5, 6, 4, 5, 6…
#> $ nfc4                             <dbl> 6, 6, 6, 5, 6, 4, 6, 6, 6, 6, 4, 5, 6…
#> $ nfc5                             <dbl> 5, 6, 6, 4, 5, 2, 6, 6, 6, 6, 3, 4, 6…
#> $ nfc6                             <dbl> 3, 4, 5, 4, 5, 1, 6, 5, 6, 6, 3, 3, 6…
#> $ nfc7                             <dbl> 6, 6, 6, 6, 5, 2, 6, 6, 5, 6, 3, 5, 6…
#> $ nfc8                             <dbl> 5, 6, 6, 3, 3, 2, 6, 5, 5, 6, 2, 5, 4…
#> $ nfc9                             <dbl> 5, 6, 5, 3, 4, 4, 6, 6, 5, 6, 3, 3, 3…
#> $ nfc10                            <dbl> 6, 6, 5, 6, 6, 3, 6, 6, 6, 6, 5, 4, 5…
#> $ nfc11                            <dbl> 6, 6, 5, 6, 4, 2, 6, 6, 6, 6, 4, 5, 4…
#> $ nfc12                            <dbl> 6, 6, 6, 6, 6, 2, 6, 6, 1, 1, 4, 5, 6…
#> $ nfc13                            <dbl> 5, 4, 5, 5, 6, 2, 6, 6, 6, 6, 3, 5, 6…
#> $ nfc14                            <dbl> 2, 4, 5, 3, 6, 3, 6, 5, 5, 6, 4, 2, 6…
#> $ nfc15                            <dbl> 6, 4, 5, 5, 5, 4, 6, 6, 6, 6, 4, 3, 6…
#> $ nfc16                            <dbl> 6, 5, 1, 5, 5, 2, 6, 6, 1, 6, 3, 5, 4…
#> $ nfc17                            <dbl> 6, 6, 4, 5, 5, 5, 6, 6, 6, 6, 4, 4, 5…
#> $ nfc18                            <dbl> 1, 4, 6, 2, 4, 2, 6, 4, 5, 6, 4, 4, 6…
#> $ NeedforCognition                 <dbl> 0.62541617, 0.96011116, 0.74590775, 0…
```

### Measurement Invariance

This simple model can be expanded, firstly by testing for measurement
invariance. Within `nfc_data`, “sex” is a binary variable denoting the
sex of the participant. Separate models for each group can be run using
the following:

``` r

nfc_invar <- elfs(data = nfc_data,
                  f1_cols = starts_with("nfc"), f1_name = "NeedforCognition",
                  meas_invar = "sex",
                  chrome_bypass = T)
```

The resulting information regarding measurement invariance can be
viewed:

``` r

#Raw model
nfc_invar$group_models
#> [[1]]
#> lavaan 0.7-2 ended normally after 32 iterations
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                       108
#> 
#>   Number of observations per group:                   
#>     m                                             2340
#>     f                                             4309
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                              4136.669
#>   Degrees of freedom                               270
#>   P-value (Chi-square)                           0.000
#>   Test statistic for each group:
#>     m                                         1653.539
#>     f                                         2483.130
#> 
#> [[2]]
#> lavaan 0.7-2 ended normally after 45 iterations
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                       109
#>   Number of equality constraints                    18
#> 
#>   Number of observations per group:                   
#>     m                                             2340
#>     f                                             4309
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                              4212.952
#>   Degrees of freedom                               287
#>   P-value (Chi-square)                           0.000
#>   Test statistic for each group:
#>     m                                         1704.928
#>     f                                         2508.023
#> 
#> [[3]]
#> lavaan 0.7-2 ended normally after 69 iterations
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                       110
#>   Number of equality constraints                    36
#> 
#>   Number of observations per group:                   
#>     m                                             2340
#>     f                                             4309
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                              4557.487
#>   Degrees of freedom                               304
#>   P-value (Chi-square)                           0.000
#>   Test statistic for each group:
#>     m                                         1942.722
#>     f                                         2614.765
#> 
#> [[4]]
#> lavaan 0.7-2 ended normally after 68 iterations
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                       110
#>   Number of equality constraints                    54
#> 
#>   Number of observations per group:                   
#>     m                                             2340
#>     f                                             4309
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                              4660.356
#>   Degrees of freedom                               322
#>   P-value (Chi-square)                           0.000
#>   Test statistic for each group:
#>     m                                         2006.437
#>     f                                         2653.919

#Table summary
nfc_invar$meas_invar
```

|  | Chi² | df | p | CFI | RMSEA | RMS_lo | RMS_hi | SRMR | ΔChi² | Δdf | Δp | ΔCFI | RMSEAᴅ |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Config | 4136.669 | 270.000 | 0.000 | 0.896 | 0.066 | 0.064 | 0.067 | 0.044 |  |  |  |  |  |
| Weak | 4212.952 | 287.000 | 0.000 | 0.894 | 0.064 | 0.062 | 0.066 | 0.047 | 76.28 | 17 | 0 | -0.002 | 0.032 |
| Strong | 4557.487 | 304.000 | 0.000 | 0.885 | 0.065 | 0.063 | 0.067 | 0.048 | 344.53 | 17 | 0 | -0.009 | 0.076 |
| Strict | 4660.356 | 322.000 | 0.000 | 0.883 | 0.064 | 0.062 | 0.065 | 0.050 | 102.87 | 18 | 0 | -0.002 | 0.038 |
| ^(a) Measurement Invariance for sex. Guidelines for evaluating measurement invariance differ, but a few guidelines are given below. See Putnick & Bornstein (2016) for details as well as more information about partial invariance and probing items for sources of non-invariance. |  |  |  |  |  |  |  |  |  |  |  |  |  |
| ^(b) If LRT tests (i.e., ΔChi²) are not significant, measurement invariance has been demonstrated. However, this test is conservative. |  |  |  |  |  |  |  |  |  |  |  |  |  |
| ^(c) ΔCFI \> -.01 and RMSEAᴅ \< .08 can be interpreted as evidence of measurement invariance. |  |  |  |  |  |  |  |  |  |  |  |  |  |

If desired, individual latent factor scores can be extracted for each
group.

``` r

#Scores for sex = "m"
head(nfc_invar$group_lfs[[1]]$m, 10)
#>       NeedforCognition
#>  [1,]        0.5757513
#>  [2,]        0.7649959
#>  [3,]       -2.3894930
#>  [4,]        0.7364659
#>  [5,]        1.5577730
#>  [6,]       -2.0759492
#>  [7,]       -0.1712129
#>  [8,]        0.4317961
#>  [9,]        1.7070322
#> [10,]        1.4100098

#Scores for sex = "f"
head(nfc_invar$group_lfs[[1]]$f, 10)
#>       NeedforCognition
#>  [1,]        1.0056456
#>  [2,]        0.8089156
#>  [3,]        0.4524888
#>  [4,]        1.8314627
#>  [5,]        1.5352350
#>  [6,]        0.8781406
#>  [7,]        1.4196316
#>  [8,]       -1.1310355
#>  [9,]       -0.1579546
#> [10,]        1.2107396
```

### Dynamic Fit Indices (McNeish & Wolf, 2023)

Finally, dynamic fit indices can also be requested:

``` r

nfc_dynamic <- elfs(data = nfc_data,
                    f1_cols = starts_with("nfc"), f1_name = "NeedforCognition",
                    dynamic = T,
                    chrome_bypass = T)
```

Resultant information about updated model cutoffs can be displayed:

``` r

nfc_dynamic$dynamic
#> Your DFI cutoffs: 
#>             MAD   Sim. MAD CFI   RMSEA 90% CI
#> Consistent  0.00  0.00     0.999 0.006 0.009 
#> Specificity                95%   95%         
#>                                              
#> Close       0.038 0.036    0.933 0.052 0.053 
#> Sensitivity                95%   95%         
#>                                              
#> Fair        0.05  0.047    0.891 0.067 0.069 
#> Sensitivity                95%   95%         
#>                                              
#> Mediocre    0.06  0.057    0.848 0.082 0.084 
#> Sensitivity                95%   95%         
#> 
#> Estimator: ML 
#> Sample Size: 6649 
#> 
#> Empirical fit indices: 
#>  Chi-Square  df p-value   SRMR    CFI   RMSEA RMSEA 90% CI
#>     4110.06 135       0  0.047  0.894   0.067        0.068
#> 
#>  Notes:
#>   -'Sensitivity' is % of incorrect models identified by cutoff while rejecting <5% of correct models
#>   - If sensitivity is <50%, cutoffs will be supressed
#> 
#>   -'90% CI' column is RMSEA cutoff, including sampling variability
#>   - Only compare upper limit of 90% RMSEA confidence interval to '90% CI' column
#>   - Do not compare RMSEA point estimate to '90% CI' column
#> 
#>   -'MAD' is the desired mean absolute discrepancy
#>   -'Sim. MAD' is the MAD that was achieved in the simulations
#>   - Values may diff when avoiding non-positive definite matrices
#> 
```
