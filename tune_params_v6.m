function params = tune_params_v6(cfg)
%TUNE_PARAMS_V6 We select the algorithmic parameters on controlled pilot instances.
% We use 10%% corrupted phase retrieval with m/d = cfg.base_ratio,
% and dist(x0,X*)/||x*|| = cfg.rel_init. We then freeze the selected parameters
% throughout the reported experiments.

% We first select (c_theta,q) for RPDA at the base epoch length.
best.score = inf;
for c = cfg.rpda_c_grid
    for q = cfg.q_epoch_grid
        scores = nan(cfg.npilot,1); finals = nan(cfg.npilot,1);
        for r = 1:cfg.npilot
            [data,x0] = pilot_instance(cfg,r);
            T = cfg.base_T;
            N = floor(cfg.tune_horizon/T)*T;
            op.total_oracles=N; op.T=T; op.p=cfg.p_default;
            op.theta0=theta0_scaled(data.A,data.b,x0,cfg.p_default,T,c);
            op.q_epoch=q; op.use_gurobi=false;
            o=run_rpda_budget(data,x0,op);
            scores(r)=curve_score(o.reported_err,N); finals(r)=o.reported_err(end);
        end
        score = robust_score(scores,finals,cfg.success_tol);
        if score < best.score
            best.score=score; best.c=c; best.q=q;
        end
    end
end
params.rpda_c = best.c;
params.q_epoch = best.q;

% We next select T while keeping (c_theta,q) fixed.
bestT.score = inf;
for T = cfg.T_grid
    N = floor(cfg.tune_horizon/T)*T;
    if N < T, continue; end
    scores = nan(cfg.npilot,1); finals = nan(cfg.npilot,1);
    for r = 1:cfg.npilot
        [data,x0] = pilot_instance(cfg,r);
        op.total_oracles=N; op.T=T; op.p=cfg.p_default;
        op.theta0=theta0_scaled(data.A,data.b,x0,cfg.p_default,T,params.rpda_c);
        op.q_epoch=params.q_epoch; op.use_gurobi=false;
        o=run_rpda_budget(data,x0,op);
        scores(r)=curve_score(o.reported_err,N); finals(r)=o.reported_err(end);
    end
    score = robust_score(scores,finals,cfg.success_tol);
    if score < bestT.score
        bestT.score=score; bestT.T=T;
    end
end
params.T = bestT.T;

% We then select the non-restarted DA parameter.
best.score = inf;
for c = cfg.da_c_grid
    scores=nan(cfg.npilot,1); finals=nan(cfg.npilot,1);
    for r=1:cfg.npilot
        [data,x0]=pilot_instance(cfg,r);
        od.total_oracles=cfg.tune_horizon; od.p=cfg.p_default;
        od.theta0=theta0_scaled(data.A,data.b,x0,cfg.p_default,cfg.tune_horizon,c);
        o=da_no_restart(data,x0,od);
        scores(r)=curve_score(o.reported_err,cfg.tune_horizon); finals(r)=o.reported_err(end);
    end
    score=robust_score(scores,finals,cfg.success_tol);
    if score<best.score, best.score=score; best.c=c; end
end
params.da_c=best.c;

% We finally select the geometrically decaying normalized subgradient parameters.
best.score = inf;
for frac = cfg.geo_lambda_frac_grid
    for qq = cfg.geo_q_grid
        scores=nan(cfg.npilot,1); finals=nan(cfg.npilot,1);
        for r=1:cfg.npilot
            [data,x0]=pilot_instance(cfg,r);
            og.total_oracles=cfg.tune_horizon;
            og.lambda0=frac*norm(x0); og.q=qq;
            o=subgradient_geometric(data,x0,og);
            scores(r)=curve_score(o.reported_err,cfg.tune_horizon); finals(r)=o.reported_err(end);
        end
        score=robust_score(scores,finals,cfg.success_tol);
        if score<best.score
            best.score=score; best.frac=frac; best.q=qq;
        end
    end
end
params.geo_lambda_frac=best.frac;
params.geo_q=best.q;
params.pilot_seeds=cfg.pilot_seeds;
pilotCorruption = cfg.corrupt_prob(end);
params.pilot_setting=sprintf('d=%d,m=%d,corruption=%.2f,rel_init=%.2f', ...
    cfg.d,cfg.base_m,pilotCorruption,cfg.rel_init);
end

function [data,x0] = pilot_instance(cfg,r)
seed=cfg.pilot_seeds(r);
% We use the 10% corruption level specified for pilot tuning.
data=generate_phase_data(cfg.d,cfg.base_m,cfg.corrupt_prob(end),cfg.corrupt_variance,seed);
x0=make_local_init(data.xstar,cfg.rel_init,seed+10000);
end

function s = robust_score(scores,finals,target)
% We use the upper-quartile trajectory score and penalize unsuccessful runs.
valid=scores(isfinite(scores));
if isempty(valid), s=inf; return; end
base=prctile(valid,75);
fail=mean(~isfinite(finals) | finals>target);
s=base+2*fail;
end
