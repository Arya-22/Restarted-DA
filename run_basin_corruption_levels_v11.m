function results = run_basin_corruption_levels_v11(codeDir,paramsFile,outDir)
%RUN_BASIN_CORRUPTION_LEVELS_V11 We run the basin experiment at nu=0, 0.05, and 0.10.
% We use the frozen RPDA parameters. For each (eta_0,trial), we reuse the same
% random seed across corruption levels, so A, x*, the initialization,
% and the underlying uniform/noise draws are paired; the 5% outliers form a
% subset of the 10% outliers for that seed.


if nargin<3 || isempty(outDir), outDir=pwd; end
if nargin>=1 && ~isempty(codeDir), addpath(codeDir); end
if ~exist(paramsFile,'file'), error('Parameter file not found: %s',paramsFile); end
P=load(paramsFile); cfg=P.cfg; params=P.params;
nuList=[0 0.05 0.10]; radii=cfg.init_radius_grid; N=cfg.total_oracles;
if mod(N,params.T)~=0, error('total_oracles must be divisible by T.'); end
results=struct();
for c=1:numel(nuList)
    nu=nuList(c); finalE=nan(numel(radii),cfg.ntrials_basin); hit=nan(size(finalE));
    for j=1:numel(radii)
        for r=1:cfg.ntrials_basin
            % We reuse the same seed across nu at each fixed (radius,trial) pair.
            seed=cfg.seed_base+880000+1000*j+r;
            data=generate_phase_data(cfg.d,cfg.base_m,nu,cfg.corrupt_variance,seed);
            x0=make_local_init(data.xstar,radii(j),seed+10000);
            op.total_oracles=N; op.T=params.T; op.p=cfg.p_default;
            op.theta0=theta0_scaled(data.A,data.b,x0,cfg.p_default,params.T,params.rpda_c);
            op.q_epoch=params.q_epoch; op.use_gurobi=false;
            o=run_rpda_budget(data,x0,op);
            finalE(j,r)=o.reported_err(end);
            hit(j,r)=any(o.reported_err<=cfg.success_tol);
        end
    end
    tag=sprintf('corrupt_%03d',round(100*nu));
    results.(tag).nu=nu;
    results.(tag).radii=radii;
    results.(tag).final_errors=finalE;
    results.(tag).success=mean(hit,2,'omitnan');
    results.(tag).success_tol=cfg.success_tol;
end
if ~exist(outDir,'dir'), mkdir(outDir); end
save(fullfile(outDir,'basin_corruption_levels_v11.mat'),'results','cfg','params','-v7.3');
fprintf('Saved: %s\n',fullfile(outDir,'basin_corruption_levels_v11.mat'));
end
