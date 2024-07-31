function export_Data(Data_iSCI,Data_Control)
    % Initialize an empty table
    data_Gaitfeatures = table();
    data_Spatiotemporal = table();
    
    % Loop through each member of Data iSCI
    for i = 1:length(Data_iSCI)
        % Convert the nested struct to a table
        featureTable = struct2table(Data_iSCI(i).gait_features);
        stemporalTable = struct2table(Data_iSCI(i).spatio_temporal);
        subIDColumn = table(Data_iSCI(i).SubID, 'VariableNames', {'SubID'});
        groupColumn = table(Data_iSCI(i).Group, 'VariableNames', {'Group'});
        groupLabelColumn = table(string(Data_iSCI(i).GroupPattern), 'VariableNames', {'GroupPattern'});
        memberTable_gaitfeatures = [subIDColumn,featureTable, groupColumn, groupLabelColumn];
        memberTable_temporal = [subIDColumn,stemporalTable, groupColumn, groupLabelColumn];
        % Concatenate the current member's table to the overall table
        data_Gaitfeatures = [data_Gaitfeatures; memberTable_gaitfeatures];
        data_Spatiotemporal = [data_Spatiotemporal; memberTable_temporal];
    end
    % Loop through each member of Data Control
    for i = 1:length(Data_Control)
        featureTable = struct2table(Data_Control(i).gait_features);
        stemporalTable = struct2table(Data_Control(i).spatio_temporal);
        subIDColumn = table(Data_Control(i).SubID, 'VariableNames', {'SubID'});
        groupColumn = table(7, 'VariableNames', {'Group'});
        groupLabelColumn = table({'Control'}, 'VariableNames', {'GroupPattern'});
        memberTable_gaitfeatures = [subIDColumn,featureTable, groupColumn, groupLabelColumn];
        memberTable_temporal = [subIDColumn,stemporalTable, groupColumn, groupLabelColumn];
        % Concatenate the current member's table to the overall table
        data_Gaitfeatures = [data_Gaitfeatures; memberTable_gaitfeatures];
        data_Spatiotemporal = [data_Spatiotemporal; memberTable_temporal];
    end
    writetable(data_Gaitfeatures,'Result\gaitfeatures.csv');
    writetable(data_Spatiotemporal,'Result\spatiotemporal.csv');
end