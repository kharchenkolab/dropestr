library(dropestr)
library(testthat)

test_that("Center() tests", {
	expect_equal(Center(data.frame(x=c(1, 2, 3), y=c(0, 25, 100)))$x[1], -1)
	expect_equal(Center(data.frame(x=c(1, 2, 3), y=c(0, 25, 100)))$x[2], 0)
	expect_equal(Center(data.frame(x=c(1, 2, 3), y=c(0, 25, 100)))$x[3], 1)
	expect_equal(round(Center(data.frame(x=c(1, 2, 3), y=c(0, 25, 100)))$y[1]), -42)
	expect_equal(round(Center(data.frame(x=c(1, 2, 3), y=c(0, 25, 100)))$y[2]), -17)
	expect_equal(round(Center(data.frame(x=c(1, 2, 3), y=c(0, 25, 100)))$y[3]), 58)
})


test_that("Normalize() tests", {
	expect_equal(as.data.frame(Normalize(data.frame(x=c(1, 2, 3), y=c(0, 25, 100))))$x[1], 1)
	expect_equal(as.data.frame(Normalize(data.frame(x=c(1, 2, 3), y=c(0, 25, 100))))$x[2], 2)
	expect_equal(as.data.frame(Normalize(data.frame(x=c(1, 2, 3), y=c(0, 25, 100))))$x[3], 3)
	expect_equal(as.data.frame(Normalize(data.frame(x=c(1, 2, 3), y=c(0, 25, 100))))$y[1], 0)
	expect_equal(round(as.data.frame(Normalize(data.frame(x=c(1, 2, 3), y=c(0, 25, 100))))$y[2], 1), 0.5)
	expect_equal(round(as.data.frame(Normalize(data.frame(x=c(1, 2, 3), y=c(0, 25, 100))))$y[3], 1), 1.9)
})


test_that("Scale() tests", {
	expect_equal(Scale(data.frame(x=c(1, 2, 3), y=c(0, 25, 100)))$x[1], 0)
	expect_equal(Scale(data.frame(x=c(1, 2, 3), y=c(0, 25, 100)))$x[2], 0.5)
	expect_equal(Scale(data.frame(x=c(1, 2, 3), y=c(0, 25, 100)))$x[3], 1)
	expect_equal(Scale(data.frame(x=c(1, 2, 3), y=c(0, 25, 100)))$y[1], 0)
	expect_equal(Scale(data.frame(x=c(1, 2, 3), y=c(0, 25, 100)))$y[2], 0.25)
	expect_equal(Scale(data.frame(x=c(1, 2, 3), y=c(0, 25, 100)))$y[3], 1)
})


