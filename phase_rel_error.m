function e = phase_rel_error(x, xstar)
%PHASE_REL_ERROR We measure the sign-invariant relative recovery error.
e = min(norm(x - xstar), norm(x + xstar)) / norm(xstar);
end
