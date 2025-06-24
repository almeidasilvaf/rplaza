

# Start tests ----
test_that("get_tx2gene() returns a data frame of 2 columns", {
    
    df1 <- get_tx2gene("ota", transcripts = "all")
    df2 <- get_tx2gene(c("ota", "sro"), transcripts = "longest")
    
    expect_equal(names(df1), c("transcript_id", "gene_id"))
    expect_equal(class(df1), "data.frame")
    expect_equal(class(df2), "list")
    expect_error(get_tx2gene("ath", transcripts = "error"))
})


test_that("get_descriptions() returns a data frame of 2 columns", {
    
    df1 <- get_descriptions("ota")
    df2 <- get_descriptions(c("ota", "lpe"))
    
    expect_equal(class(df1), "data.frame")
    expect_equal(class(df2[[1]]), "data.frame")
    expect_equal(class(df2), "list")
})


test_that("get_id_conversions() returns a data frame of 2 columns", {
    
    df1 <- get_id_conversions("ota")
    df2 <- get_id_conversions(c("ota", "lpe"))
    
    expect_equal(class(df1), "data.frame")
    expect_equal(class(df2[[1]]), "data.frame")
    expect_equal(class(df2), "list")
})
