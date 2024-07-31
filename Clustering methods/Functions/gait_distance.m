function D = gait_distance(Data,num_Dof)
    m = length(Data);
    D = zeros(m,m);
    w = 0.5;
    % Double the weight for hip flexion, knee flexion, ankle plantar
    % flexion and foot progression
    % weight for 9DoF
    wt = [1,1,1,2,2,2,2,2,2];
    % Loop each gait cycle, perform pair wise DTWD to others cycles
    for i = 1:m
        for j = i:m
            if (i==j)
                D(i,j) = 0;
            else
                n1 = length(Data(i).Z_Kinematics);
                n2 = length(Data(j).Z_Kinematics);
                s1 = zeros(1,num_Dof,n1);
                s2 = zeros(1,num_Dof,n2);
                s1(1,:,:) = Data(i).Z_Kinematics';
                s2(1,:,:) = Data(j).Z_Kinematics';
                D(i,j) = dtw_d(s1,s2,w,wt);
            end
        end
    end
    % Mirror the matrix over the diagonal to complete the matrix
    for i = 2:m
        for j = 1:i
            D(i,j) = D(j,i);
        end
    end
end