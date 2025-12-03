function dYdt = lotka_volterra_ode(t, Y, params)
% defines ODE on spongy moth and foliage dynamic system (Model 3)

% Input:
%   t       - time (years)
%   Y       - State vector [N; F]
%                 - N = moth population density
%                 - F = foliage fraction (between 0 and 1)
%  params:  - parameter vector [a, b, c, d]
%                 - a = foliage growth rate
%                 - b = foliage consumption rate by moths     
%                 - c = moth mortality rate     
%                 - d = moth growth rate from foliage
%
% Output:
%     dydt   - derivative vector [dNdt; dFdt]
%              represents the instantaneous change in moth population and foliage 


%% ---- PARAMETER EXTRACTION ------
    % unpack parameter vector to meaningful names
    a = params(1);  % foliage growth rate
    b = params(2);  % foliage consumption rate by moths
    c = params(3);  % moth mortality rate
    d = params(4);  % moth growth rate from foliage
    
%% ----- EXTRACT POPULATION -------
    F = Y(1);  % foliage
    N = Y(2);  % moth population
    
%% --------- ODE SYSTEM -------------
    dFdt = a * F - b * F * N; % foliage
    dNdt = -c * N + d * F * N; % moth population
    dYdt = [dFdt; dNdt];
 
end