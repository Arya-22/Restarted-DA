function x0 = make_local_init(xstar, rel_dist, seed)
%MAKE_LOCAL_INIT We construct an initial point at the prescribed relative distance.
rng(seed, 'twister');
u = randn(size(xstar));
u = u / norm(u);
x0 = xstar + rel_dist * norm(xstar) * u;
end
