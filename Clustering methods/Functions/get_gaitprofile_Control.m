function gait_profile_Control = get_gaitprofile_Control(Data_Control)
    angle_list = [{'Pelvis_Flexion'},{'Pelvis_Obliquity'},{'Pelvis_Rotation'},...
            {'Hip_Flexion'},{'Hip_Adduction'}, {'Hip_Rotation'},...
            {'Knee_Flexion'},{'Ankle_Flexion'},{'FootProgression'}];
    gait_profile_Control = struct();
    for j = 1:length(Data_Control)
        gait_profile_Control(j).SubID = Data_Control(j).SubID;
        for k = 1:length(angle_list)
            gait_profile_Control(j).(string(angle_list(k))) = Data_Control(j).norm_Kinematics(:,k);
        end
    end
end