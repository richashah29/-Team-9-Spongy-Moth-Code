
function [best_params, F_fit, N_fit, D_fit] = run_model(time_data, defoliation_data, dataset_name)
% finds the best parameters and solves ODE for the given dataset
%
% Inputs:
%   time_data      - time (years)
%   defoliation    - defoliation data
%   dataset_name   - name for display purposes
%
% Outputs:
%   bestParams     - best fit parameters [a,b,c,d,F0,N0]
%   F_fit, N_fit   - model predictions for F and N
%   D_fit          - predicted defoliation

    % Convert defoliation D(t) to foliation F(t) because the ODE uses F(t)
    foliation_data = 1 - defoliation_data;

%% ---------- PARAMETER BOUNDS AND INITIAL VALUES --------------
    lb = [0.00, 0.00, 0.00, 0.00, 0.0001, 0.0001];
    ub = [5.00, 5.00, 5.00, 5.00, 1.0, 10.0];
    params_guess = [0.5; 0.1; 0.5; 0.1; 0.9; 0.5];

%% ------------- OPTIMIZATION ---------------------
    options = optimoptions('lsqnonlin','Display','off','TolFun',1e-10,'TolX',1e-10);
    best_params = lsqnonlin( ...
        @(param) fit_Residuals(param, time_data, foliation_data, @lotka_volterra_ode), ...
        params_guess, lb, ub, options);

%% ------- PRINT BEST FIT PARAMETERS ----------
    paramNames = ["a","b","c","d","F0","N0"];
    disp("===== BEST FIT PARAMETERS for " + dataset_name + " =====");
    disp(table(paramNames', best_params, 'VariableNames', {'Parameter','Value'}));

    params_ode = best_params(1:4);
    F0 = best_params(5);
    N0 = best_params(6);

%% ------ SOLVE MODEL USING BEST-FIT PARAMETERS ------------
    sol = ode45(@(t,y) lotka_volterra_ode(t,y,params_ode), ...
                [time_data(1), time_data(end)], [F0, N0]);

    solY = deval(sol, time_data);
    F_fit = solY(1,:)';
    N_fit = solY(2,:)';
    D_fit = 1 - F_fit;
end