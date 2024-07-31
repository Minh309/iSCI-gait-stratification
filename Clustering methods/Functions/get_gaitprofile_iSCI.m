function [Data_iSCI,gait_profile_iSCI] = get_gaitprofile_iSCI(Data_iSCI,nClusters, X_cluster, X_color)
    order = [5 1 6 3 2 4];
    % Update cluster label
    for i = 1:length(Data_iSCI)
        X_cluster(i) = order(X_cluster(i));
        Data_iSCI(i).Group = X_cluster(i);
        switch Data_iSCI(i).Group
            case 1
               Data_iSCI(i).GroupPattern = 'Blue';
            case 2
               Data_iSCI(i).GroupPattern = 'Orange';
            case 3
               Data_iSCI(i).GroupPattern = 'Violet';
            case 4
               Data_iSCI(i).GroupPattern = 'Pink';
            case 5
               Data_iSCI(i).GroupPattern = 'Green';
            case 6
               Data_iSCI(i).GroupPattern = 'Cactus';
        end
    end

    angle_list = [{'Pelvis_Flexion'},{'Pelvis_Obliquity'},{'Pelvis_Rotation'},...
                {'Hip_Flexion'},{'Hip_Adduction'}, {'Hip_Rotation'},...
                {'Knee_Flexion'},{'Ankle_Flexion'},{'FootProgression'}];
    
    gait_profile_iSCI = struct();
    for i = 1:nClusters
    index = find([Data_iSCI.Group] == i);
    gait_group = struct();
    for j = 1:length(index)
        gait_group(j).SubID = Data_iSCI(index(j)).SubID;
        gait_group(j).index = index(j);
        gait_group(j).color = X_color(index(j),:);
        for k = 1:length(angle_list)
            gait_group(j).(string(angle_list(k))) = Data_iSCI(index(j)).norm_Kinematics(:,k);
        end
    end
    gait_profile_iSCI(i).numgaits = length(index);
    gait_profile_iSCI(i).group_Kinematics = gait_group; 
    end
end
