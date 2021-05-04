function [eqs, data0, eqs_data] = problem_our_frEfr_no_rot(data0)

nbr_pts = 4;
if nargin < 1 || isempty(data0)
    data0 = randi(10, 9 + nbr_pts * 4, 1);
end

% This treats the more general case where R is not the identity
p1 = reshape(data0(1:2*nbr_pts), 2, nbr_pts);
p2 = reshape(data0(2*nbr_pts+1:4*nbr_pts), 2, nbr_pts);
R = reshape(data0(4*nbr_pts+1:25), 3, 3);

nbr_vars = 5;
xx = create_vars(nbr_vars);
t = xx(1:3);
f = xx(4);
r = xx(5);
Kinv = diag([1, 1, f]);

F = Kinv * skew(t) * R * Kinv;

eqs = multipol();
for i=1:nbr_pts
    u1 = [p1(:,i); 1 + r * sum(p1(:,i).^2)];
    u2 = [p2(:,i); 1 + r * sum(p2(:,i).^2)];

    eqs(i) = u2' * F * u1;
end

% Use linearity
hidden_vars = 1:3;

M = collect_terms(eqs, xx(hidden_vars));
M = remove_vars(M, hidden_vars); % remove t from our equations
%M = sym(M);
% and then require all sub-determinants of M to vanish
ind = nchoosek(1:size(M,1),size(M,2));
dlt_eqs = [];
for k = 1:size(ind,1)
    dlt_eqs = [dlt_eqs; det(M(ind(k,:),:))];
    % If you have trouble with integer overflow you can use
    %dlt_eqs = [dlt_eqs; zp_det(M(ind(k,:),:),30097)];
end

eqs = dlt_eqs(:);

if nargout == 3
    xx = create_vars(nbr_vars + 9 + nbr_pts * 4);
    eqs_data = problem_our_frEfr_no_rot( xx(nbr_vars+1:end) );
end

