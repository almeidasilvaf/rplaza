
# Start tests ----
test_that("get_annotation() loads ranges as GRanges/GRangesList", {
    
    sp <- c("mco", "cre")
    ranges1 <- get_annotation(sp, transcripts = "longest", features = "exons")
    ranges2 <- get_annotation(sp[1], transcripts = "all", features = "all")
    
    expect_true(is(ranges1, "GRangesList"))
    expect_true(is(ranges2, "GRanges"))
})