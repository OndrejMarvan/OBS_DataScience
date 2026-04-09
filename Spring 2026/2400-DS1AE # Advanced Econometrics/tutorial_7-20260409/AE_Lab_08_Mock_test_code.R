
install.packages("wooldridge")
library("wooldridge")

data('jtrain98')
str(jtrain98)
library( "censReg" )

# Tobit model
tobit <- censReg(earn98~train+earn96+educ+married, 
                left=0, right=Inf, data=jtrain98)
summary(tobit)

# marginal effects after censReg function
source("tobit_marginal_effects.R")
x = rbind(1, 0, mean(jtrain98$earn96), mean(jtrain98$educ), 0)
me = tobit_marginal_effects(tobit, x, dummies_indices=c(2,5))

# Interpret marginal effects