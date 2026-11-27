# Restarted-DA

REPRODUCIBILITY PACKAGE: BASIN AND BASELINE EXPERIMENTS
=======================================================

1. PURPOSE
----------
We provide the MATLAB source files needed to regenerate the Basin and
Baseline experiments and their final manuscript figures. We have organized
the package around the numerical routines and plotting logic that are
relevant to these two experiments only.

We use run_basin_corruption_levels_v11.m as the authoritative Basin routine.
It evaluates the three corruption levels nu = 0, 0.05, and 0.10 and retains
the paired-seed design in the supplied source.  

2. FIGURES GENERATED
--------------------
We generate four figures. Each figure is saved in both editable MATLAB FIG
format and vector EPS format:

  Basin:
    basin_corruption_levels_v11.fig
    basin_corruption_levels_v11.eps

  Baseline, combined two-panel layout:
    baseline_v11_combined.fig
    baseline_v11_combined.eps

  Baseline, clean measurements:
    baseline_clean_v11.fig
    baseline_clean_v11.eps

  Baseline, 10% corrupted measurements:
    baseline_corrupt10_v11.fig
    baseline_corrupt10_v11.eps

The figures remain available for inspection and editing.

3. SOFTWARE REQUIREMENTS
------------------------
We recommend MATLAB R2020a or later. The plotting code uses tiledlayout,
savefig, and standard MATLAB graphics functions. The Statistics and Machine
Learning Toolbox is required for prctile, which we use for pilot scoring and
interquartile bands.

4. HOW TO RUN
-------------
1) Extract this folder.
2) Start MATLAB and set this folder as the current folder.
3) Run:

       run_reproducibility_package

This command uses the full 'final' protocol. It first checks whether a
parameter file generated under the same protocol is already available. If
not, we tune the parameters on the prescribed pilot instances and save them.
We then run the Baseline and V11 Basin experiments and generate the figures.

For a reduced execution check, run:

       run_reproducibility_package('quick')

The 'quick' setting is intended only to check that the code executes. We do
not use its numerical results as the final manuscript results.

5. OUTPUT DIRECTORIES
---------------------
The code creates the following directories automatically:

  results/final/
      params_v6_final.mat
      baseline_v6_final.mat
      basin_corruption_levels_v11.mat

  figures/final/
      basin_corruption_levels_v11.fig / .eps
      baseline_v11_combined.fig / .eps
      baseline_clean_v11.fig / .eps
      baseline_corrupt10_v11.fig / .eps

When the 'quick' mode is selected, the corresponding outputs are written to
results/quick/ and figures/quick/.

6. REPRODUCIBILITY DETAILS
--------------------------
We preserve the numerical settings, random seeds, initialization procedure,
parameter grids, oracle budget, and trial counts in the supplied final
configuration. Parameter tuning uses the pilot seeds defined in the
configuration and a scalar 10% corruption probability, as specified in the
pilot-problem description. The selected parameters are saved and reused on
subsequent runs when the saved configuration matches the current protocol.


The full final protocol is computationally more demanding than the quick
check: it uses dimension d = 500, 1500 oracle calls, and the supplied final
trial counts. Runtime depends on the MATLAB version and hardware.

7. FILE ORGANIZATION
--------------------
run_reproducibility_package.m       Main entry point
config_phase_retrieval_v6.m         Final and quick experiment settings
tune_params_v6.m                    Pilot-based parameter selection
generate_phase_data.m               Synthetic phase-retrieval data
make_local_init.m                   Controlled initial points
phase_obj_subgrad.m                 Objective and subgradient
phase_rel_error.m                   Sign-invariant relative error
theta0_scaled.m                     Initial RPDA parameter scaling
curve_score.m                       Pilot trajectory score
rpda_fixed_epoch.m                  Fixed-epoch restarted dual averaging
run_rpda_budget.m                   Oracle-budget wrapper
da_no_restart.m                     Non-restarted dual averaging
subgradient_geometric.m              Geometric normalized subgradient
subgradient_polyak.m                 Polyak subgradient baseline
experiment_baseline_v6.m             Baseline experiment
run_basin_corruption_levels_v11.m     Authoritative V11 Basin experiment
plot_baseline_math_eps_v11.m          Combined and separate Baseline figures
plot_basin_corruption_levels_v11_eps.m Basin figure
pub_style_v11.m                       Publication typography and dimensions
style_axis_v11.m                      Axis styling
lighten_color_v11.m                   IQR band color helper
export_eps_v11.m                      FIG and EPS export
