library("exams")

template <- system.file("xml", "ilias.xml", package = "exams")
stopifnot(nchar(template) > 0L)

dir.create(mydir <- tempfile())

read_zip_xml <- function(zipfile, member) {
  readLines(unz(zipfile, member), warn = FALSE)
}

## non-placeholder cloze export
exams2ilias(system.file("exercises/lm.Rmd", package = "exams"),
  n = 1, dir = mydir, name = "lm_ilias", template = template, xmlcollapse = FALSE)
lm_zip <- file.path(mydir, "lm_ilias_qpl.zip")
stopifnot(file.exists(lm_zip))
lm_qti <- read_zip_xml(lm_zip, "lm_ilias_qpl/lm_ilias_qti.xml")
lm_qpl <- read_zip_xml(lm_zip, "lm_ilias_qpl/lm_ilias_qpl.xml")
stopifnot(!any(grepl("<assessment", lm_qti, fixed = TRUE)))
stopifnot(!any(grepl("<section", lm_qti, fixed = TRUE)))
stopifnot(any(grepl("<fieldentry>CLOZE QUESTION</fieldentry>", lm_qti, fixed = TRUE)))
stopifnot(any(grepl('<response_str ident="gap_0"', lm_qti, fixed = TRUE)))
stopifnot(any(grepl('<response_num ident="gap_1"', lm_qti, fixed = TRUE)))
stopifnot(any(grepl("<fieldlabel>textgaprating</fieldlabel>", lm_qti, fixed = TRUE)))
stopifnot(!any(grepl("<fieldlabel>AUTHOR</fieldlabel>", lm_qti, fixed = TRUE)))
stopifnot(!any(grepl("<fieldlabel>fixedTextLength</fieldlabel>", lm_qti, fixed = TRUE)))
stopifnot(!any(grepl("<itemfeedback", lm_qti, fixed = TRUE)))
stopifnot(any(grepl('minnumber="', lm_qti, fixed = TRUE)))
stopifnot(!any(grepl('minnumber="([^"]+)" maxnumber="\\1"', lm_qti, perl = TRUE)))
stopifnot(any(grepl('<Question QRef="il_0_qst_', lm_qpl, fixed = TRUE)))

## placeholder-based cloze export
exams2ilias(system.file("exercises/vowels.Rmd", package = "exams"),
  n = 1, dir = mydir, name = "vowels_ilias", template = template, xmlcollapse = FALSE)
vowels_zip <- file.path(mydir, "vowels_ilias_qpl.zip")
stopifnot(file.exists(vowels_zip))
vowels_qti <- read_zip_xml(vowels_zip, "vowels_ilias_qpl/vowels_ilias_qti.xml")
stopifnot(!any(grepl("<assessment", vowels_qti, fixed = TRUE)))
stopifnot(any(grepl('<response_str ident="gap_5"', vowels_qti, fixed = TRUE)))
stopifnot(any(grepl('<mattext texttype="text/xhtml"> </mattext>', vowels_qti, fixed = TRUE)))
stopifnot(!any(grepl("<itemfeedback", vowels_qti, fixed = TRUE)))

## standard multiple-choice export should also use top-level items
exams2ilias(system.file("exercises/ttest.Rmd", package = "exams"),
  n = 1, dir = mydir, name = "ttest_ilias", template = template, xmlcollapse = FALSE)
ttest_zip <- file.path(mydir, "ttest_ilias_qpl.zip")
stopifnot(file.exists(ttest_zip))
ttest_qti <- read_zip_xml(ttest_zip, "ttest_ilias_qpl/ttest_ilias_qti.xml")
stopifnot(!any(grepl("<assessment", ttest_qti, fixed = TRUE)))
stopifnot(!any(grepl("<section", ttest_qti, fixed = TRUE)))
stopifnot(any(grepl("<fieldentry>MULTIPLE CHOICE QUESTION</fieldentry>", ttest_qti, fixed = TRUE)))
