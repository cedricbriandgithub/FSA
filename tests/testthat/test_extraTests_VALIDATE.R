context("extraTests() VALIDATE")
source("EXS_extraTests.R")

test_that("extraSS() computations",{
  ## Two model lm comparisons
  tmp1 <- extraSS(lm.0,com=lm.1)
  tmp2 <- anova(lm.0,lm.1)
  expect_equivalent(tmp1[1,"F"],tmp2[2,"F"])
  expect_equivalent(tmp1[1,"Df"],tmp2[2,"Df"])
  expect_equivalent(tmp1[1,"SS"],tmp2[2,"Sum of Sq"])
  ## Three model lm comparisons (only can compare to last)
  tmp1 <- extraSS(lm.0,lm.1,com=lm.2)
  tmp2 <- anova(lm.0,lm.1,lm.2)
  expect_equivalent(tmp1[2,"F"],tmp2[3,"F"])
  expect_equivalent(tmp1[2,"Df"],tmp2[3,"Df"])
  expect_equivalent(tmp1[2,"SS"],tmp2[3,"Sum of Sq"])
  ## Two model nls comparisons
  tmp1 <- extraSS(nls.0,com=nls.1)
  tmp2 <- anova(nls.0,nls.1)
  expect_equivalent(tmp1[1,"F"],tmp2[2,"F value"])
  expect_equivalent(tmp1[1,"Df"],tmp2[2,"Df"])
  expect_equivalent(tmp1[1,"SS"],tmp2[2,"Sum Sq"])
  ## Three model nls comparisons (only can compare to last)
  tmp1 <- extraSS(nls.0,nls.1,com=nls.2)
  tmp2 <- anova(nls.0,nls.1,nls.2)
  expect_equivalent(tmp1[2,"F"],tmp2[3,"F value"])
  expect_equivalent(tmp1[2,"Df"],tmp2[3,"Df"])
  expect_equivalent(tmp1[2,"SS"],tmp2[3,"Sum Sq"])
})

test_that("lrt() computations",{
  require(lmtest)
  ## Two model lm comparisons
  tmp1 <- lrt(lm.0,com=lm.1)
  tmp2 <- lrtest(lm.0,lm.1)
  expect_equivalent(tmp1[1,"Chisq"],tmp2[2,"Chisq"])
  expect_equivalent(tmp1[1,"Df"],tmp2[2,"Df"])
  expect_equivalent(tmp1[1,"logLikO"],tmp2[1,"LogLik"])
  expect_equivalent(tmp1[1,"logLikA"],tmp2[2,"LogLik"])
  ## Three model lm comparisons (only can compare to last)
  tmp1 <- lrt(lm.0,lm.1,com=lm.2)
  tmp2 <- lrtest(lm.0,lm.1,lm.2)
  expect_equivalent(tmp1[2,"Chisq"],tmp2[3,"Chisq"])
  expect_equivalent(tmp1[2,"Df"],tmp2[3,"Df"])
  expect_equivalent(tmp1[2,"logLikO"],tmp2[2,"LogLik"])
  expect_equivalent(tmp1[2,"logLikA"],tmp2[3,"LogLik"])
  ## Two model nls comparisons
  tmp1 <- lrt(nls.0,com=nls.1)
  tmp2 <- lrtest(nls.0,nls.1)
  expect_equivalent(tmp1[1,"Chisq"],tmp2[2,"Chisq"])
  expect_equivalent(tmp1[1,"Df"],tmp2[2,"Df"])
  expect_equivalent(tmp1[1,"logLikO"],tmp2[1,"LogLik"])
  expect_equivalent(tmp1[1,"logLikA"],tmp2[2,"LogLik"])
  ## Three model nls comparisons (only can compare to last)
  tmp1 <- lrt(nls.0,nls.1,com=nls.2)
  tmp2 <- lrtest(nls.0,nls.1,nls.2)
  expect_equivalent(tmp1[2,"Chisq"],tmp2[3,"Chisq"])
  expect_equivalent(tmp1[2,"Df"],tmp2[3,"Df"])
  expect_equivalent(tmp1[2,"logLikO"],tmp2[2,"LogLik"])
  expect_equivalent(tmp1[2,"logLikA"],tmp2[3,"LogLik"])
})
