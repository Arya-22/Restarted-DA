function [figFile,epsFile] = export_eps_v11(fig,outFile)
%EXPORT_EPS_V11 We save each final figure as an editable FIG and vector EPS.
% We deliberately keep the figure open after export so that it remains
% available for inspection and further editing in MATLAB.

[pathstr,name,~] = fileparts(outFile);
if isempty(pathstr), pathstr = pwd; end
if ~exist(pathstr,'dir'), mkdir(pathstr); end
figFile = fullfile(pathstr,[name '.fig']);
epsFile = fullfile(pathstr,[name '.eps']);

set(fig,'Color','w','Renderer','painters','InvertHardcopy','off', ...
    'PaperPositionMode','auto','MenuBar','figure','ToolBar','figure');
axs = findall(fig,'Type','axes');
for k = 1:numel(axs)
    try
        axs(k).Toolbar.Visible = 'on';
        enableDefaultInteractivity(axs(k));
    catch
        % We retain compatibility with MATLAB releases without this feature.
    end
end

savefig(fig,figFile);
print(fig,epsFile,'-depsc2','-painters','-r600');
fprintf('Saved editable FIG: %s\n',figFile);
fprintf('Saved vector EPS:   %s\n',epsFile);
end
