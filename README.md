# JHGP-Model
Flexible Link Functions in a Joint Hierarchical Gaussian Process Model

Here is the R code to illustrate how to implement the JHGP with flexible link function. More detail model structures and setup can be found at Su, Wang, and Szczesniak (2020).

To use the souce files, follow the instruction below.

***Including:
*simulation_Data.RData: an example dataset from simulation
*logit_link.stan: logit link of joint model
*probit_link.stan: probit link of joint model
*splogit_link.stan: power logit link of joint model
*spt_link.stan: power t link of joint model
*spep_link.stan: power exponential link of joint model
*code.R: program for estimating the model

***How does it work:
*Download all files and place them in one folder.
*Install R package "rstan" and more detail of installation check this website below.
https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
*Use code.R for estimating the joint model with different link
