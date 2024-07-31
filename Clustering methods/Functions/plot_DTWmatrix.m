function plot_DTWmatrix(D)
    h = heatmap(D,'Colormap',jet);
    h.YDisplayData = flipud(h.YDisplayData);
    Ax = gca;
    Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
    grid off
    set(gcf,'color','w');
end