function out = run_rpda_budget(data, x0, opts)
%RUN_RPDA_BUDGET We run complete fixed-length epochs under the prescribed oracle budget.
% opts: total_oracles, T, p, theta0, q_epoch, use_gurobi.
% Our experiment settings ensure that T divides total_oracles exactly.
N = opts.total_oracles;
if mod(N,opts.T) ~= 0
    error('V6 requires T to divide total_oracles exactly.');
end
r.T = opts.T;
r.num_epochs = N/opts.T;
r.p = opts.p;
r.theta0 = opts.theta0;
r.theta_growth = 1/opts.q_epoch;
r.use_gurobi = opts.use_gurobi;
out = rpda_fixed_epoch(data,x0,r);
out.q_epoch = opts.q_epoch;
out.theta_growth = 1/opts.q_epoch;
end
