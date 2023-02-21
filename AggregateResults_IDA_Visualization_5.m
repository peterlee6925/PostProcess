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
sa_collapse_list = [];
FI_fragility = importdata('FI_fragility.mat');
for model_no = 10:1:10


    %% load file
    results_path = strcat('C:\Users\peter\OneDrive\Desktop\IDA\BridgeModel_1970_2Span_1Column-0_IDA_2\Summary_',num2str(model_no),'.csv');
    results = readtable(results_path);
    
    limit = 0.0058;
    
    % find starting and stopping points
    start_idx = find(results{:,2} == 0.1);
    
    % plot Sa value vs. curv max
    figure(1)
    hold on
    for i = 1:1:length(start_idx)-1
        idx = start_idx(i):start_idx(i+1)-1;
        plot(results{idx,end},results{idx,2},'LineWidth',0.5,'Color',[0 0.4470 0.7410 0.5])
    end
    for i = length(start_idx)
        idx = start_idx(i):size(results,1);
        plot(results{idx,end},results{idx,2},'LineWidth',0.5,'Color',[0 0.4470 0.7410 0.5])
    end
    sgtitle(['Model ' num2str(model_no)])
    xlabel('Maximum curvature [1/in]')
    ylabel('Sa [g]')
    xlim([0 0.005])
    
    % find Sa collapse
    for i = 1:1:length(start_idx)-1
        idx = start_idx(i):start_idx(i+1)-1;
        curv_ind = results{idx,end};
        sa_ind = results{idx,2};
        if ~isempty(find(curv_ind>limit))
            exceed_index = min(find(curv_ind>limit));
            sa_collapse(i,1) = sa_ind(exceed_index);
            sa_ratio(i,1) = results{start_idx(i),4};
        else
            sa_collapse(i,1) = NaN;
            sa_ratio(i,1) = NaN;
        end
    end
    for i = length(start_idx)
        idx = start_idx(i):size(results,1);
        curv_ind = results{idx,end};
        sa_ind = results{idx,2};
        if ~isempty(find(curv_ind>limit))
            exceed_index = min(find(curv_ind>limit));
            sa_collapse(i,1) = sa_ind(exceed_index);
            sa_ratio(i,1) = results{start_idx(i),4};
        else
            sa_collapse(i,1) = NaN;
            sa_ratio(i,1) = NaN;
        end
    end
    % create total sa collapse list
    sa_collapse_list = [sa_collapse_list;sa_collapse];

    % compare Sa collapse and Sa ratio
    figure(2)
    hold on
    scatter(sa_ratio,sa_collapse,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor',	[0 0.4470 0.7410])
    xlabel('Sa_{ratio} [-]')
    ylabel('Sa_{collapse} [g]')
%     set(gca, 'XScale', 'log')
%     set(gca, 'YScale', 'log')
%     ylim([0 10])

    figure(3)
    hold on
    [f1,x1]=ecdf(sa_collapse);
    plot(x1,f1,'color',[.7 .7 .7],'LineWidth',0.5)
    xlabel('Sa_{collapse}')
    ylabel('Cumulative probability')
end

figure(3)
hold on
[f2,x2]=ecdf(FI_fragility);
plot(x2,f2,'color',[0.8500 0.3250 0.0980],'LineWidth',1)
[f1,x1]=ecdf(sa_collapse_list);
plot(x1,f1,'color',[0 0.4470 0.7410],'LineWidth',1)
xlabel('Sa')
ylabel('Cumulative probability')
legend('First bar fracture','Collapse','Location','Southeast')
xlim([0 6])