function err = fit_Residuals(params, time_data, foliation_data, ode)
% compute residuals between model prediction and observed data 

% Input:
%   time_data        - vector of observation time (years)
%   foliation_data   - observed foliage fraction (1 - defoliation data)
%   ode              - the ode system (@moth_foliage_ode)
%   params:          - parameter vector [a, b, c, d]
%                       - a = foliage growth rate
%                       - b = foliage consumption rate by moths     
%                       - c = moth mortality rate     
%                       - d = moth growth rate from foliage
%
% Output:
%   err              - residual vector for foliage (model prediction - observed data)


    %% ---- PARAMETER EXTRACTION ------
    % unpack parameter vector to meaningful names
        a = params(1);  % foliage growth rate
        b = params(2);  % foliage consumption rate by moths
        c = params(3);  % moth mortality rate
        d = params(4);  % moth growth rate from foliage

	% define initial foliage (F0) and moth population (N0)
    F0 = params(5);
    N0 = params(6);   

    params = [a b c d];

    %% ----- SOLVE ODE -----
    sol = ode45(@(t,y) ode(t, y, params), ...
                [time_data(1), time_data(end)], [F0, N0]);

    %% ---- MODEL EVALUATION -----
    % evaluate foliage over time using deval and store in F_model
    solY = deval(sol, time_data);
    F_model = solY(1, :)';  
    err = F_model - foliation_data;

end