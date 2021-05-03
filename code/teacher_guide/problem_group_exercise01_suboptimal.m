function [eqs,data0,eqs_data] = problem_group_exercise01_suboptimal(data0)

nbr_unknowns = 3;
nbr_generic_coeffs = 9*3;

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(30, nbr_generic_coeffs, 1);
end

xx = create_vars(nbr_unknowns);
F0 = reshape(data0(1:9), 3, 3);
F1 = reshape(data0(10:18), 3, 3);
F2 = reshape(data0(19:27), 3, 3);

% Parameterize  (fix scale)
F = F0 + xx(1) * F1 + xx(2) * F2;

% Parameterize the calibration matrix and utilize relation to fundamental
% matrix.
K = [1 0 0; 0 1 0; 0 0 xx(3)];
E = F * K;

% Trace constraint (Demazure)
eqs = 2 * (E*E') * E - sum(diag(E * E')) * E;

% Rank constraint
eqs = [eqs(:); det(E)];

% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(nbr_unknowns + nbr_generic_coeffs);
    eqs_data = problem_group_exercise01_suboptimal(xx(nbr_unknowns+1:end));
end