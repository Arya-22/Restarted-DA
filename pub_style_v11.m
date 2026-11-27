function s = pub_style_v11()
%PUB_STYLE_V11 We define the publication style used for the final figures.
s.font = 'Times New Roman';
s.fontSize = 10;
s.labelSize = 11;
s.legendSize = 10;
s.titleSize = 11;
s.lineWidth = 1.45;
s.bandLineWidth = 0.8;
s.axisWidth = 0.8;
s.markerSize = 5.0;
s.fullWidthCm = 17.2;
s.fullHeightCm = 8.2;
s.singleWidthCm = 8.6;
s.singleHeightCm = 7.6;
s.logFloor = 1e-12;
s.successTol = 1e-4;
s.colors = [
    0.0000 0.4470 0.7410
    0.8500 0.3250 0.0980
    0.9290 0.6940 0.1250
    0.4940 0.1840 0.5560
    0.4660 0.6740 0.1880
];
s.lineStyles = {'-','--','-.',':','-'};
s.markers = {'o','^','s','v','d'};
end
