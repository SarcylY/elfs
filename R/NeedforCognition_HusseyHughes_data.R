#' Hussey & Hughes (2020) Need for Cognition Data Subset
#'
#' A subset of data by Hussey and Hughes (2020) investigating the Need for Cognition
#' scale (Cacioppo, Petty, & Kao, 1984).
#'
#' @format ## `NeedforCognition_HusseyHughes_data`
#' A data frame with 6,649 rows and 25 columns:
#' \describe{
#'   \item{user_id}{Unique participant ID for each participant}
#'   \item{session_id}{Unique session ID for each participant}
#'   \item{datetime_ymdhms}{Study completion timestamp}
#'   \item{age}{Participant age}
#'   \item{sex}{Participant sex ('m' or 'f')}
#'   \item{individual_differences_measure}{indicating which scale is measured (all filtered to 'NFC')}
#'   \item{individual_differences_sum_score}{Sum score for Need for Cognition scale}
#'   \item{nfc1, nfc2, nfc3, nfc4, nfc5, nfc6, nfc7, nfc8, nfc9, nfc10, nfc11, nfc12, nfc13, nfc14, nfc15, nfc16, nfc17, nfc18}{scores for each of the 18 items on Need for Cognition (range: 1-6)}
#' }
#' @source <https://journals.sagepub.com/doi/10.1177/2515245919882903>
"NeedforCognition_HusseyHughes_data"
