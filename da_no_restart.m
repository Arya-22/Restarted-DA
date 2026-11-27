function out = da_no_restart(data, x0, opts)
%DA_NO_RESTART We implement polynomial dual averaging with a fixed proximal center.
A = data.A; b = data.b; xstar = data.xstar;
N = opts.total_oracles; p = opts.p; theta0 = opts.theta0;
z = x0; x = x0; s = zeros(size(x0));
reported_err = nan(N,1); reported_obj = nan(N,1);
fbest = inf; xbest = x;
tic;
for t = 1:N
    [ft, gt] = phase_obj_subgrad(x, A, b);
    if ft < fbest
        fbest = ft; xbest = x;
    end
    reported_err(t) = phase_rel_error(xbest, xstar);
    reported_obj(t) = fbest;
    lambda = t^p;
    beta = theta0 * (t + 1)^(p + 0.5);
    s = s + lambda * gt;
    x = z - s / beta;
end
out.x = xbest; out.reported_err = reported_err; out.reported_obj = reported_obj;
out.time = toc; out.oracles = N; out.opts = opts;
end
