
%% ----------- MAIN SCRIPT ---------------

% This script performs parameter optimization for model 3 of the spongy moth and foliage ode system
% It loads defoliation data from 1986-1993 optimizes model parameters using lsqnonlin and plots model fit against observed data

% output - figure with plots showing:
% 1. observed vs predicted defoliation
% 2. estimated moth population over time

%%  ---------- LOAD DATA -----------------
datasets = {
    {"Full Dataset", (1980:2023)', [0;0.0056;0.0169;0.0562;0.1405;0.0843;0.0112;0.0225;0.0674; ...
     0.1686;0.2248;0.0843;0.0169;0.0056;0.0112;0.0281;0.0056;0;0.0112; ...
     0.0843;0.1124;0.0393;0.0056;0.0028;0.0056;0.0028;0;0;0.0028;0.0056; ...
     0.0112;0.0056;0.0028;0.0011;0;0.0056;0.0112;0.0169;0.0281;0.0450; ...
     0.1124;1;0.0126;0.0014]},
    
    {"1986–1993", (1986:1993)', [0.0112;0.0225;0.0674;0.1686;0.2248;0.0843;0.0169;0.0056]}, 
    {"1980–1986", (1980:1986)', [0;0.0056;0.0169;0.0562;0.1405;0.0843;0.0112]},
    {"1997–2003", (1997:2003)', [0;0.0112;0.0843;0.1124;0.0393;0.0056;0.0028]},
    {"2018–2023", (2018:2023)', [0.0281;0.0450;0.1124;1;0.0126;0.0014]}
};


% RUN_MODEL for each dataset and store in results
results = cell(size(datasets));

for i = 1:length(datasets)
    [bestParams, F_fit, N_fit, D_fit] = run_model(...
        datasets{i}{2}, datasets{i}{3}, datasets{i}{1});
    
    results{i} = struct(...
        'name', datasets{i}{1}, ...
        'time', datasets{i}{2}, ...
        'defoliation', datasets{i}{3}, ...
        'params', bestParams, ...
        'F_fit', F_fit, ...
        'N_fit', N_fit, ...
        'D_fit', D_fit);
end


%% --------- PLOTTING GRAPHS -------------
figure(1);
full_result = results{1};

% subplot 1: comparing defoliation model and data
subplot(2,1,1);
plot(full_result.time, full_result.defoliation, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Observed Defoliation'); 
hold on;
plot(full_result.time, full_result.D_fit, 'r-', 'LineWidth', 2, 'DisplayName', 'Model Fit');
ylabel('Defoliation (1-F)');
legend;
title('Defoliation from 1980-2023 Caused by Spongy Moth');
grid on;
set(gca, 'GridColor', [0.5 0.5 0.5], 'GridAlpha', 0.2);

% subplot 2 plotting moth population
subplot(2,1,2);
plot(full_result.time, full_result.N_fit, 'b-', 'LineWidth', 2);
ylabel('Moth Population N(t)');
xlabel('Year');
title('Estimated Moth Population from 1980-2023 (Model 3)');
grid on;
set(gca, 'GridColor', [0.5 0.5 0.5], 'GridAlpha', 0.2);

set(gcf, 'Position', [100, 100, 800, 600]);


% plot separate datasets in a tile layout
figure(2);
t = tiledlayout(4,2, "TileSpacing","compact");

for i = 2:length(datasets)
    result = results{i};
    
    % defoliation graph
    ax1 = nexttile;
    plot(result.time, result.defoliation, 'ko', 'MarkerFaceColor','k'); 
    hold on;
    plot(result.time, result.D_fit, 'r-', 'LineWidth', 2);
    xlabel("Year"); ylabel("Defoliation (1-F)");
    title("Defoliation (" + result.name + ')');
    grid on;
    
    % moth population graph
    ax2 = nexttile;
    plot(result.time, result.N_fit, 'b-', 'LineWidth', 2);
    xlabel("Year"); ylabel("Moth Population N(t)");
    title("Spongy Moth Population (" + result.name + ')');
    grid on;
end

title(t, "Spongy Moth Model Analysis Across Different Time Periods", "FontSize", 14, "FontWeight", "bold");
set(gcf, 'Position', [100, 100, 1000, 1200]);