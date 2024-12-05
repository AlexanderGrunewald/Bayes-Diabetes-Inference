data {
  int N; // number of observations
  // response
  vector[N] y;
  // number of columns in the design matrix X
  int K;
  // design matrix X
  // should not include an intercept
  matrix [N, K] X;
  // priors on alpha
  real scale_alpha;
  vector[K] scale_beta;
  real loc_sigma;
  // keep responses
  int use_y_rep;
  int use_log_lik;
}
parameters {
  // regression coefficient vector
  real alpha;
  vector[K] beta;
  real sigma;
}
transformed parameters {
  vector[N] mu;

  mu = alpha + X * beta;
}
model {
  // priors
  alpha ~ normal(0., scale_alpha);
  beta ~ normal(0., scale_beta);
  sigma ~ exponential(loc_sigma);
  // likelihood
  y ~ normal(mu, sigma);
}
generated quantities {
  // simulate data from the posterior
  vector[N * use_y_rep] y_rep;
  // log-likelihood posterior
  vector[N * use_log_lik] log_lik;
  for (i in 1:num_elements(y_rep)) {
    y_rep[i] = normal_rng(mu[i], sigma);
  }
  for (i in 1:num_elements(log_lik)) {
    log_lik[i] = normal_lpdf(y[i] | mu[i], sigma);
  }
}