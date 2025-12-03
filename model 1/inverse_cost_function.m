function err = inverse_cost_function(params, time_data, defoliation_data)
% compute the error between model prediction and observed data

% Input: 
%     params               - parameter vector [r, K, beta, alpha, rF, gamma]
%                               - r = moth intrinsic growth rate
%                               - K = carrying capacity of spongy moth
%                               - beta = maximum mortality rate of moth
%                               - alpha = saturation constant of moth
%                               - rF = foliate intrinsic growth rate
%                               - gamma = foliage consumption rate by moth 
%     time_data            - vector of observation time (years)
%     defoliation_data     - 
%
% Output: 
%     err                  - calculated error value for foliage (difference
%     between model prediction and observed data and regularlization term)

%% -------- PARAMETER EXTRACTION ----------
% unpack parameter vector to have meaningful names
r = params(1); % moth growth rate
K = params(2); % moth carrying capacity
beta = params(3); % moth mortality rate
alpha = params(4); % moth saturation constant
r_F = params(5); % foliage growth rate
gamma = params(6); % defoliation rate

% define iniital foliage (F0) and moth population (N0)
N0 = params(7); % moth population
F0 = params(8); % foliage fraction

% Create parameter vector for ODE (only the first 6 parameters)
params = [r, K, beta, alpha, r_F, gamma];

tspan = [min(time_data), max(time_data)]; % time span

%% ------ SOLVE ODE --------
% solving using MATLAB's ode45 solver
[t_ode, Y] = ode45(@(t,Y) moth_foliage_ode(t, Y, params), tspan, [N0, F0]);
F_model = interp1(t_ode, Y(:,2), time_data); % linearly interpolate foliation between solved points

%% -------- MODEL EVALUATION ----------
% convert foliation back to defoliation for comparison with data
defoliation_model = 1 - F_model; % defoliation is 1 - foliage_percent

% evaluate the error of the solution to the real data using sum of squared error
data_error = sum((defoliation_model - defoliation_data).^2, 'omitnan');

%% ------- REGULARIZATION -------
% regularlize so the parameters have more reasonable values
reg_error = 0.00001 * ((r - 1)^2 + (K - 100)^2 + (gamma - 0.1)^2);

%% --------- COMPUTE ERROR -------
err = data_error + reg_error; % combine sum of squared error with regularization term for total error
end