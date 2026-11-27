function score = curve_score(err, horizon)
%CURVE_SCORE We compute the log-error trajectory score on pilot instances only.
% Lower is better. This avoids choosing parameters solely by the final
% machine-precision value and instead rewards fast early/mid convergence.
if nargin < 2 || isempty(horizon)
    horizon = numel(err);
end
horizon = min(horizon,numel(err));
e = err(1:horizon);
e = max(e,1e-12);
score = mean(log10(e),'omitnan');
end
