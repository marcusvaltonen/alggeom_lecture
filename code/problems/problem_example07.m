function [eqs,data0,eqs_data] = problem_example07(data0)

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

% Uncomment to use hidden variable trick
% NOTE: The automatic solver does not solve single variable polynomials.
% Write your own routine and use roots (c.f. solver_example07.m)
%
% M = collect_terms(eqs, [x y 1]');
% eqs2 = det(M);
% disp(char(eqs2,0))

% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(nbr_unknowns + nbr_generic_coeffs);
    eqs_data = problem_example07(xx(nbr_unknowns+1:end));
end