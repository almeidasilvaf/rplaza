
# Start tests ----
test_that("get_functional_annotation() returns a data frame", {
    
    fannot1 <- get_functional_annotation("ota", ontology = "GO")
    fannot2 <- get_functional_annotation(c("ota", "lpe"), ontology = "InterPro")
    fannot3 <- get_functional_annotation("ota", ontology = "MapMan")
    
    expect_equal(class(fannot1), "data.frame")
    expect_equal(class(fannot2), "list")
    expect_equal(class(fannot3), "data.frame")
    expect_error(get_functional_annotation("ath", ontology = "error"))
    expect_error(get_functional_annotation("Ath", ontology = "InterPro"))
})
