function [eqs,data0,eqs_data] = problem_example04(data0)

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(10, 3*6, 1);
end

% Setup equation system
M = reshape(data0, 3, 6);
xx = create_vars(3);
eqs = M * [xx(1) xx(1)*xx(3) xx(2) xx(2)*xx(3) xx(3) xx(3)^2]';

M = collect_terms(eqs, [xx(1) xx(2) 1])
eqs2 = det(M);

disp(char(eqs2,0))

% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(3 + 3*6);
    eqs_data = problem_example04(xx(4:end));
end