function [eqs,data0,eqs_data] = problem_example07(data0)

use_hidden_variable = true;
nbr_unknowns = 3;
nbr_generic_coeffs = 3*7;

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(30, nbr_generic_coeffs, 1);
end

% Setup equation system
C = reshape(data0, 3, 7);
xx = create_vars(3);
x = xx(1);
y = xx(2);
z = xx(3);
eqs = C * [x*z x y*z y z^2 z 1]';

% Use hidden variable trick
% NOTE: The automatic solver does not solve single variable polynomials.
% Write your own routine and use roots (c.f. solver_example07_v2.m)

if use_hidden_variable
    M = collect_terms(eqs, [x y 1]');
    eqs_hv = det(M);
    cfs = collect_terms(eqs_hv, [z^4 z^3 z^2 z 1]);

    % This removes the nbr_unknowns and makes the coefficients MATLAB
    % compatible.
    for i = 1:5
        tmp = char(cfs(i), 0);
        for j = nbr_generic_coeffs+nbr_unknowns:-1:1
            tmp = strrep(tmp, ['x', num2str(j), ''], ['x(', num2str(j-nbr_unknowns), ')']);
        end
        fprintf(1, "cfs(%d) = %s;\n", i, tmp)
    end
end

% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(nbr_unknowns + nbr_generic_coeffs);
    eqs_data = problem_example07(xx(nbr_unknowns+1:end));
end