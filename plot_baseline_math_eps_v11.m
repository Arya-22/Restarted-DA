function plot_baseline_math_eps_v11(matFile,outDir,showIQR)
%PLOT_BASELINE_MATH_EPS_V11 We plot the final baseline results for the manuscript.
% We provide a combined two-panel figure and two separate single-panel figures.
% When showIQR is true, we display the 25th--75th percentile band.
if nargin<3, showIQR=true; end
S = load(matFile);
R = S.results;
s = pub_style_v11();
if ~exist(outDir,'dir'), mkdir(outDir); end
settings = {'corrupt_000','corrupt_010'};
titles = {'\nu = 0','\nu = 0.10'};

% We first create the combined two-panel figure.
fig = figure('Units','centimeters', ...
    'Position',[2 2 s.fullWidthCm s.fullHeightCm], ...
    'Color','w','MenuBar','figure','ToolBar','figure');
tl = tiledlayout(fig,1,2,'TileSpacing','compact','Padding','compact');
for a = 1:2
    ax = nexttile(tl);
    hold(ax,'on');
    plot_one(ax,R.(settings{a}),a,s,showIQR);
    title(ax,titles{a},'Interpreter','tex','FontName',s.font, ...
        'FontSize',s.titleSize,'FontWeight','normal');
end
export_eps_v11(fig,fullfile(outDir,'baseline_v11_combined.eps'));

% We then create one standalone figure for each corruption setting.
for a = 1:2
    fig = figure('Units','centimeters', ...
        'Position',[2 2 s.singleWidthCm s.singleHeightCm], ...
        'Color','w','MenuBar','figure','ToolBar','figure');
    ax = axes(fig);
    hold(ax,'on');
    plot_one(ax,R.(settings{a}),a,s,showIQR);
    title(ax,titles{a},'Interpreter','tex','FontName',s.font, ...
        'FontSize',s.titleSize,'FontWeight','normal');
    if a==1
        name = 'baseline_clean_v11.eps';
    else
        name = 'baseline_corrupt10_v11.eps';
    end
    export_eps_v11(fig,fullfile(outDir,name));
end
end

function plot_one(ax,B,a,s,showIQR)
% We summarize each method by its median trajectory and optional IQR band.
x = B.oracles(:)';
nmethods = 3 + (a==1);
names = B.method_names;
for j = 1:nmethods
    % The stored tensor is method x trial x oracle.
    E = squeeze(B.errors(j,:,:));
    med = median(E,1,'omitnan');
    lo = prctile(E,25,1);
    hi = prctile(E,75,1);
    med = max(med,s.logFloor);
    lo = max(lo,s.logFloor);
    hi = max(hi,s.logFloor);
    if showIQR
        bandColor = lighten_color_v11(s.colors(j,:),0.84);
        patch(ax,[x fliplr(x)],[lo fliplr(hi)],bandColor, ...
            'EdgeColor','none','FaceAlpha',1,'HandleVisibility','off');
    end
    idx = unique(round(linspace(1,numel(x),8)));
    plot(ax,x,med,'Color',s.colors(j,:), ...
        'LineStyle',s.lineStyles{j},'LineWidth',s.lineWidth, ...
        'Marker',s.markers{j},'MarkerIndices',idx, ...
        'MarkerSize',s.markerSize,'DisplayName',names{j});
end
xlabel(ax,'Oracle calls, N','Interpreter','tex', ...
    'FontName',s.font,'FontSize',s.labelSize);
ylabel(ax,'e_{rel}(x)','Interpreter','tex', ...
    'FontName',s.font,'FontSize',s.labelSize);
style_axis_v11(ax,s,[0 1500],[1e-12 2e-1],true);
lg = legend(ax,'Location','southoutside','Orientation','horizontal', ...
    'NumColumns',nmethods,'Box','off','Interpreter','none');
set(lg,'FontName',s.font,'FontSize',s.legendSize);
end
