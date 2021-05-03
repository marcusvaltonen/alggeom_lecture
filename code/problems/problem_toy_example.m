function [eqs,data0,eqs_data] = problem_toy_example(data0)

nbr_unknowns = 2;
nbr_generic_coeffs = 2;

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(30, nbr_generic_coeffs, 1);
end

% Generic coefficients
a = data0(1);
b = data0(2);

% Create unknowns
vars = create_vars(2);
x = vars(1);
y = vars(2);

% Setup equations
eqs = [x^2 + y^2 - 1;
       x + a * y + b];

% Setup equation with data as additional unknowns
if nargout == 3
    vars = create_vars(nbr_unknowns + nbr_generic_coeffs);
    eqs_data = problem_toy_example(vars(nbr_unknowns+1:end));
end