function dydt = moth_foliage_ode(t, Y, params)

% defines ODE on spongy moth and foliage dynamic system (model 2)

% Input:
%	t		- time (years)
%   Y 		- State vector [N; F]
%				- N = moth population density
%				- F = foliage fraction (between 0 and 1)
%   params 	- parameter vector [rB, K, beta, alpha, rF, gamma]
%				- rB = moth intrinsic growth rate
%				- K = carrying capacity of spongy moth
% 				- beta = maximum mortality rate of moth
% 				- alpha = saturation constant of moth
% 				- rF = foliate intrinsic growth rate
% 				- gamma = foliage consumption rate by moth 

% Output: 
% 	dydt	- derivative vector [dNdt; dFdt]
%			  represents the instantaneous change in moth population and foliage fraction 


    % ---- PARAMETER EXTRACTION ------
	% unpack parameter vector to meaningful names
    rB = params(1);    % moth growth rate
    K = params(2);     % moth carrying capacity  
    beta = params(3);  % moth mortality rate
    alpha = params(4); % moth saturation constant
    rF = params(5);    % foliage growth rate
    gamma = params(6); % defoliation rate
    
    % ---- EXTRACT POPULATION --------
    N = Y(1);  % moth population
    F = Y(2);  % foliage fraction
    
    % ------ ODE SYSTEM ------
    dNdt = rB * N * (1 - N/(K * F)) - beta * (N^2)/(alpha^2 + N^2); % rate of change of moth population
    dFdt = rF * F * (1 - F) - gamma * N * F;	% rate of change of foliage fraction (dF/dt)
    
	% ------ OUTPUT ------
    dydt = [dNdt; dFdt];
end