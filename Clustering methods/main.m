


%% Load data 
% Load iSCI Data
load('Dataset_iSCI.mat');
% Load Control Data
load('Dataset_Control.mat');
%% Perform DTW calculation for iSCI Data
% List of kinematics DoFs
angle_list = [{'PelvisAngles'},{'HipAngles'},{'KneeAngles'},{'AnkleAngles'},{'FootProgressAngles'}];
num_Dof = length(angle_list)+4;
% DTWD distance
tic
D = gait_distance(Data_iSCI,num_Dof);
toc
% Save the distance
save('Result\distance_SCI.mat','D');

%% Plot the dissimilarity matrix
% Load the matrix
load('distance_SCI.mat');
figure(1);
% Plot the matrix
plot_DTWmatrix(D);

%% Perform HAC on the DTWD matrix
m = length(Data_iSCI);
% Get the squareform of the matrix
y = squareform(D);
% Perform Ward-like linkage 
Z_a = Ward_Linkage(D);
save('Result\Ward_Linkage.mat','Z_a');
%% Plot the dendrogram
load('Ward_Linkage.mat');
figure(2);
[X_color,X_cluster] = plot_dendrogram(m,y,Z_a);

%% Plot cluster kinematics with controls
[Data_iSCI,gait_profile_iSCI] = get_gaitprofile_iSCI(Data_iSCI, nClusters, X_cluster,X_color);
gait_profile_Control = get_gaitprofile_Control(Data_Control);
figure(3);
set(gcf,'color','w');
plot_gait_profile_w_control(gait_profile_iSCI,gait_profile_Control,9);

%% Export Data
export_Data(Data_iSCI,Data_Control);






