# elfs (Evaluation and Estimation of Latent Factor Scores)

elfs provides a straightforward and user-friendly way to evaluate and
estimate latent factor scores for psychological scales (redacted for
review, 2026), attempting to lower the “barrier to entry” for
researchers considering using latent factor scores in their analyses. By
providing a data frame and a vector of column names, researchers can
generate the following output to evaluate their scale:

![](https://images.squarespace-cdn.com/content/67893cf9e677d14ec2191a2f/2164a36a-1a02-4cc2-975c-add6a5cf0f5f/BigFiveOutput.jpeg?content-type=image%2Fjpeg)

The full generated list includes these objects:

1.  **flowchart:** the primary output as depicted above
2.  **lfs:** a matrix containing estimated latent factor scores
3.  **model:** the lavaan model object
4.  **summary:** the summary of the lavaan model object, with fit
    statistics, R-squared values, and standardized scores specified
5.  **modind:** a sorted list of modification indices for the model
6.  **dynamic:** an output object from the dynamic package, if requested
7.  **fit, rel, tau, corr, meas_invar:** HTML table versions of the
    tables in flowchart from which values can be copy and pasted
8.  **model_group, lfs_group:** if measurement invariance testing is
    requested, lists containing lavaan model objects and estimated
    latent factor scores corresponding with configural, weak, strong,
    and strict invariance tests

By simplifying the inputs required to generate latent factor models and
highlighting validity and reliability indices, we hope to encourage
users to report more detailed information about their scales (beyond
Cronbach’s α) and make deliberate choices regarding their scoring
method. See the vignettes for more detail on the input options and
interpretation of the output.

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

- [`vignette("NeedforCognition")`](https://sarcyly.github.io/elfs/articles/NeedforCognition.md)
  - One-factor model
  - Measurement invariance
  - Dynamic fit indices
- [`vignette("ShortDarkTriad")`](https://sarcyly.github.io/elfs/articles/ShortDarkTriad.md)
  - Multi-factor model
  - Ordinal measured variables
  - Bi-factor model

## Credits and References

\[REDACTED\]. (2026). *elfs: An R Package to Promote the Intentional
Selection of Scoring Method for Psychological Scales* \[Manuscript in
preparation\].

Hex sticker design: \[REDACTED\] & [Marianne
Oyama](https://marianneoyama.com/)  
Hex sticker illustration: [Marianne Oyama](https://marianneoyama.com/)
