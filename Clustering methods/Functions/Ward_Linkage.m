function Z = Ward_Linkage(D)
    n = size(D,1);
    G = [];
    Gi = [];
    Z = zeros(n-1,3);
    index = [];
    for i = 1:n
        temp = struct();
        temp.member = i;
        temp.index = i;
        temp.prev_index = [];
        Gi = [Gi temp];
        index = [index i];
    end
    G = [G {Gi}]; 
    %% Dissimilarity measure (aggregation measure) between singletons
    added_index = n + 1; % This will be the index assigned to the merged cluster
    index = [index added_index];
    min_value = inf;
    index_u = 1;
    index_v = 1;
    Z_index = 1;
    
    % Get the number of singetons
    m = n;
    merge_cluster = [];
    for i = 1:m
        for j = i:m
            if (i==j)
                continue;
            end
            % Merge two cluster with index i and index j
            Gij = merge2clusters(G{1,1}(i),G{1,1}(j));
            % Calculate the loss of homogeneity
            I = cal_distance2(G{1,1}(i),G{1,1}(j),D);
            % Check if I is smaller than min value
            if (I<min_value)
                min_value = I;
                index_u = G{1,1}(i).index;
                index_v = G{1,1}(j).index;
                merge_cluster = Gij;
            end
        end
    end
    
    % Assign the index to new cluster
    merge_cluster.index = added_index;

    % Remove two clusters that will be merged together
    G{2,1} = remove_clusters(G{1,1},index_u,index_v);

    % Add the merge cluster at the end of the new partition
    G{2,1} = add_clusters(G{2,1},merge_cluster);

    % Update Z
    Z(1,1) = index_u;
    Z(1,2) = index_v;
    Z(1,3) = sqrt(min_value);

    for t = 2:n-1
        current_total_index = length(index);
        added_index = current_total_index + 1; % This will be the index assigned to the merged cluster
        index = [index added_index];
        min_value = inf;
        index_u = 1;
        index_v = 1;
        % Get the number of clusters
        m = size(G{t,1},2);
        merge_cluster = [];
        for i = 1:m
            for j = i:m
                if (i==j)
                    continue;
                end
                % Merge two cluster with index i and index j
                Gij = merge2clusters(G{t,1}(i),G{t,1}(j));
                % Calculate the loss of homogeneity
                if (j== m)
                    u = G{t,1}(m).prev_index(1);
                    v = G{t,1}(m).prev_index(2);
                    Gu = G{t-1,1}([G{t-1,1}.index] == u);
                    Gv = G{t-1,1}([G{t-1,1}.index] == v);
                    I = cal_distance3(Gu,Gv,G{t,1}(i),D);
                else
                    I = cal_distance2(G{t,1}(i),G{t,1}(j),D);
                end
                % Check if I is smaller than min value
                if (I<min_value)
                    min_value = I;
                    index_u = G{t,1}(i).index;
                    index_v = G{t,1}(j).index;
                    merge_cluster = Gij;
                end
            end
        end
        
        % Assign the index to new cluster
        merge_cluster.index = added_index;
    
        % Remove two clusters that will be merged together
        G{t+1,1} = remove_clusters(G{t,1},index_u,index_v);
    
        % Add the merge cluster at the end of the new partition
        G{t+1,1} = add_clusters(G{t+1,1},merge_cluster);
    
        % Update Z
        Z(t,1) = index_u;
        Z(t,2) = index_v;
        Z(t,3) = min_value;
    end
%     for t = 1:n-1
%         current_total_index = length(index);
%         added_index = current_total_index + 1;
%         index = [index added_index];
%         m = length(G{t,1});
%         min = inf;
%         index_u = 1;
%         index_v = 1;
%         %% Compute pair wise comparison among clusters G{t,1}
%         % Obtain the partition from m clusters, no merged cluster formed
%         if (Z_index == 1)
%             % Search through all clusters, compute the aggregation measures
%             % between 2 clusters and find the indexes u and v having
%             % smallest value
%             for i = 1:m
%                 for j = i:m
%                     if (i==j)
%                         % If i==j, meaning the distance is zero, no need to
%                         % compute
%                         continue;
%                     else
%                         d = cal_distance(G{t,1}(i),G{t,1}(j),D);
%                         if (d<min)
%                             min = d;
%                             index_u = G{t,1}(i).index;
%                             index_v = G{t,1}(j),index;
%                         end
%                     end
%                 end
%             end  
%         else
%             for i = 1:(m-1)
%                 for j = i:(m-1)
%                     if (i==j)
%                         continue;
%                     else
%                         %Compute the distance between two clusters without
%                         %accounting for the newly formed cluster from
%                         %previous step
%                         d = cal_distance(G{t,1}(i),G{t,1}(j),D);
%                         if (d<min)
%                             min = d;
%                             index_u = i;
%                             index_v = j;
%                         end
%                     end
%                 end
%             end
%             
%         end
%         % Get the smallest distance among clusters
%         
        % Merge two clusters by creating a new cluster containing all
        % members of the previous two at t

        % Remove cluster i and j having smallest distance from the list of
        % clusters

        % Add the new cluster to the list

        % Assign the new index for the new cluster

        % Copy the members of the rest of clusters to the new clusters
        % order, preparing for the next iteration

