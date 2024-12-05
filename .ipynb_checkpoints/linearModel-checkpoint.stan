data {
 int<lower=0> N; // Number of Obs
 int<lower=0> K; // Number of Predictors
 // prior parameters
 int<lower=0> g; // g prior 
 int<lower=0> nu0; // 
 real<lower=0> s20; // sigma prior
 
 real[N, K] X; // data matrix
}
parameters {
 real beta;
 real alpha;
 
}
transformed parameters {

}
model {
  
}
generated quantities {

}