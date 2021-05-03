function [eqs,data0,eqs_data] = problem_example12(data0)

use_saturation = true;
nbr_pts = 3;
nbr_unknowns = 7;
if use_saturation
    nbr_unknowns = nbr_unknowns + 1;  % Auxiliary saturation monomial
end
nbr_generic_coeffs = nbr_pts * 2 * 2;

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(20, nbr_generic_coeffs, 1);
end

p1 = reshape(data0(1:2*nbr_pts), 2, nbr_pts);
p2 = reshape(data0(2*nbr_pts+1:4*nbr_pts), 2, nbr_pts);

% Create and assign unknowns
xx = create_vars(nbr_unknowns);
u = xx(1:3);
l = [xx(4:5); 1];
s = [1; 1; xx(6)];
lam = xx(7);
if use_saturation
    x_sat = xx(8);
end

% Conjugate translation
H = @(si) eye(3) + si * u * l';

% Distortion model
phi = @(x, lam) [x(1:2); 1 + lam * sum(x(1:2) .^ 2)];

% DLT equations
eqs = [];
for i=1:nbr_pts
    u1 = phi(p1(:,i), lam);
    u2 = phi(p2(:,i), lam);
    tmp = skew(u2) * H(s(i)) * u1;
    eqs = [eqs; tmp(2:3)];  % Needs to be 2:3, otherwise s(3) is not used (try e.g. 1:2)
end

% Add orthogonality constraint
eqs = [eqs; l' * u];

% Use hidden variable trick to eliminate u (linear in eqs)
hidden_vars = 1:3;
M = collect_terms(eqs, [xx(hidden_vars); 1]);
M = remove_vars(M, hidden_vars);

% Require all sub-determinants (minors) of M to vanish
ind = nchoosek(1:size(M,1), size(M,2));
new_eqs = []; 
for k = 1:size(ind,1)
    new_eqs = [new_eqs; det(M(ind(k,:),:))];
    % If you have trouble with integer overflow you can use
    % new_eqs = [new_eqs; zp_det(M(ind(k,:),:), 30097)];
end

% The new_eqs system has infinitely many solutions, due to a
% one-dimensional family of spurious solutions introduced using the hidden
% variable trick. 

% Uncomment this line to get error: module given is not finite over the base
% eqs = new_eqs;

% This is remedied using saturation
if use_saturation
    eqs = new_eqs;
    x_sat = remove_vars(x_sat, hidden_vars);

    % Pick the second degree polynomial to saturate
    % NOTE: You should also set the following options:
    %
    %     opt.saturate_mon = 5;
    %     opt.M2_weights = [0 0 0 0 1];
    %
    % The latter in order to use a basis without the dummy variable x_sat.
    % This can potentially reduce the size of the eliminaiton template.
    
    pol_to_saturate = det(M([2 4 7], 1:3));
    eqs = [eqs; x_sat - pol_to_saturate];
    
    % Uncomment to test the Rabinowitsch trick on this problem
    % eqs = [eqs; 1 - x_sat * pol_to_saturate];
end

% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(nbr_unknowns + nbr_generic_coeffs);
    eqs_data = problem_example12(xx(nbr_unknowns+1:end));
end