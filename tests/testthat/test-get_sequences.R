


# Start tests ----
test_that("get_genome() reads a genome as a DNAStringSet object", {
    
    ## 1 genome
    seq1 <- get_genome("ota")
    
    ## 2 genomes
    seq2 <- get_genome(c("ota", "orcc809"))
    
    expect_true(is(seq1, "DNAStringSet"))
    expect_true(is(seq2, "list"))
    expect_true(is(seq2[[1]], "DNAStringSet"))
})


test_that("get_sequences() reads sequences for particular loci", {
    
    # 1 species
    seq1 <- get_sequences("ota", type = "CDS", transcripts = "all") 
    
    # 2 species
    seq2 <- get_sequences(
        c("ota", "orcc809"), type = "protein", transcripts = "longest"
    )
    
    expect_true(is(seq1, "DNAStringSet"))
    expect_true(is(seq2, "list"))
    expect_true(is(seq2[[1]], "AAStringSet"))
    
    expect_error(get_sequences("ath", type = "error"))
    expect_error(get_sequences("ath", transcripts = "error"))
})

