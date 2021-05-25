function sols = solver_toy_example(data)
[C0,C1] = setup_elimination_template(data);
C1 = C0 \ C1;
RR = [-C1(end-0:end,:);eye(2)];
AM_ind = [3,1];
AM = RR(AM_ind,:);
[V,D] = eig(AM);
V = V ./ (ones(size(V,1),1)*V(1,:));
sols(2,:) = diag(D).';

% Extract remaining variables (This you have to do manually for this case)
a = data(1);
b = data(2);
sols(1,:) = - a * sols(2,:) - b;

% Action =  y
% Quotient ring basis (V) = 1,y,
% Available monomials (RR*V) = y^2,1,y,
function [coeffs] = compute_coeffs(data)
coeffs(1) = 1;
coeffs(2) = -1;
coeffs(3) = data(1);
coeffs(4) = data(2);
function [C0,C1] = setup_elimination_template(data)
[coeffs] = compute_coeffs(data);
coeffs0_ind = [1,1,1,3,1,4,1,3];
coeffs1_ind = [2,4,4,3];
C0_ind = [1,4,6,8,11,12,13,14];
C1_ind = [1,3,6,7];
C0 = zeros(4,4);
C1 = zeros(4,2);
C0(C0_ind) = coeffs(coeffs0_ind);
C1(C1_ind) = coeffs(coeffs1_ind);

