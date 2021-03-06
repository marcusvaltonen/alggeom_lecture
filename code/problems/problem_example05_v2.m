function [eqs,data0,eqs_data] = problem_example05_v2(data0)

nbr_unknowns = 5+1;  % Five sought, one auxiliary
nbr_generic_coeffs = 2*2*3;

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(30, nbr_generic_coeffs, 1);
end

% Image correspondences (note: it is minimal with 2.5 pts)
xi = [reshape(data0(1:6), 2, 3); ones(1, 3)];
yi = [reshape(data0(7:12), 2, 3); ones(1, 3)];

% Create unknowns
xx = create_vars(5+1);
t = xx(1:3);
n = xx(4:6);
q = [1; n];

% Construct homography
H = quat2rot(q) - t*n';

% DLT system
eqs = [];
for i = 1:3
    tmp = skew(yi(:,i)) * H * xi(:,i);
    eqs = [eqs; tmp(1:2)];
end

% Remove last equation (since it is 2.5 points)
eqs(end) = [];

% Add constraints due to travelling parallel to the plane
eqs  = [eqs; t'*n];

% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(nbr_unknowns + nbr_generic_coeffs);
    eqs_data = problem_example05_v2(xx(nbr_unknowns+1:end));
end