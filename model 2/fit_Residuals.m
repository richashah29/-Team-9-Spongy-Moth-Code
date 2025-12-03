function err = fit_Residuals(param, time_data, foliation_data, ode)
% compute residuals between model prediction and observed data 

% Input:
%   params 			- parameter vector [rB, K, beta, alpha, rF, gamma, N0, F0]
%						- rB = moth intrinsic growth rate
%						- K = carrying capacity of spongy moth
% 						- beta = maximum mortality rate of moth
% 						- alpha = saturation constant of moth
% 						- rF = foliate intrinsic growth rate
% 						- gamma = foliage consumption rate by moth 
% 						- N0 = initial moth population 
%						- F0 = initial foliage density
% 	time_data		- vector of observation time (years)
% 	foliation_data	- observed foliage fraction (1 - defoliation data)
%	ode 			- the ode system (@moth_foliage_ode)

% Output:
% 	err 	- residual vector for foliage (model prediction - observed data)


    % ----- PARAMETER EXTRACTION -----
	% unpack parameter vector to meaningful names
	rB = param(1); 	% moth growth rate
    K = param(2);		% moth carrying capacity  
    beta = param(3);	% moth mortality rate
    alpha = param(4);	% moth saturation constant
    rF = param(5);		% foliage growth rate
    gamma = param(6);	% defoliation rate
    N0 = param(7);		% initial moth population
    F0 = param(8);		% initial foliage density

    params = [rB, K, beta, alpha, rF, gamma];

    % ----- SOLVE ODE -----
	% solving using MATLAB's ode45 solver
	% ode should be moth_foliage_ode
    sol = ode45(@(t, y) ode(t, y, params), [time_data(1), time_data(end)], [N0, F0]);

    % ---- MODEL EVALUATION -----
	% evaluate the error of the solution at the observation times
	% solY(1, :) = moth population N(t)
	% solY(2, :) = foliage fraction F(t)
    solY = deval(sol, time_data);
    F_model = solY(2, :)';  
    err = F_model - foliation_data;  % calculates residuals
end