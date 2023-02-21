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

%% location name
name = 'Bakersfield';
MSA_path = strcat('C:\Users\peter\OneDrive\Desktop\BridgeModel_1970_2Span_1Column-0\Results_Old\MSAData_gmsdata',name,'T1CSDwop.mat');
gms_path = strcat('C:\Users\peter\OneDrive\Desktop\GroundMotionSelection\Completed\gmsdata',name,'T1CSDwop.mat');
summary_path = strcat('Summary_',name,'.csv');
%% load file
% MSAData = importdata('MSAData_gmsdataBakersfieldT1CSDwop.mat');
MSAData = importdata(MSA_path);
gmsData = importdata(gms_path);


%% GMS results
Sa = [];
Sa_ratio = [];
gm_names = [];
for RP_index = 1:1:6
    gmsData_RP = gmsData{RP_index,1};
    Sa = vertcat(Sa,gmsData_RP.gmsPSA(:,100));
    Sa_mean_RP = mean(gmsData_RP.gmsPSA(:,2:300),2);
    Sa_ratio_RP = gmsData_RP.gmsPSA(:,100)./Sa_mean_RP;
    Sa_ratio = vertcat(Sa_ratio,Sa_ratio_RP);
    gm_names = vertcat(gm_names,gmsData_RP.gmsname);
end

gms = horzcat(Sa,Sa_ratio);
%% MSA results
curv_max=[];
eps_top_abs_max = [];
eps_bot_abs_max = [];
for RP_index = 1:1:6
    MSAData_RP = MSAData{RP_index,1};

    eps_top_abs_max_RP = max(MSAData_RP.eps_top_max,MSAData_RP.eps_top_min,'ComparisonMethod','abs');
    eps_top_abs_max = vertcat(eps_top_abs_max,eps_top_abs_max_RP);

    eps_bot_abs_max_RP = max(MSAData_RP.eps_bot_max,MSAData_RP.eps_bot_min,'ComparisonMethod','abs');
    eps_bot_abs_max = vertcat(eps_bot_abs_max,eps_bot_abs_max_RP);

    curv_max = vertcat(curv_max,MSAData_RP.curv_top_max);
end

results = horzcat(eps_top_abs_max,eps_bot_abs_max,curv_max);

summary = table(gm_names,gms,results);

writetable(summary,summary_path)  