function [eqs,data0,eqs_data] = problem_example06(data0)

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(50, 3*9, 1);
end

% Setup equation system
xx = create_vars(4);
x = xx(1);
y = xx(2);
z = xx(3);
w = xx(4);
M = reshape(data0, 3, 9);
v = [x*w x y*w y z^2 z*w^2 z w 1]';
eqs = M * v;
eqs = [eqs; x^2+y^2-1];


% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(4 + 3*9);
    eqs_data = problem_example06(xx(5:end));
end