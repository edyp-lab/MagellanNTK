#' @title This function exports a data.frame to a Excel file.
#'
#' @description
#' This is the default function fo export the current dataset as an Excel file.
#'
#'
#' @param df A list of data.frame() items
#' @param colors xxx
#' @param tags xxx
#' @param filename A character string for the name of the Excel file.
#'
#' @return A Excel file (.xlsx)
#'
#' @author Samuel Wieczorek
#'
#' @export
#'
#'
#' @examples
#' data(lldata)
#' write.excel(lldata, filename = "foo.xlsx")
#'
write.excel <- function(
        df,
        colors,
        tags,
        filename = NULL) {
    pkgs.require(c("openxlsx", "tools"))

    if (is.null(filename)) {
        filename <- paste("data-", Sys.Date(), ".xlxs", sep = "")
    } else if (tools::file_ext(filename) != "") {
        if (tools::file_ext(filename) != "xlsx") {
            stop("Filename extension must be equal to 'xlsx'. Abort...")
        } else {
            fname <- filename
        }
    } else {
        fname <- paste(filename, ".xlsx", sep = "")
    }

    wb <- openxlsx::createWorkbook(fname)

    lapply(names(df), function(x) {
        openxlsx::addWorksheet(wb, x)
        openxlsx::writeData(wb, sheet = x, df, rowNames = FALSE)
    })

    openxlsx::saveWorkbook(wb, fname, overwrite = TRUE)
}
