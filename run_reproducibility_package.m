function run_reproducibility_package(mode)
%RUN_REPRODUCIBILITY_PACKAGE We reproduce the Basin and Baseline figures.
% Usage:
%   run_reproducibility_package          % full final experiment protocol
%   run_reproducibility_package('quick') % reduced execution check only
%
% We tune parameters once on the prescribed pilot instances, save them, run
% the baseline and V11 basin experiments, and export editable FIG and vector
% EPS files. We leave all generated MATLAB figures open after export.

if nargin<1 || isempty(mode), mode = 'final'; end
rootDir = fileparts(mfilename('fullpath'));
addpath(rootDir);
cfg = config_phase_retrieval_v6(mode);
if ~exist(cfg.results_dir,'dir'), mkdir(cfg.results_dir); end
if ~exist(cfg.figures_dir,'dir'), mkdir(cfg.figures_dir); end

paramsFile = fullfile(cfg.results_dir,['params_v6_' cfg.mode '.mat']);
reuseParams = false;
if exist(paramsFile,'file')
    saved = load(paramsFile,'params','cfg');
    if isfield(saved,'params') && isfield(saved,'cfg')
        reuseParams = same_protocol(saved.cfg,cfg);
    end
    if reuseParams
        params = saved.params;
        fprintf('We reuse the saved parameter file: %s\n',paramsFile);
    else
        fprintf('The saved parameter file does not match this protocol; we retune.\n');
    end
end
if ~reuseParams
    fprintf('We tune parameters on the prescribed pilot instances.\n');
    params = tune_params_v6(cfg);
    save(paramsFile,'params','cfg','-v7.3');
    fprintf('We save the selected parameters to: %s\n',paramsFile);
end

fprintf(['Selected parameters: T=%g, q_epoch=%.6g, rpda_c=%g, ', ...
    'da_c=%g, geo_lambda_frac=%g, geo_q=%g\n'], ...
    params.T,params.q_epoch,params.rpda_c,params.da_c, ...
    params.geo_lambda_frac,params.geo_q);

% We retain the supplied baseline experiment and its random-seed schedule.
experiment_baseline_v6(cfg,params);

% We use the V11 routine as the authoritative three-level basin experiment.
run_basin_corruption_levels_v11(rootDir,paramsFile,cfg.results_dir);

baselineMat = fullfile(cfg.results_dir,['baseline_v6_' cfg.mode '.mat']);
basinMat = fullfile(cfg.results_dir,'basin_corruption_levels_v11.mat');
plot_baseline_math_eps_v11(baselineMat,cfg.figures_dir,true);
plot_basin_corruption_levels_v11_eps(basinMat,cfg.figures_dir);

drawnow;
fprintf('\nWe have completed the %s reproducibility run.\n',cfg.mode);
fprintf('Results: %s\n',cfg.results_dir);
fprintf('Figures: %s\n',cfg.figures_dir);
fprintf(['We leave four figures open in MATLAB. Each figure is saved as ', ...
    'an editable FIG file and a vector EPS file.\n']);
end

function tf = same_protocol(savedCfg,currentCfg)
% We compare all fields that determine the experiment and tuning protocol.
fields = {'mode','seed_base','pilot_seed','corrupt_prob','corrupt_variance', ...
    'rel_init','p_default','success_tol','d','base_ratio','base_m', ...
    'total_oracles','tune_horizon','base_T','T_grid','q_epoch_grid', ...
    'rpda_c_grid','da_c_grid','geo_lambda_frac_grid','geo_q_grid', ...
    'init_radius_grid','npilot','ntrials_basin','ntrials_baseline','pilot_seeds'};
tf = true;
for k = 1:numel(fields)
    f = fields{k};
    if ~isfield(savedCfg,f) || ~isfield(currentCfg,f) || ...
            ~isequaln(savedCfg.(f),currentCfg.(f))
        tf = false;
        return;
    end
end
end
