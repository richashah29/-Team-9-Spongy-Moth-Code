%% ------------- MAIN SCRIPT -------------
% This script performs parameter optimization for model 1 of the spongy
% moth and foliage ode system
% It loads defoliation data from 1980-20023 and optimizes model parameters
% using the custom inverse_cost_function and plots the model fit against
% the observed data

% output - figure with plots showing:
% 1. observed vs predicted defoliation
% 2. estimated moth population over time

clear; clc;

%% ----------  LOAD DATA --------------
time_data = (1980:2023)'; 
defoliation_data = [0;0.0056;0.0169;0.0562;0.1405;0.0843;0.0112;0.0225;0.0674; ...
    0.1686;0.2248;0.0843;0.0169;0.0056;0.0112;0.0281;0.0056;0;0.0112; ...
    0.0843;0.1124;0.0393;0.0056;0.0028;0.0056;0.0028;0;0;0.0028;0.0056; ...
    0.0112;0.0056;0.0028;0.0011;0;0.0056;0.0112;0.0169;0.0281;0.0450; ...
    0.1124;1;0.0126;0.0014];

%% ---------- PARAMETER BOUNDS AND INITIAL GUESSES ----------
% define ecological realisitc bounds for each parameter
% order: [r, K, β, α, r_F, γ, N0, F0]
lb = [0.1,  10, 0.1,  1, 0.01, 0.01,  0.01, 0.1]; % Lower bounds
ub = [5.0, 200, 5.0, 50, 1.00, 1.00, 10.00, 1.0]; % Upper bounds
param_guess = [0.5, 80, 0.5, 10, 0.3, 0.05, 0.1, 0.95]; % initial guess, starting values for optimization algorithm

%% -------------- OPTIMIZATION ---------------
% use fmincon to search for the best parameters
options = optimoptions('fmincon', 'Display', 'iter', 'MaxFunctionEvaluations', 5000,'Algorithm', 'sqp');
% inverse_cost_function calls the unique cost function we created to calculate the 
best_params = fmincon(@(p) inverse_cost_function(p, time_data, defoliation_data), ...
                     param_guess, [], [], [], [], lb, ub, [], options);

% Unpack the determined best parameters vector
params_ode = best_params(1:6); % ODE parameters (first 6)
N0 = best_params(7); % moth population
F0 = best_params(8); % foliage fraction

% Solve the ode using the determined best parameters
[t_final, Y_final] = ode45(@(t,Y) moth_foliage_ode(t, Y, params_ode), ...
                           [min(time_data):max(time_data)], ...
                           [N0, F0]);

% Determine the defolation and moth population fit by interpolating between points in the solution vector calculated by <ode45> 
N_estimated = interp1(t_final, Y_final(:,1), time_data); % estimate the moth population
F_estimated = interp1(t_final, Y_final(:,2), time_data); % estimate the foliage fraction
Defoliation_estimated = 1 - F_estimated; % estimate the defolation using the estimated folation fraction

%% --------------- PLOTTING GRAPHS -------------
figure;

% subplot 1: defoliation comparison
subplot(2,1,1);
plot(time_data, defoliation_data, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Observed Defoliation');
hold on;
plot(time_data, Defoliation_estimated, 'r-', 'LineWidth', 2, 'DisplayName', 'Model Fit');
ylabel('Defoliation (1-F)');
legend;
title('Defoliation from 1980-2023 Caused by Spongy Moth');
grid on;
set(gca, 'GridColor', [0.5 0.5 0.5], 'GridAlpha', 0.2);

% subplot 2: plotting the moth population
subplot(2,1,2);
plot(time_data, N_estimated, 'b-', 'LineWidth', 2);
ylabel('Moth Population N(t)');
xlabel('Year');
title('Estimated Moth Population (Model 1)');
grid on;
set(gca, 'GridColor', [0.5 0.5 0.5], 'GridAlpha', 0.2);