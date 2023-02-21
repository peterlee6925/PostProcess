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
sa_FI_list = [];
for model_no = 10:1:10

    %% load file
    results_path = strcat('C:\Users\peter\OneDrive\Desktop\IDA\BridgeModel_1970_2Span_1Column-0_IDA_2\Summary_',num2str(model_no),'.csv');
    results = readtable(results_path);
    
    limit = 1;
    
    % find starting and stopping points
    start_idx = find(results{:,2} == 0.1);
    
    % find Sa FI = 1 - Column 1
    for i = 1:1:length(start_idx)-1
        idx = start_idx(i):start_idx(i+1)-1;
        FI_top_ind = results.FI_top_max_max(idx);
        sa_ind = results{idx,2};
        if ~isempty(find(FI_top_ind>limit))
            exceed_index = min(find(FI_top_ind>limit));
            sa_FI(i,1) = sa_ind(exceed_index);
            sa_ratio(i,1) = results{start_idx(i),4};
        else
            sa_FI(i,1) = NaN;
            sa_ratio(i,1) = NaN;
        end
    end
    for i = length(start_idx)
        idx = start_idx(i):size(results,1);
        FI_top_ind = results.FI_top_max_max(idx);
        sa_ind = results{idx,2};
        if ~isempty(find(FI_top_ind>limit))
            exceed_index = min(find(FI_top_ind>limit));
            sa_FI(i,1) = sa_ind(exceed_index);
            sa_ratio(i,1) = results{start_idx(i),4};
        else
            sa_FI(i,1) = NaN;
            sa_ratio(i,1) = NaN;
        end
    end
    % create total sa FI list
    sa_FI_list = [sa_FI_list;sa_FI];

    % compare Sa FI and Sa ratio
    figure(3)
    hold on
    scatter(sa_ratio,sa_FI,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor',[0 0.4470 0.7410])
    xlabel('Sa_{ratio} [-]')
    ylabel('Sa_{FI=1} [g]')
%     set(gca, 'XScale', 'log')
%     set(gca, 'YScale', 'log')
%     ylim([0 10])
%     sgtitle(['Single Column,', ' pre-1971'])
    sgtitle(['Model ', num2str(model_no)])
    xlabel('Sa_{ratio} [-]')
    ylabel('Sa_{FI=1} [g]')

    figure(4)
    hold on
    [f1,x1]=ecdf(sa_FI);
    plot(x1,f1,'color',[.7 .7 .7],'LineWidth',0.5)
    xlabel('Sa_{FI=1}')
    ylabel('Cumulative probability')
end

figure(4)
hold on
[f1,x1]=ecdf(sa_FI_list);
plot(x1,f1,'color',[0 0.4470 0.7410],'LineWidth',1)
sgtitle('Column 1')
xlabel('Sa_{FI=1}')
ylabel('Cumulative probability')
xlim([0 5])

% 
% figure(7)
% hold on
% for i = 1:1:length(start_idx)-1
%     idx = start_idx(i):start_idx(i+1)-1;
%     plot(results.scales,results.FI_top_max_freq_1,'LineWidth',0.5,'Color',[0 0.4470 0.7410 0.5])
% end
% for i = length(start_idx)
%     idx = start_idx(i):size(results,1);
%     plot(results.scales,results.FI_top_max_freq_1,'LineWidth',0.5,'Color',[0 0.4470 0.7410 0.5])
% end
% sgtitle(['Model ' num2str(model_no), ' Column 1'])
% xlabel('Sa [g]')
% ylabel('Frequency of FI > 1')
% 
% figure(8)
% hold on
% for i = 1:1:length(start_idx)-1
%     idx = start_idx(i):start_idx(i+1)-1;
%     plot(results.scales,results.FI_top_max_freq_2,'LineWidth',0.5,'Color',[0 0.4470 0.7410 0.5])
% end
% for i = length(start_idx)
%     idx = start_idx(i):size(results,1);
%     plot(results.scales,results.FI_top_max_freq_2,'LineWidth',0.5,'Color',[0 0.4470 0.7410 0.5])
% end
% sgtitle(['Model ' num2str(model_no), ' Column 2'])
% xlabel('Sa [g]')
% ylabel('Frequency of FI > 1')
% 
% figure(9)
% hold on
% for i = 1:1:length(start_idx)-1
%     idx = start_idx(i):start_idx(i+1)-1;
%     scatter(results.scales,results.FI_bot_max_freq_1,'LineWidth',0.5,'Color',[0 0.4470 0.7410 0.5])
% end
% for i = length(start_idx)
%     idx = start_idx(i):size(results,1);
%     scatter(results.scales,results.FI_bot_max_freq_1,'LineWidth',0.5,'Color',[0 0.4470 0.7410 0.5])
% end
% sgtitle(['Model ' num2str(model_no), ' Column 1, Bottom'])
% xlabel('Sa [g]')
% ylabel('Frequency of FI > 1')