
# Based on:
#    1. Introductory Econometrics, A Modern Approach, J.M. Wooldridge
#    2. Using R for Introductory Econometrics - available here:
#          https://www.urfie.net/downloads/PDF/URfIE_web.pdf
#    3. https://rpubs.com/shirokaner/logisticregrex
#    4. https://www.chrisbilder.com/categorical/Chapter5/AllGOFTests.R
install.packages("wooldridge")
library("wooldridge")

data(mroz, package="wooldridge")

# a logit model
logit = glm(inlf~nwifeinc+educ+exper+I(exper^2)+age+kidslt6+kidsge6,
            data=mroz, family=binomial(link="logit"))
summary(logit)

# the linktest
# source("linktest.R)


install.packages("generalhoslem")
library("generalhoslem")

# the Hosmer-Lemeshow test
logitgof(mroz$inlf, fitted(logit), g = 10)

# load functions from AllGOFTests.R

# the Osius-Rojek test
o.r.test(logit)

# the Stukel test
stukel.test(logit)
