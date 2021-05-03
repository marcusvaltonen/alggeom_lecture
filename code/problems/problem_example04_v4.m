function [eqs,data0,eqs_data] = problem_example04_v4(data0)

nbr_unknowns = 2;
nbr_generic_coeffs = 18;

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(30, nbr_generic_coeffs, 1);
end

% Line correspondences (only)
l1 = reshape(data0(1:6), 3, 2);
l2 = reshape(data0(7:12), 3, 2);
l3 = reshape(data0(13:18), 3, 2);

% Common direction
v = [0; 1; 0];

% Parameterize rotation matrices using unit quaternions
xx = create_vars(nbr_unknowns);
q2 = [1; xx(1) * v];
q3 = [1; xx(2) * v];
R2 = quat2rot(q2);
R3 = quat2rot(q3);

% Line constraint
eqs = [];
for k = 1:2
    eqs = [eqs; det([l1(:,k) R2'*l2(:,k) R3'*l3(:,k)])];
end

% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(nbr_unknowns + nbr_generic_coeffs);
    eqs_data = problem_example04_v4(xx(nbr_unknowns+1:end));
end