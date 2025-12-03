%% ------------- MAIN SCRIPT ---------------
% This script performs parameter optimization for model 2 of the spongy moth and foliage ode system
% It loads defoliation data from 1986-1993 optimizes model parameters using lsqnonlin and plots model fit against observed data

% output - figure with plots showing:
% 1. observed vs predicted defoliation
% 2. estimated moth population over time

%%  ---------- LOAD DATA -----------------
% only loaded the second peak data for observation
time_data = (1986:1993)'; 
defoliation_data = [0.0112;0.0225;0.0674;0.1686;0.2248;0.0843;0.0169;0.0056];

% Convert defoliation D(t) to foliation F(t) because the ODE uses F(t)
foliation_data = 1 - defoliation_data;

%% ---------- PARAMETER BOUNDS AND INITIAL GUESSES --------------
% define ecologically realistic bounds for each parameter
% order: [r, K, β, α, r_F, γ, N0, F0]
lb = [0.1,  10, 0.1,  1, 0.01, 0.01,  0.01, 0.1]; % lower bounds
ub = [5.0, 200, 5.0, 50, 1.00, 1.00, 10.00, 1.0]; % upper bounds
param_guess = [0.5; 80; 0.5; 10; 0.3; 0.05; 0.1; 0.95]; % initial guess, starting values for optimization algorithm

%% ------------- OPTIMIZATION ---------------------
options = optimoptions('lsqnonlin','Display','iter','TolFun',1e-8,'TolX',1e-8);

% lsqnonlin minimizes the sum of squares of residuals returned by fit_Residuals
% searches for parameters that best fit the data
best_params = lsqnonlin(@(param) fit_Residuals(param, time_data, foliation_data, @moth_foliage_ode), param_guess, lb, ub, options);

%% ------- PRINT BEST FIT PARAMETERS ----------
paramNames = ["r_B","K","beta","alpha","r_F","gamma","N0","F0"];
disp("===== BEST FIT PARAMETERS =====");
disp(table(paramNames', best_params, 'VariableNames', {'Parameter','Value'}));

%% ------ SOLVE MODEL USING BEST-FIT PARAMETERS ------------
% extract ODE best parameters (first 6) and initial conditions (last 2)
params_ode = best_params(1:6); % [r_B, K, beta, alpha, r_F, gamma]
N0 = best_params(7);
F0 = best_params(8);

% solve the ODE with the found best parameters 
sol = ode45(@(t,y) moth_foliage_ode(t,y,params_ode), [time_data(1), time_data(end)], [N0, F0]);
solF = deval(sol, time_data);
F_fit = solF(2,:)'; % predicted foliage values
N_fit = solF(1,:)'; % predicted moth population values

% convert foliation back to defoliation for comparison with data
D_fit = 1 - F_fit;

%% --------- PLOTTING GRAPHS -------------
figure;

% subplot 1: defoliation comparison
subplot(2,1,1);
plot(time_data, defoliation_data, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Observed Defoliation'); 
hold on;
plot(time_data, D_fit, 'r-', 'LineWidth', 2, 'DisplayName', 'Model Fit');
ylabel('Defoliation (1-F)');
legend;
title('Defoliation from 1980-2023 Caused by Spongy Moth');
grid on;
set(gca, 'GridColor', [0.5 0.5 0.5], 'GridAlpha', 0.2);

% subplot 2: predicted moth population
subplot(2,1,2);
plot(time_data, N_fit, 'b-', 'LineWidth', 2);
ylabel('Moth Population N(t)');
xlabel('Year');
title('Estimated Moth Population (Model 2)');
grid on;
set(gca, 'GridColor', [0.5 0.5 0.5], 'GridAlpha', 0.2);
set(gcf, 'Position', [100, 100, 800, 600]);






% Check for required toolboxes
% required_toolboxes = {'optimization_toolbox', 'statistics_toolbox'}; % Use short names

for i = 1:length(required_toolboxes)
    if license('test', required_toolboxes{i})
        fprintf('✓ %s is available\n', required_toolboxes{i});
    else
        fprintf('✗ %s is NOT available\n', required_toolboxes{i});
    end
end

% Alternative: Check using ver() which is more reliable
fprintf('\n--- Installed Toolboxes ---\n');
v = ver;
for i = 1:length(v)
    fprintf('%s\n', v(i).Name);
end