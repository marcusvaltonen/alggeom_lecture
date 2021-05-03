function [eqs,data0,eqs_data] = problem_example04_v1(data0)

nbr_unknowns = 10;
nbr_generic_coeffs = 27;

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(30, nbr_generic_coeffs, 1);
end

% Image correspondences
x1 = data0(1:3);
x2 = data0(4:6);
x3 = data0(7:9);

% Line correspondences
l1 = reshape(data0(10:15),3,2);
l2 = reshape(data0(16:21),3,2);
l3 = reshape(data0(22:27),3,2);

% Common direction
v = [0; 1; 0];

% Parameterize problem and lock scale
xx = create_vars(nbr_unknowns);
q2 = [xx(1); xx(2) * v];
q3 = [xx(3); xx(4) * v];
X = x1;
t2 = xx(5:7);
t3 = xx(8:10);

% Rotation matrices (from unit quaternion)
R2 = quat2rot(q2);
R3 = quat2rot(q3);

% Camera matrices
P1 = [eye(3) zeros(3, 1)];
P2 = [R2 t2];
P3 = [R3 t3];

% Line constraint
eqs = [];
for k = 1:2
    % Make all sub-determinant (minors) vanish
    A = [P1'*l1(:,k) P2'*l2(:,k) P3'*l3(:,k)];
    eqs = [eqs; det(A(1:3,:)); det(A([1 3 4],:)); det(A([2 3 4],:))];
end

% Point constraints (the first is trivially fulfilled)
eqs = [eqs; cross(x2, P2*[X;1])];
eqs = [eqs; cross(x3, P3*[X;1])];

% Enforce unit quaternions
eqs = [eqs; q2' * q2 - 1; q3' * q3 - 1];

% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(nbr_unknowns + nbr_generic_coeffs);
    eqs_data = problem_example04_v1(xx(nbr_unknowns+1:end));
end