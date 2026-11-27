function out = subgradient_geometric(data, x0, opts)
%SUBGRADIENT_GEOMETRIC We implement the normalized subgradient method with alpha_t=lambda0*q^t.
A = data.A; b = data.b; xstar = data.xstar;
N = opts.total_oracles; lambda0 = opts.lambda0; q = opts.q;
x = x0;
err = nan(N,1); obj = nan(N,1);
tic;
for t = 0:N-1
    [ft, gt] = phase_obj_subgrad(x, A, b);
    ng = norm(gt);
    if ng > 0
        alpha = lambda0 * q^t;
        x = x - alpha * gt / ng;
    end
    err(t+1) = phase_rel_error(x, xstar);
    obj(t+1) = ft;
end
out.x = x; out.reported_err = err; out.reported_obj = obj;
out.time = toc; out.oracles = N; out.opts = opts;
end
