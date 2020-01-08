# R version >= 3.5.0 code as an example of joint model with GP (Structure 4)
# Written by Weiji Su, Xia Wang and Rhonda Szczesniak, 1/8/2020
# Dataset is from simulation


setwd("C:/Users/SUW5AB/Documents/My Dissert Study Document/JM model HGP/Biometrics_draft/Biometrics_1st_Revision/Fig_Table_updates/Code/")


#load R library
require('rstan')
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

#load simulation dataset
load("simulation_Data.RData")


##Logit-Joint Model
set.seed(1234)

parnames <- c("alpha0", "beta0","sigma_sq","c","phi3","rho3", "phi1","rho1",
               "phi2","rho2","mu_y","mu_R","psi")

fit_logit <- stan(file = "logit_link.stan", data=joint_data,
                     iter=6000,warmup=3000, thin=5,chains=3, 
                    control = list(adapt_delta=0.9,max_treedepth = 12),
                     pars=parnames) 

plot(fit_logit)
##probit-Joint Model
set.seed(1234)

parnames <- c("alpha0", "beta0","sigma_sq","c","phi3","rho3", "phi1","rho1",
              "phi2","rho2","mu_y","mu_R","psi")

fit_probit <- stan(file = "probit_link.stan", data=joint_data,
                  iter=6000,warmup=3000, thin=5,chains=3, 
                  control = list(adapt_delta=0.9,max_treedepth = 12),
                  pars=parnames) 

##cloglog-Joint Model
set.seed(1234)

parnames <- c("alpha0", "beta0","sigma_sq","c","phi3","rho3", "phi1","rho1",
              "phi2","rho2","mu_y","mu_R","psi")

fit_cloglog <- stan(file = "cloglog_link.stan", data=joint_data,
                   iter=6000,warmup=3000, thin=5,chains=3,
                   control = list(adapt_delta=0.9,max_treedepth = 12),
                   pars=parnames) 

##splogit-Joint Model
set.seed(1234)
parnames <- c("alpha0", "beta0", "r_par","sigma_sq","c","phi3","rho3", "phi1","rho1",
              "phi2","rho2","mu_y","mu_R","psi")

fit_splogit <- stan(file = "splogit_link.stan", data=joint_data,
                    iter=6000,warmup=3000, thin=5,chains=3, 
                    pars=parnames) 

##spt-Joint Model
set.seed(1234)
parnames <- c("alpha0", "beta0", "r_par", "t_df","sigma_sq","c","phi3","rho3", "phi1","rho1",
              "phi2","rho2","mu_y","mu_R","psi")

fit_spt <- stan(file = "spt_link.stan", data=joint_data,
                    iter=6000,warmup=3000, thin=5,chains=3, 
                    control = list(adapt_delta=0.9,max_treedepth = 12),
                    pars=parnames) 

##spep-Joint Model
set.seed(1234)
parnames <- c("alpha0", "beta0", "r_par","sigma_sq","c","phi3","rho3", "phi1","rho1",
              "phi2","rho2","mu_y","mu_R","psi")

fit_spep <- stan(file = "spep_link.stan", data=joint_data,
                iter=6000,warmup=3000, thin=5,chains=3,
                control = list(adapt_delta=0.9,max_treedepth = 12),
                pars=parnames) 



