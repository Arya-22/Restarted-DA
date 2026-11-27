function out = subgradient_polyak(data, x0, opts)
%SUBGRADIENT_POLYAK We implement the Polyak subgradient method using the supplied fstar.
A = data.A; b = data.b; xstar = data.xstar;
N = opts.total_oracles; fstar = opts.fstar;
x = x0;
err = nan(N,1); obj = nan(N,1);
tic;
for t = 1:N
    [ft, gt] = phase_obj_subgrad(x, A, b);
    ng2 = dot(gt, gt);
    if ng2 > 0
        alpha = max(ft - fstar, 0) / ng2;
        x = x - alpha * gt;
    end
    err(t) = phase_rel_error(x, xstar);
    obj(t) = ft;
end
out.x = x; out.reported_err = err; out.reported_obj = obj;
out.time = toc; out.oracles = N; out.opts = opts;
end
