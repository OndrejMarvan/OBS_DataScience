
* Python and Stata results consistency

* clear Stata's memory
clear

* import the dataset from the Internet
bcuse mroz

* Tobit model
tobit hours nwifeinc educ exper expersq age kidslt6 kidsge6, ll(0)