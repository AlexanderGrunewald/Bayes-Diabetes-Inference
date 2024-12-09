data {
  int<lower=1> N;            // Number of observations
  int<lower=1> P;            // Number of predictors
  matrix[N, P] X;            // Design matrix
  vector[N] y;               // Response variable
  real<lower=0> sigma2;      // Fixed variance for likelihood
  real<lower=0> tau2;        // Variance of the slab for beta coefficients
  real<lower=0, upper=1> p_prior; // Prior inclusion probability
}

parameters {
  vector[P] beta;                // Regression coefficients
  simplex[P] inclusion_probs;    // Relaxed inclusion probabilities for predictors
}

transformed parameters {
  vector<lower=0, upper=1>[P] z; // Continuous approximation of inclusion indicators
  z = inclusion_probs;           // Maps the simplex to probabilities
}

model {
  vector[N] mu;

  // Prior for inclusion probabilities (relaxed Bernoulli via simplex)
  inclusion_probs ~ dirichlet(rep_vector(1, P));

  // Spike-and-slab prior on beta
  for (j in 1:P) {
    beta[j] ~ normal(0, sqrt(tau2 * z[j])); // Continuous relaxation of inclusion
  }

  // Linear model
  mu = X * beta;

  // Likelihood
  y ~ normal(mu, sqrt(sigma2));
}

generated quantities {
  vector[N] y_pred;  // Predicted values
  for (n in 1:N) {
    y_pred[n] = normal_rng(dot_product(X[n], beta), sqrt(sigma2));
  }
}
