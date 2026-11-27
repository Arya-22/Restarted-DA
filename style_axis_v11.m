function style_axis_v11(ax,s,xlimv,ylimv,useLogY)
%STYLE_AXIS_V11 We apply consistent typography, axis limits, and grid styling.
if nargin<5, useLogY=false; end
set(ax,'FontName',s.font,'FontSize',s.fontSize,'LineWidth',s.axisWidth, ...
    'TickDir','out','TickLength',[0.014 0.014],'Box','on','Layer','top');
if useLogY, set(ax,'YScale','log'); end
if ~isempty(xlimv), xlim(ax,xlimv); end
if ~isempty(ylimv), ylim(ax,ylimv); end
grid(ax,'on'); ax.GridAlpha=0.12; ax.MinorGridAlpha=0.05;
try, ax.Toolbar.Visible='off'; end
try, disableDefaultInteractivity(ax); end
drawnow;
ti=ax.TightInset;
ax.LooseInset=[ti(1)+0.004 ti(2)+0.004 ti(3)+0.004 ti(4)+0.004];
end
