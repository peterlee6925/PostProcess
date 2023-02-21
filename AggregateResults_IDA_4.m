%% Aggregate MSA results
% Peter Jeonghyun Lee
% 9/1/2022

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
model_no = 10;
IDA_path = strcat('C:\Users\peter\OneDrive\Desktop\IDA\BridgeModel_1970_2Span_1Column-0_IDA_2\IDAData_N49T1_',num2str(model_no),'.mat');

parameter_path = strcat('C:\Users\peter\OneDrive\Desktop\IDA\BridgeModel_1970_2Span_1Column-0_IDA_2\Structural Parameters\Column_Comparison_Parameters.csv');

summary_path = strcat('Summary_',num2str(model_no),'.csv');
extracted_path = strcat('Summary_Extracted_',num2str(model_no),'.csv');

%% load file
IDAData = importdata(IDA_path);
nGM = length(IDAData);
gmsData = readtable('C:\Users\peter\OneDrive\Desktop\IDA\BridgeModel_1970_2Span_1Column-0_IDA_2\Ground_Motions\N49T1\IDA_GroundMotion_IMs.csv');
parameterData = readtable(parameter_path);

%% GMS results
% remove quotes from gm names
gmsData{:,1} = erase(gmsData{:,1},"'");
% remove txt from gm names
gmsData{:,1} = erase(gmsData{:,1},'.txt');

%% IDA results
Sa = [];
eps_top_abs_max = [];
range_eps_top = [];
FI_top_max = [];
eps_bot_abs_max = [];
range_eps_bot = [];
FI_bot_max = [];
curv_top_max = [];
curv_bot_max = [];

gm_names = [];

for GM_index = 1:1:nGM
    IDAData_GM = IDAData{GM_index,1};
    % GM name
    gm_names = vertcat(gm_names,IDAData_GM.curdir);
%     gm_names = erase(gm_names,['./Analysis_Results/IDA_',num2str(model_no),'/N49T1/']);
    gm_names = erase(gm_names,['./Analysis_Results/IDA/N49T1/']);

    scale_GM = [];
    for i = 1:1:length(IDAData_GM.curdir)
        scale_GM(i,1) = str2double(IDAData_GM.curdir{i}(end-3:end));
    end
    Sa = vertcat(Sa,scale_GM);

    % eps top absolute max
    eps_top_abs_max_GM = max(abs(IDAData_GM.eps_top_max),abs(IDAData_GM.eps_top_min));
    eps_top_abs_max = vertcat(eps_top_abs_max,eps_top_abs_max_GM);
    % eps top range (max - min)
    range_eps_top_GM = IDAData_GM.eps_top_max - IDAData_GM.eps_top_min;
    range_eps_top = vertcat(range_eps_top,range_eps_top_GM);
    % FI top max
    FI_top_max_GM = IDAData_GM.FI_top_max;
    FI_top_max = vertcat(FI_top_max,FI_top_max_GM);
    % eps bot absolute max
    eps_bot_abs_max_GM = max(abs(IDAData_GM.eps_bot_max),abs(IDAData_GM.eps_bot_min));
    eps_bot_abs_max = vertcat(eps_bot_abs_max,eps_bot_abs_max_GM);
    % eps bot range (max - min)
    range_eps_bot_GM = IDAData_GM.eps_bot_max - IDAData_GM.eps_bot_min;
    range_eps_bot = vertcat(range_eps_bot,range_eps_bot_GM);
    % FI bot max
    FI_bot_max_GM = IDAData_GM.FI_bot_max;
    FI_bot_max = vertcat(FI_bot_max,FI_bot_max_GM);
    % max curvature - top 
    curv_top_max = vertcat(curv_top_max,IDAData_GM.curv_top_max);
    % max curvature - bottom
    curv_bot_max = vertcat(curv_bot_max,IDAData_GM.curv_bot_max);    
end

%% max of max values
FI_top_max_max = max(FI_top_max,[],2);
FI_top_max_freq = sum((FI_top_max >= 1),2)/size(FI_top_max,2);
% filter zero values
FI_top_max_freq_index = (FI_top_max_freq == 0);
FI_top_max_freq(FI_top_max_freq_index) = 1e-3;

FI_bot_max_max = max(FI_bot_max,[],2);
FI_bot_max_freq = sum((FI_bot_max >= 1),2)/size(FI_bot_max,2);
% filter zero values
FI_bot_max_freq_index = (FI_bot_max_freq == 0);
FI_bot_max_freq(FI_bot_max_freq_index) = 1e-3;

range_eps_top_max = max(range_eps_top,[],2);
range_eps_bot_max = max(range_eps_bot,[],2);
curv_max = max(abs(curv_top_max),abs(curv_bot_max));

%% structural parameters
reinforcementRatio = ones(length(Sa),1)*parameterData{model_no+1,2};
reinforcementRatio = table(reinforcementRatio);
columnDiameter = ones(length(Sa),1)*parameterData{model_no+1,3};
columnDiameter = table(columnDiameter);
slendernessRatio = ones(length(Sa),1)*parameterData{model_no+1,4};
slendernessRatio = table(slendernessRatio);
fApplied = ones(length(Sa),1)*parameterData{model_no+1,5};
fApplied = table(fApplied);
longBarFy = ones(length(Sa),1)*parameterData{model_no+1,6};
longBarFy = table(longBarFy);

%% combine values
% remove scale from gm names
for gm = 1:1:length(gm_names)
    gm_names_split = strsplit(gm_names{gm},'/');
    gm_names{gm} = gm_names_split{1};
end

results = table(gm_names,Sa);
results = renamevars(results,["gm_names"],['GroundMotion']);

summary = join(results,gmsData);

extracted_values = table(range_eps_top_max,range_eps_bot_max,FI_top_max_max,FI_bot_max_max,FI_top_max_freq,FI_bot_max_freq,curv_top_max,curv_bot_max,curv_max);
extracted = [summary,reinforcementRatio,columnDiameter,slendernessRatio,fApplied,longBarFy,extracted_values];   
extracted{:,2:end} = log(extracted{:,2:end});
writetable(extracted,extracted_path)

summary_values = table(eps_top_abs_max,range_eps_top,FI_top_max,eps_bot_abs_max,range_eps_bot,FI_bot_max,range_eps_top_max,range_eps_bot_max,FI_top_max_max,FI_bot_max_max,FI_top_max_freq,FI_bot_max_freq,curv_top_max,curv_bot_max,curv_max);
summary = [summary,reinforcementRatio,columnDiameter,slendernessRatio,fApplied,longBarFy,summary_values];
writetable(summary,summary_path)