%     end
end

% This function is to add the new cluster from merging two clusters u and v
function G_new = add_clusters(G,Guv)
    G_new = cat(2,G, Guv);
end

% This function is to remove two clusters u and v from the partition set
% We based on the index of the two clusters
function G_new = remove_clusters(G,index_u,index_v)
    m = size(G,2);
    G_new = [];
    for i = 1:m
        Gi = G(i);
        if (Gi.index ~= index_u)&&(Gi.index ~= index_v)
            G_new = [G_new Gi]; 
        end
    end
end

% This function is to create a new cluster by merging all members of 2
% clusters u and v
function G = merge2clusters(Gu,Gv)
    % Check total member of group u
        n_u = size(Gu.member,2);
    % Check total member of group v
        n_v = size(Gv.member,2);
    member = [];
    for i = 1:n_u
        member = [member Gu.member(i)];
    end
    for i = 1:n_v
        member = [member Gv.member(i)];
    end
    
    prev_index = [Gu.index Gv.index];
    G.member = member;
    % index is empty and will be assigned at the end of each step
    G.prev_index = prev_index;
    G.index = [];
end

% This function is to calculate the pseudo_inertia of a cluster based on
% dissimilarity matrix
function I = pseudo_inertia(G,D)
    n = size(G.member,2);
    I = 0;
    for i = 1:n
        for j = 1:n
            index_i = G.member(i);
            index_j = G.member(j);
            I = I + D(index_i,index_j)^2;
        end
    end
    I = I/(2*n);
end

% This function is to calculate the increase of within-cluster inertia when
% merging two cluster u and v

function d = cal_distance2(Gu,Gv,D)
    % Create a new cluster by merging u and v
        Guv = merge2clusters(Gu,Gv);
    % Get the pseudo inertia of cluster u
        Iu = pseudo_inertia(Gu,D);
    % Get the pseudo inertia of cluster v
        Iv = pseudo_inertia(Gv,D);    
    % Get the pseudo inertia of cluster u+v
        Iuv = pseudo_inertia(Guv,D);
    % Calculate the distance
        d = Iuv - Iu - Iv;
end


% This function is to calculate the aggregation measures between new
% cluster u+v and any cluster t of partition set based on Lance and
% Williams equation

function d = cal_distance3(Gu,Gv,Gt,D)
    % Check total member of group u
        n_u = size(Gu.member,1);
    % Check total member of group v
        n_v = size(Gv.member,1);
    % Check total member of group v
        n_t = size(Gt.member,1);
    % Get the aggregation measures between u and t
        dut = cal_distance2(Gu,Gt,D);
    % Get the aggregation measures between v and t
        dvt = cal_distance2(Gv,Gt,D);    
    % Get the aggregation measures between u and v
        duv = cal_distance2(Gu,Gv,D);
    % Calculate the aggregation measure based on Lance and Williams equation
        d = (n_u+n_t)/(n_u + n_v + n_t)*dut +...
            (n_v+n_t)/(n_u + n_v + n_t)*dvt -...
            n_t/(n_u + n_v + n_t)*duv;
end
%     
%     % Calculate delta(Gu,Gv)
%     I1 = 0;
%     for i = 1:n_u
%         for j = 1:n_v
%             index_i = Gu(i).index;
%             index_j = Gv(j).index;
%             I1 = I1 + D(index_i,index_j)^2;
%         end
%     end
%     I1 = I1/(n_u*n_v);
%     % Calculate delta(Gu,Gu)
%     I2 = 0;
%     for i = 1:n_u
%         for j = 1:n_u
%             index_i = Gu(i).index;
%             index_j = Gu(j).index;
% 
%             I2 = I2 + D(index_i,index_j)^2;
%         end
%     end
%     I2 = I2/(2*n_u^2);
%     %Calculate delta(Gv,Gv)
%     I3 = 0;
%     for i = 1:n_v
%         for j = 1:n_v
%             index_i = Gv(i).index;
%             index_j = Gv(j).index;
% 
%             I3 = I3 + D(index_i,index_j)^2;
%         end
%     end
%     I3 = I3/(2*n_v^2);
% 
%     % Get the Ward's linkage value between cluster Gu and Gv
%     d = n_u*n_v/(n_u + n_v)*(I1-I2-I3);
% end