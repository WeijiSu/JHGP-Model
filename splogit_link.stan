

functions {
  //power logistic
  
  // cdf 
  real  pplogit_cdf(real x, real location, real   r){
    if(r <= 1)
      return pow(logistic_cdf((x - location) / r, 0, 1),r) ;
    else  return (1-pow(logistic_cdf(- r * (x - location), 0, 1),(1 / r))) ;
  } //cdf pdf
  
}


data {
  int<lower=1> T;
  int<lower=1> N;
  
  vector[T] t; //time points
  matrix[T, N] y; //continuous
  int r[T, N]; //binary  
}

transformed data {
//  vector[T] zeros = rep_vector(0,T);
  vector[T] zeros;
  for (i in 1:T){ 
    zeros[i] = 0;
  }
}

parameters {
  real alpha0;                // regression coefficients
  real beta0;

  real<lower= -1, upper =1> c; // shared coefficients
  
  real<lower=0> phi3;
  real<lower= -1, upper =1> rho3;
  real<lower=0> r_par; //power parameter r
  real<lower=0> sigma_sq;     // variance
  
  real<lower=0> phi1;    //GP mu_y
  real<lower=0> rho1; // 
  
  real<lower=0> phi2;    //GP mu_R
  real<lower=0> rho2; // 


  matrix[T,N] eta; //latent for psi
  vector[T] eta_muY; //latent for mu_y
  vector[T] eta_muR; //latent for mu_R
}

transformed parameters {
  vector[T] mu_y;
  vector[T] mu_R;
  matrix[T,N] psi;     //random process
 {
   matrix[T,T] Sigma1; 
   matrix[T,T] Sigma2; 
   matrix[T,T] Sigma3;
   matrix[T,T] L_cov1;
   matrix[T,T] L_cov2;
   matrix[T,T] L_cov3;

    // off-diagonal elements
    for (i in 1:(T-1)) {
      for (j in (i+1):T) {
        Sigma1[i,j] = pow(phi1,2) * exp(-   rho1 * pow(t[i] - t[j],2) );
        Sigma1[j,i] = Sigma1[i,j];
        Sigma2[i,j] = pow(phi2,2) * exp(-   rho2 * pow(t[i] - t[j],2) );
        Sigma2[j,i] = Sigma2[i,j];
        Sigma3[i,j] = pow(phi3,2) * pow( rho3 , fabs(i - j));
        Sigma3[j,i] = Sigma3[i,j];
      }
    }
    
    // diagonal elements
    for (k in 1:T){
      Sigma1[k,k] = pow(phi1,2) + 0.000001; // + jitter
      Sigma2[k,k] = pow(phi2,2) + 0.000001; // + jitter
      Sigma3[k,k] = pow(phi3,2) + 0.000001; // + jitter
    }  
    
    L_cov1 = cholesky_decompose(Sigma1);
    L_cov2 = cholesky_decompose(Sigma2);
    L_cov3 = cholesky_decompose(Sigma3);
    psi = L_cov3*eta;
    mu_y = L_cov1*eta_muY+alpha0;
    mu_R = L_cov2*eta_muR;
   }
}

model {
  to_vector(eta) ~ normal(0,1);
  eta_muY ~ normal(0,1);
  eta_muR ~ normal(0,1);
  
  for (n in 1:N){
    for(i in 1:T){
      y[i, n] ~ normal(mu_y[i] + psi[i,n] , sqrt(sigma_sq));
      r[i, n] ~ bernoulli( pplogit_cdf(beta0+mu_R[i]+c*(psi[i, n]), 0,  r_par));
    }
  }

  
  c ~ uniform(-1,1);
  phi3 ~  normal(0,5);
  rho3 ~ uniform(-1,1);
  sigma_sq ~ inv_gamma(2,1);  
  phi1 ~ normal(0,5);
  rho1 ~  inv_gamma(2,1);
  phi2 ~ normal(0,5);
  rho2 ~  inv_gamma(2,1); 
   r_par ~ exponential(1);
}


