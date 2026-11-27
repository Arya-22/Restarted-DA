function c = lighten_color_v11(c0, amount)
%LIGHTEN_COLOR_V11 We lighten a curve color to draw its interquartile band.
if nargin<2, amount=0.82; end
c = c0 + amount*(1-c0);
c = min(max(c,0),1);
end
