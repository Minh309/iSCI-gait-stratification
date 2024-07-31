function [X_color,X_cluster] = plot_dendrogram(N, D, Z)
    % Choose number of clusters
    nClusters = 6;
    set(gcf,'color','w');
    leafOrder = optimalleaforder(Z,D);
    cutoff      = median([Z(end-nClusters+1,3) Z(end-nClusters+2, 3)]);
    l = dendrogram2(Z,0,'ColorThreshold',cutoff);
    set(l,'LineWidth',3)
    linesColor = cell2mat(get(l,'Color')); % get lines color; 
    colorList = unique(linesColor, 'rows');
    colorList = colorList(2:end,:);
    X_color     = zeros(N,3);
    X_cluster   = zeros(N,1);
    for iLeaf = 1:N
        [iRow, ~] = find(Z==iLeaf);
        color = linesColor(iRow,:); % !
        % assign color to each observation
        X_color(iLeaf,:) = color; 
        % assign cluster number to each observation
        X_cluster(iLeaf,:) = find(ismember(colorList, color, 'rows')); 
    end
    title('Ward-like HAC');
    set(gca,'XTickLabel','');
end