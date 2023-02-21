%% Aggregate MSA results
% Peter Jeonghyun Lee
% 8/29/2022

%% Clear cache
clear all
close all
clc

%% Define plotting defaults
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on',...
    'DefaultAxesXminortick','on','DefaultAxesYminortick','on',...
    'DefaultLineLineWidth',2,'DefaultLineMarkerSize',6,...
    'DefaultAxesFontName','Arial','DefaultAxesFontSize',18,...
    'DefaultAxesFontWeight','bold',...
    'DefaultTextFontWeight','normal','DefaultTextFontSize',18)

%% set up directory names
site_list = {'Fresno','Bakersfield','MammothLakes','LongBeach','Pasadena'};
for i = 1:1:5
    site = site_list{i};
    RP = [224,475,975,2475,4975,9950];
    
    %% load file
    summary_path = strcat('C:\Users\peter\OneDrive\Desktop\BridgeModel_1970_2Span_1Column-0\Summary_',site,'.csv');
    
    summary = readtable(summary_path);
    
    % plot Sa value vs. curv max
    figure(1)
    hold on
    sgtitle(site)
    for RP_index = 1:1:6
        subplot(2,3,RP_index)
        idx = summary{:,1} == RP(RP_index);
        scatter(summary{idx,3},summary{idx,122})
        subtitle(['RP ',num2str(RP(RP_index))])
        xlim([0 2])
        xlabel('Sa(1s) [g]')
        ylabel('Maximum curvature [1/in]')
    end
    
    
    % subplot(2,3,2)
    % for RP_index = 3:1:3
    %     idx = summary{:,1} == RP(RP_index);
    %     scatter(summary{idx,3},summary{idx,121})
    % end
    % xlim([0 2])
    
    
    % plot Sa value vs. range eps max
    range = summary{:,34:62};
    range_eps_max = max(range,[],2);
    
    figure(2)
    hold on
    sgtitle(site)
    for RP_index = 1:1:6
        subplot(2,3,RP_index)
        idx = summary{:,1} == RP(RP_index);
        scatter(summary{idx,3},range_eps_max(idx,1),'MarkerFaceColor',[0.8500, 0.3250, 0.0980],'MarkerEdgeColor',[0.8500, 0.3250, 0.0980])
        subtitle(['RP ',num2str(RP(RP_index))])
        if RP_index <=3
            xlim([0 2])
        else
            xlim([0 5])
        end
        ylim([0 0.4])
        xlabel('Sa(1s) [g]')
        ylabel('Maximum range in strain [-]')
    end
    
    figure(3)
    hold on
    sgtitle(site)
    RP_index = 4;
    idx = summary{:,1} == RP(RP_index);
    scatter(summary{idx,3},summary{idx,122},'MarkerFaceColor','b')
    xlim([0 2])
    ylim([0 5e-3])
    xlabel('Sa(1s) [g]')
    ylabel('Maximum curvature [1/in]')
    
    sorted_sa = sort(summary{idx,3});
    sorted_curvature = sort(summary{idx,122});
    moving_average = movmean(sorted_curvature,3);
    
    figure(4)
    hold on
    plot(sorted_sa,moving_average)
    xlim([0 2])
    ylim([0 5e-3])
    xlabel('Sa(1s) [g]')
    ylabel('Maximum curvature [1/in]')
    legend('Fresno','Bakersfield','MammothLakes','LongBeach','Pasadena','Location','Southeast')
    
    % figure(4)
    % for RP_index = 6:1:6
    %     idx = summary{:,1} == RP(RP_index);
    %     scatter(summary{idx,3},range_eps_max(idx,1))
    % end
    % xlim([0 2])
end