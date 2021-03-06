

# Convert Lung Vol --------------------------------------------------------


#' Convert Lung Volume from ATPS to BTPS
#'
#' This function converts several lung volume parameters at ATPS (Ambient Temperature and Pressure Saturated) to
#' BTPS (Body Temperature, Pressure, water vapor Saturated).
#'
#' @param FEV1 (numeric) Forced Expiratory Volume in 1 second (L).
#' @param FVC (numeric) Forced Vital Capacity (L)
#' @param PEF (numeric) Peak Expiratory Flow (L/min)
#' @param TV (numeric) Tidal Volume (L)
#' @param IC (numeric) Inspiratory Capacity (L)
#' @param EC (numeric) Expiratory Capacity (L)
#' @param VC (numeric) Vital Capacity (L)
#'
#' @return A Tibble
#' @export
#'
#' @examples
#' lung_vol_atps_btps(FEV1 = 5, FVC = 10, PEF = 4, TV = 9, IC = 10, EC = 12, VC = 10)
lung_vol_atps_btps <- function(FEV1 = NA,
                               FVC = NA,
                               PEF = NA,
                               TV = NA,
                               IC = NA,
                               EC = NA,
                               VC = NA
                               ) {

  # Validate Lung Volume that VC ≥ IC ≥ TV and EC ≥ TV
  valid_lung_vol <- all((VC >= IC), (IC >= TV), (EC >= TV), na.rm = TRUE)
  if(!valid_lung_vol) stop("Not a valid lung volumn.", call. = FALSE)

  atps_val <- c(FEV1 = FEV1,
                FVC = FVC,
                `FEV1/FVC` = FEV1*100/FVC,
                PEF = PEF,
                TV = TV,
                IC = IC,
                IRV = IC - TV,
                EC = EC,
                ERV = EC - TV,
                VC = VC)
  unit <- c(rep("L", 2), "%", "L/min", rep("L", 6))

  atps_val %>%
    tibble::enframe("Parameter", "ATPS") %>%
    # Compute BTPS & Add Unit
    dplyr::mutate(BTPS = sapply(ATPS, get_btps_factor),
                  Unit = unit)

}


# Get BTPS factor ---------------------------------------------------------


#' Get BTPS Correction factor
#'
#' Compute correction factor to convert gas volumes from room temperature saturated to BTPS, assuming that gas was sampled at barometric pressure of 760 mmHg.
#'
#' @param temp (Numeric) Room Temperature when gas was collected.
#'
#' @return A numeric factor to convert volume of gas to 37 celsius saturated
#' @export
#'
#' @examples
#' # If temp in lookup table, simply use BTPS Correction factor from the table
#' get_btps_factor(20)
#' # If temp not in lookup table, use prediction by linear model.
#' get_btps_factor(20.5)
get_btps_factor <- function(temp) {

  ## Validate Input
  not_valid <- !(length(temp) == 1L && is.numeric(temp))
  if(not_valid) stop("`temp` must be a numeric vector of length 1.", call. = FALSE)

  ## If `temp` in lookup table
  if(temp %in% btps_df[["Gas_temp_c"]]){

    # Use `Factor_37` from lookup table
    factor_37_lookup <- btps_df[btps_df[["Gas_temp_c"]] == temp, ][["Factor_37"]]
    return(factor_37_lookup)

  }else{
    ## If not, fit linear model of `Factor_37` on `Gas_temp_c` and then predict
    lm_fit <- lm(Factor_37 ~ Gas_temp_c, data = btps_df)
    newpoint <- data.frame(Gas_temp_c = temp)

    factor_37_pred <- unname(predict(lm_fit, newdata = newpoint, interval = "none"))
    return(factor_37_pred)

  }

}


#' BTPS Correction factor Lookup Table
#'
#' A data frame that has 2 columns:
#'
#'
#'
#' @format A data frame that has 2 columns:
#' * \strong{Gas_temp_c}: Gas temperature in celsius
#' * \strong{Factor_37}: factor to convert volume of gas to 37 celsius saturated
"btps_df"
