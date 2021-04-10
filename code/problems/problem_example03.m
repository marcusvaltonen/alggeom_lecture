function [eqs,data0,eqs_data] = problem_example03(data0)

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(30, 2*2*3, 1);
end

% Image correspondences (note: it is minimal with 2.5 pts)
xi = [reshape(data0(1:6), 2, 3); ones(1, 3)];
yi = [reshape(data0(7:12), 2, 3); ones(1, 3)];

% Create unknowns
xx = create_vars(5+3);
t = [xx(1:2); 0];
n = [0 0 1]';
cx = xx(3);
sx = xx(4);
cy = xx(5);
sy = xx(6);
cz = xx(7);
sz = xx(8);

% Construct homography
T = eye(3) - t*n';
Rx = [1  0   0;
      0 cx -sx;
      0 sx  cx];
Ry = [ cy 0 sy;
        0 1  0;
      -sy 0 cy];
Rz = [cz -sz 0;
      sz  cz 0;
       0   0 1];
Rxy = Rx * Ry;  
H = Rxy * Rz * T * Rxy';

% DLT system
eqs = [];
for i = 1:3
    tmp = skew(yi(:,i)) * H * xi(:,i);
    eqs = [eqs; tmp(1:2)];
end

% Remove last equation (since it is 2.5 points)
eqs(end) = [];

% Add constraints emanating from the Pythagorean trigonometric identity
eqs  = [eqs; cx^2+sx^2-1; cy^2+sy^2-1; cz^2+sz^2-1];

% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(5+3 + 2*2*3);
    eqs_data = problem_example03(xx(9:end));
end