function cfg = config_phase_retrieval_v6(mode)
%CONFIG_PHASE_RETRIEVAL_V6 We define the experiment protocol used in this package.
% We retain the supplied V6 numerical settings for parameter tuning and the
% baseline experiment, and the V11 basin routine for the manuscript-aligned
% three-level corruption experiment.

if nargin < 1 || isempty(mode), mode = 'final'; end
cfg.mode = lower(mode);
cfg.seed_base = 20261108;
cfg.pilot_seed = 91001;
cfg.corrupt_prob = [0.05 0.10];
cfg.corrupt_variance = 100;
cfg.rel_init = 0.20;
cfg.p_default = 0;
cfg.success_tol = 1e-4;

switch cfg.mode
    case 'quick'
        % We provide this reduced setting for a short execution check only.
        cfg.d = 300;
        cfg.base_ratio = 3;
        cfg.total_oracles = 800;
        cfg.tune_horizon = 500;
        cfg.base_T = 20;
        cfg.T_grid = [10 20 25 40];
        cfg.q_epoch_grid = [0.60 0.65 0.70 0.75 0.80 0.85 0.90];
        cfg.rpda_c_grid = [0.3 1 3 10];
        cfg.da_c_grid = [0.1 0.3 1 3];
        cfg.geo_lambda_frac_grid = [0.01 0.03 0.10 0.30];
        cfg.geo_q_grid = [0.98 0.985 0.99 0.995];
        cfg.init_radius_grid = [0.05 0.10 0.20 0.40 0.60 0.80 1.00];
        cfg.npilot = 3;
        cfg.ntrials_basin = 8;
        cfg.ntrials_baseline = 5;
    case 'final'
        % We use the supplied final setting for the reported experiments.
        cfg.d = 500;
        cfg.base_ratio = 3;
        cfg.total_oracles = 1500;
        cfg.tune_horizon = 800;
        cfg.base_T = 20;
        cfg.T_grid = [10 20 25 30 50];
        cfg.q_epoch_grid = [0.60 0.65 0.70 0.75 0.80 0.85 0.90];
        cfg.rpda_c_grid = [0.3 1 3 10];
        cfg.da_c_grid = [0.1 0.3 1 3 10];
        cfg.geo_lambda_frac_grid = [0.01 0.03 0.10 0.30];
        cfg.geo_q_grid = [0.98 0.985 0.99 0.995 0.997];
        cfg.init_radius_grid = [0.05 0.10 0.20 0.30 0.40 0.60 0.80 1.00];
        cfg.npilot = 5;
        cfg.ntrials_basin = 15;
        cfg.ntrials_baseline = 15;
    otherwise
        error('Unknown mode: %s', mode);
end

cfg.base_m = round(cfg.base_ratio * cfg.d);
cfg.pilot_seeds = cfg.pilot_seed + (0:cfg.npilot-1)*97;
rootDir = fileparts(mfilename('fullpath'));
cfg.results_dir = fullfile(rootDir, 'results', cfg.mode);
cfg.figures_dir = fullfile(rootDir, 'figures', cfg.mode);
end
