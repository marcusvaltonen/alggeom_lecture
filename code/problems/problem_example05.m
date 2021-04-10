function [eqs,data0,eqs_data] = problem_example05(data0)

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(30, 3*7, 1);
end

% Setup equation system
C = reshape(data0, 3, 7);
xx = create_vars(3);
x = xx(1);
y = xx(2);
z = xx(3);
eqs = C * [x*z x y*z y z^2 z 1]';

% M = collect_terms(eqs, [x y 1]');
% eqs2 = det(M);
% disp(char(eqs2,0))

% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(3 + 3*7);
    eqs_data = problem_example05(xx(4:end));
end