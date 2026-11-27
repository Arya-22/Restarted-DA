function data = generate_phase_data(d, m, corrupt_prob, corrupt_variance, seed)
%GENERATE_PHASE_DATA We generate a Gaussian phase-retrieval instance with controlled corruption.
rng(seed, 'twister');
A = randn(m, d);
xstar = randn(d, 1);
y = A * xstar;
bclean = y.^2;

if corrupt_prob > 0
    z = rand(m, 1) < corrupt_prob;
    noise = sqrt(corrupt_variance) * randn(m, 1);
    b = (1 - z) .* bclean + z .* abs(noise);
else
    z = false(m, 1);
    b = bclean;
end

data.A = A;
data.b = b;
data.bclean = bclean;
data.xstar = xstar;
data.corrupt_mask = z;
data.corrupt_prob = corrupt_prob;
data.seed = seed;
end
