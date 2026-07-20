
<!-- README.md is generated from README.Rmd. Please edit that file -->

# elfs (Evaluation and Estimation of Latent Factor Scores)

<!-- badges: start -->

<!-- badges: end -->

elfs provides a straightforward and user-friendly way to evaluate and
estimate latent factor scores for psychological scales (Hester et al.,
2026), attempting to lower the “barrier to entry” for researchers
considering using latent factor scores in their analyses. By providing a
data frame and a vector of column names, researchers can generate the
following output to evaluate their scale:

![](https://images.squarespace-cdn.com/content/67893cf9e677d14ec2191a2f/2164a36a-1a02-4cc2-975c-add6a5cf0f5f/BigFiveOutput.jpeg?content-type=image%2Fjpeg)

## Installation

You can install the development version of elfs from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("SarcylY/elfs")
```

or

``` r
# install.packages("devtools")
devtools::install_github("SarcylY/elfs")
```

## Example

For detailed examples (and example output), please refer to our
vignettes below (depending on the kind of model desired):

- `vignette("NeedforCognition")`
  - One-factor model
  - Measurement invariance
  - Dynamic fit indices
- `vignette("ShortDarkTriad")`
  - Multi-factor model
  - Ordinal measured variables
  - Bi-factor model

## References

\[REDACTED\]. (2026). *elfs: An R Package to Promote the Intentional
Selection of Scoring Method for Psychological Scales* \[Manuscript in
preparation\].
