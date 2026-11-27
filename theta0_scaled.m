function theta0 = theta0_scaled(A, b, x0, p, T, ctheta)
%THETA0_SCALED We scale the initial parameter consistently with the p-dependence in the theory.
% theta0 is proportional to (||g(x0)||/||x0||) * S_T/(T+1)^(p+1/2).
[~, g0] = phase_obj_subgrad(x0, A, b);
S = sum((1:T).^p);
scale = norm(g0) / max(norm(x0), eps);
theta0 = ctheta * scale * S / ((T + 1)^(p + 0.5));
end
