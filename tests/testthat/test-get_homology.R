

# Start tests ----
test_that("get_block_duplicates() returns a (list of) data frame(s)", {
    
    sd <- get_block_duplicates("lpe")
    sd2 <- get_block_duplicates(c("lpe", "ota"))
    
    expect_equal(class(sd), "data.frame")
    expect_equal(class(sd2), "list")
})

test_that("get_family_assignments() returns a (list of) data frame(s)", {
    
    fams <- get_family_assignments("Diatoms", type = "ortho")
    
    expect_error(get_family_assignments("DICOTS"))
    expect_equal(class(fams), "data.frame")
})


test_that("get_family_functions() returns a (list of) data frames", {
    
    fam_func <- get_family_functions("Dicots", type = "ortho")
    
    expect_equal(class(fam_func), "data.frame")
    expect_error(get_family_functions(instance = "Diatoms"))
    
})
