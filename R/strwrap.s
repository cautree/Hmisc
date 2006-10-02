if(!exists('strwrap')) {
  strwrap <- function (x, width = 0.9 * getOption("width"), indent = 0, exdent = 0,
                       prefix = "", simplify = TRUE) {
    indentString <- paste(rep.int(" ", indent), collapse = "")
    exdentString <- paste(rep.int(" ", exdent), collapse = "")
    y <- list()
    z <- lapply(strsplit(x, "\n[ \t\n]*\n"), strsplit, "[ \t\n]")
    for (i in seq(along = z)) {
      yi <- character(0)
      for (j in seq(along = z[[i]])) {
        words <- z[[i]][[j]]
        nc <- nchar(words, type = "w")
        if (any(is.na(nc))) {
          nc0 <- nchar(words)
          nc[is.na(nc)] <- nc0[is.na(nc)]
        }
        if (any(nc == 0)) {
          zLenInd <- which(nc == 0)
          zLenInd <- zLenInd[!(zLenInd %in% (grep("\\.$",
                                                  words) + 1))]
          if (length(zLenInd) > 0) {
            words <- words[-zLenInd]
            nc <- nc[-zLenInd]
          }
        }
        if (length(words) == 0) {
          yi <- c(yi, "", prefix)
          next
        }
        currentIndex <- 0
        lowerBlockIndex <- 1
        upperBlockIndex <- integer(0)
        lens <- cumsum(nc + 1)
        first <- TRUE
        maxLength <- width - nchar(prefix, type = "w") -
          indent
        while (length(lens) > 0) {
          k <- max(sum(lens <= maxLength), 1)
          if (first) {
            first <- FALSE
            maxLength <- maxLength + indent - exdent
          }
          currentIndex <- currentIndex + k
          if (nc[currentIndex] == 0)
            upperBlockIndex <- c(upperBlockIndex, currentIndex -
                                 1)
          else upperBlockIndex <- c(upperBlockIndex, currentIndex)
          if (length(lens) > k) {
            if (nc[currentIndex + 1] == 0) {
              currentIndex <- currentIndex + 1
              k <- k + 1
            }
            lowerBlockIndex <- c(lowerBlockIndex, currentIndex +
                                 1)
          }
          if (length(lens) > k)
            lens <- lens[-(1:k)] - lens[k]
          else lens <- NULL
        }
        nBlocks <- length(upperBlockIndex)
        s <- paste(prefix, c(indentString, rep.int(exdentString,
                                                   nBlocks - 1)), sep = "")
        for (k in (1:nBlocks)) s[k] <- paste(s[k], paste(words[lowerBlockIndex[k]:upperBlockIndex[k]],
                                                         collapse = " "), sep = "")
        yi <- c(yi, s, prefix)
      }
      y <- c(y, list(yi[-length(yi)]))
    }
    if (simplify)
      y <- unlist(y)
    y
  }
}
