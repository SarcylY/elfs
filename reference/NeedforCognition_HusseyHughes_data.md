# Hussey & Hughes (2020) Need for Cognition Data Subset

A subset of data by Hussey and Hughes (2020) investigating the Need for
Cognition scale (Cacioppo, Petty, & Kao, 1984).

## Usage

``` r
NeedforCognition_HusseyHughes_data
```

## Format

### `NeedforCognition_HusseyHughes_data`

A data frame with 6,649 rows and 25 columns:

- user_id:

  Unique participant ID for each participant

- session_id:

  Unique session ID for each participant

- datetime_ymdhms:

  Study completion timestamp

- age:

  Participant age

- sex:

  Participant sex ('m' or 'f')

- individual_differences_measure:

  indicating which scale is measured (all filtered to 'NFC')

- individual_differences_sum_score:

  Sum score for Need for Cognition scale

- nfc1, nfc2, nfc3, nfc4, nfc5, nfc6, nfc7, nfc8, nfc9, nfc10, nfc11,
  nfc12, nfc13, nfc14, nfc15, nfc16, nfc17, nfc18:

  scores for each of the 18 items on Need for Cognition (range: 1-6)

## Source

<https://journals.sagepub.com/doi/10.1177/2515245919882903>
