function out = rpda_fixed_epoch(data, x0, opts)
%RPDA_FIXED_EPOCH We implement fixed-epoch restarted polynomial dual averaging.
% opts: T, num_epochs, p, theta0, theta_growth, use_gurobi.

A = data.A; b = data.b; xstar = data.xstar;
T = opts.T; K = opts.num_epochs; p = opts.p;
theta = opts.theta0; growth = opts.theta_growth;
if ~isfield(opts, 'use_gurobi'), opts.use_gurobi = false; end

N = T * K;
reported_err = nan(N,1);
reported_obj = nan(N,1);
raw_err = nan(N,1);
epoch_err = nan(K+1,1);
epoch_obj = nan(K+1,1);
epoch_oracles = (0:T:N)';

z = x0;
epoch_err(1) = phase_rel_error(z, xstar);
epoch_obj(1) = NaN;
count = 0;
tic;

for k = 1:K
    x = z;
    s = zeros(size(x));
    best_x = x;
    best_f = inf;

    for i = 1:T
        % Exactly one full objective/subgradient oracle call per inner iteration.
        [fi, gi] = phase_obj_subgrad(x, A, b);
        count = count + 1;
        if fi < best_f
            best_f = fi;
            best_x = x;
        end

        lambda = i^p;
        beta = theta * (i + 1)^(p + 0.5);
        s = s + lambda * gi;

        raw_err(count) = phase_rel_error(x, xstar);
        reported_err(count) = phase_rel_error(best_x, xstar);
        reported_obj(count) = best_f;

        if opts.use_gurobi
            x = da_prox_gurobi(z, s, beta);
        else
            x = z - s / beta;
        end
    end

    z = best_x;
    epoch_err(k+1) = phase_rel_error(z, xstar);
    epoch_obj(k+1) = best_f;
    theta = growth * theta;
end

out.x = z;
out.reported_err = reported_err;
out.reported_obj = reported_obj;
out.raw_err = raw_err;
out.epoch_err = epoch_err;
out.epoch_obj = epoch_obj;
out.epoch_oracles = epoch_oracles;
out.time = toc;
out.oracles = N;
out.opts = opts;
end
