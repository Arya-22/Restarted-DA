function [f, g] = phase_obj_subgrad(x, A, b)
%PHASE_OBJ_SUBGRAD We evaluate the objective and an admissible composite subgradient.
y = A * x;
r = y.^2 - b;
f = mean(abs(r));
if nargout > 1
    sigma = sign(r);     % sign(0)=0 is an admissible choice
    g = (2 / size(A,1)) * (A' * (sigma .* y));
end
end
