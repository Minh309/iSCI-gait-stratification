function plot_gait_profile_w_control(gait_profile,gait_profile_control,num_DoF)
%     f.Position = [10 -20 2000  600];
    Linethick = 0.5;
    x_axis = 0:100; %Set x-axis
    m = length(gait_profile);
    t = tiledlayout(num_DoF,m+1,"TileSpacing","compact");
    Labels = {
      'Pel AntTilt' [0 100 -10 35] 'Post      deg      Ant';
      'Pel Up' [0 100 -20 20] 'Down      deg      Up';
      'Pel IntRot' [0 100 -30 30] 'Ext      deg      Int';
      'Hip Flex' [0 100 -30 60] 'Ext      deg      Flex';
      'Hip Add' [0 100 -20 20] 'Abd      deg      Add';
      'Hip IntRot' [0 100 -30 40] 'Ext      deg      Int';
      'Knee Flex' [0 100 -15 90] 'Ext      deg      Flex';
      'Ankle Dors' [0 100 -40 50] 'Plan      deg      Dors';
      'Foot IntProg' [0 100 -45 20] 'Ext      deg      Int'};  
%     t.Position = [10 -20 2000  600];
    angle_list = [{'Pelvis_Flexion'},{'Pelvis_Obliquity'},{'Pelvis_Rotation'},...
                {'Hip_Flexion'},{'Hip_Adduction'}, {'Hip_Rotation'},...
                {'Knee_Flexion'},{'Ankle_Flexion'},{'FootProgression'}];
    for i = 1:num_DoF
        for j = 1:length(gait_profile)+1
            if (j == 1) %Plot control
                ax = nexttile((i-1)*(m+1)+1);
                n = length(gait_profile_control);
                color = [0.4, 0.4, 0.4];
                name = strcat('Control');
                    for k = 1:n
                        plot(x_axis,gait_profile_control(k).(string(angle_list(i))),...
                            'color',color,'LineWidth',Linethick);
                        if (k==1)
                            hold on
                            axis([Labels{i,2}]);
                            yline(0,'LineWidth',2,'LineStyle','--');
                        end
                        if (i==1)
                            title(name);
                        end
                        if (i == num_DoF)
                            xlabel('% GC');
                        end
                        if (i~=num_DoF)
                            set(ax,'XTick',[])
                        end
                        if (j==1)
                            ylabel(Labels{i,1});
                        end
                        if (j~= 1)
                            set(ax,'YTick',[])
                        end
                    end
            else
%             subplot(num_DoF,m,(i-1)*m+j);
                ax = nexttile((i-1)*(m+1)+j);
                n = gait_profile(j-1).numgaits;
                color = gait_profile(j-1).group_Kinematics(1).color(1,:);
                switch j-1
                    case 1
                        name = 'Blue';
                    case 2
                        name = 'Orange';
                    case 3
                        name = 'Violet';
                    case 4
                        name = 'Pink';
                    case 5
                        name = 'Green';
                    case 6
                        name = 'Cactus';
                end

%                 name = strcat('Pattern',' ',string(j-1));
                for k = 1:n
                    plot(x_axis,gait_profile(j-1).group_Kinematics(k).(string(angle_list(i))),...
                        'color',color,'LineWidth',Linethick);
                    if (k==1)
                        hold on
                        axis([Labels{i,2}]);
                        yline(0,'LineWidth',2,'LineStyle','--');
                    end
                    if (i==1)
                        title(name);
                    end
                    if (i == num_DoF)
                        xlabel('% GC');
                    end
                    if (i~=num_DoF)
                        set(ax,'XTick',[])
                    end
                    set(ax,'YTick',[]);
                end
            end
        end
    end
end