function [eqs,data0,eqs_data] = problem_example10_v2(data0)

nbr_unknowns = 3;
nbr_generic_coeffs = 3*6;

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(50, nbr_generic_coeffs, 1);
end

% Setup equation system
xx = create_vars(nbr_unknowns);
x = xx(1);
y = xx(2);
w = xx(3);
Mhat = reshape(data0, 3, 6);
v_red = [x*w x y*w y w 1]';
gi = Mhat * v_red;  % Minus sign excluded
eqs = [gi(2) - w^2 * gi(3); gi(1) - (gi(3))^2; x^2+y^2-1];

% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(nbr_unknowns + nbr_generic_coeffs);
    eqs_data = problem_example10_v2(xx(nbr_unknowns+1:end));
end