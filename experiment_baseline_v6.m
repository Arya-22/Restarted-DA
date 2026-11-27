function results = experiment_baseline_v6(cfg,params)
%EXPERIMENT_BASELINE_V6 We run the baseline comparison at m/d=base_ratio.
cps=[0 cfg.corrupt_prob];N=cfg.total_oracles;
method_names={'RPDA','GeoSG','DA','Polyak'};results=struct();
if mod(N,params.T)~=0,error('total_oracles must be divisible by T.');end
for cc=1:numel(cps)
    cp=cps(cc);E=nan(numel(method_names),cfg.ntrials_baseline,N);
    Times=nan(numel(method_names),cfg.ntrials_baseline);
    for r=1:cfg.ntrials_baseline
        seed=cfg.seed_base+70000*cc+r;
        data=generate_phase_data(cfg.d,cfg.base_m,cp,cfg.corrupt_variance,seed);
        x0=make_local_init(data.xstar,cfg.rel_init,seed+10000);
        op.total_oracles=N;op.T=params.T;op.p=cfg.p_default;
        op.theta0=theta0_scaled(data.A,data.b,x0,cfg.p_default,params.T,params.rpda_c);
        op.q_epoch=params.q_epoch;op.use_gurobi=false;
        o=run_rpda_budget(data,x0,op);E(1,r,:)=o.reported_err;Times(1,r)=o.time;
        og.total_oracles=N;og.lambda0=params.geo_lambda_frac*norm(x0);og.q=params.geo_q;
        o=subgradient_geometric(data,x0,og);E(2,r,:)=o.reported_err;Times(2,r)=o.time;
        od.total_oracles=N;od.p=cfg.p_default;
        od.theta0=theta0_scaled(data.A,data.b,x0,cfg.p_default,N,params.da_c);
        o=da_no_restart(data,x0,od);E(3,r,:)=o.reported_err;Times(3,r)=o.time;
        if cp==0
            pp.total_oracles=N;pp.fstar=0;
            o=subgradient_polyak(data,x0,pp);E(4,r,:)=o.reported_err;Times(4,r)=o.time;
        end
    end
    tag=sprintf('corrupt_%03d',round(100*cp));
    results.(tag).errors=E;results.(tag).times=Times;
    results.(tag).method_names=method_names;results.(tag).oracles=1:N;
end
if ~exist(cfg.results_dir,'dir'), mkdir(cfg.results_dir); end
save(fullfile(cfg.results_dir,['baseline_v6_' cfg.mode '.mat']),'results','cfg','params','-v7.3');
end
