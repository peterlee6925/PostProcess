%% Aggregate MSA results
% Peter Jeonghyun Lee
% 2/21/2023

%% Clear cache
clear all
close all
clc

%% Define plotting defaults
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','on','DefaultAxesYminortick','on',...
    'DefaultLineLineWidth',2,'DefaultLineMarkerSize',6,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',14,...
    'DefaultAxesFontWeight','bold',...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',14)

%% set up directory names
site = 'Vallejo';
RP = [224,475,975,2475,4975,9950];

MSA_path = strcat('C:\Users\peter\OneDrive\Desktop\BridgeModel_1970_2Span_1Column-0\MSAData_gmsdata',site,'T1CSDwop.mat');
gms_path = strcat('C:\Users\peter\OneDrive\Desktop\GroundMotionSelection\Completed\gmsdata',site,'T1CSDwop.mat');
summary_path = strcat('Summary_',site,'.csv');

%% load file
MSAData = importdata(MSA_path);
gmsData = importdata(gms_path);

%% GMS results
Sa = [];
Sa_ratio = [];
gm_names = [];
return_period = [];

for RP_index = 1:1:6
    % return period
    return_period = vertcat(return_period,ones(100,1)*RP(RP_index));
    gmsData_RP = gmsData{RP_index,1};
    % Sa(1s)
    Sa = vertcat(Sa,gmsData_RP.gmsPSA(:,100));
    % Sa ratio Sa(1s)/mean(Sa(0.02s)-Sa(3s))
    Sa_mean_RP = mean(gmsData_RP.gmsPSA(:,2:300),2);
    Sa_ratio_RP = gmsData_RP.gmsPSA(:,100)./Sa_mean_RP;
    Sa_ratio = vertcat(Sa_ratio,Sa_ratio_RP);
    % GM names
    gm_names = vertcat(gm_names,gmsData_RP.gmsname);
    gm_names = erase(gm_names,'.txt');
end

gms = table(return_period,gm_names,Sa,Sa_ratio);

%% MSA results
eps_top_abs_max = [];
range_eps_top = [];
eps_bot_abs_max = [];
range_eps_bot = [];
gm_names = [];
return_period = [];
curv_top_max = [];
curv_bot_max = [];

for RP_index = 1:1:6
    % return period
    return_period = vertcat(return_period,ones(100,1)*RP(RP_index));
    MSAData_RP = MSAData{RP_index,1};
    % eps top absolute max
    eps_top_abs_max_RP = max(abs(MSAData_RP.eps_top_max),abs(MSAData_RP.eps_top_min));
    eps_top_abs_max = vertcat(eps_top_abs_max,eps_top_abs_max_RP);
    % eps top range (max - min)
    range_eps_top_RP = MSAData_RP.eps_top_max - MSAData_RP.eps_top_min;
    range_eps_top = vertcat(range_eps_top,range_eps_top_RP);
    % eps bot absolute max
    eps_bot_abs_max_RP = max(abs(MSAData_RP.eps_bot_max),abs(MSAData_RP.eps_bot_min));
    eps_bot_abs_max = vertcat(eps_bot_abs_max,eps_bot_abs_max_RP);
    % eps bot range (max - min)
    range_eps_bot_RP = MSAData_RP.eps_bot_max - MSAData_RP.eps_bot_min;
    range_eps_bot = vertcat(range_eps_bot,range_eps_bot_RP);
    % max curvature - top 
    curv_top_max = vertcat(curv_top_max,MSAData_RP.curv_top_max);
    % max curvature - bottom
    curv_bot_max = vertcat(curv_bot_max,MSAData_RP.curv_bot_max);
    % GM names
    gm_names = vertcat(gm_names,MSAData_RP.curdir);
    MSA_remove = strcat('./Analysis_Results/MSA/gmsdata',site,'T1CSDwop/RP',num2str(RP(RP_index)),'/');
    gm_names = erase(gm_names,MSA_remove);
    gm_names = erase(gm_names,'/');
end

curv_max = max(abs(curv_bot_max),abs(curv_top_max));
results = table(return_period,gm_names,eps_top_abs_max,range_eps_top,eps_bot_abs_max,range_eps_bot,curv_top_max,curv_bot_max,curv_max);

%% join based on RP and GM name
summary = join(gms,results,'Keys',[1,2]);
writetable(summary,summary_path)  