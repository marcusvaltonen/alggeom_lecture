function [ eqs, data0, eqs_data ] = problem_opt_pnp_nakanoR( data0 )

if nargin < 1 || isempty(data0)
    M = randi(200,9,9);
    M = M+M';
    data0 = M(:);
end

M = reshape(data0,9,9);
xx = create_vars(9);
r = xx;
R = reshape(xx,3,3);
matMr = reshape(M*r,3,3);
P = R'*matMr-matMr'*R;
Q = matMr*R'-R*matMr';
c1 = R'*R-eye(3);
c2 = R*R'-eye(3);

eqs = [P(1,2);P(1,3);P(2,3);Q(1,2);Q(1,3);Q(2,3)];
% orthogonality constraints
eqs = [eqs;c1(:);c2(:)];
% positive orientation
eqs = [eqs;R(:,1)-cross(R(:,2),R(:,3))];
eqs = [eqs;R(:,2)-cross(R(:,3),R(:,1))];
eqs = [eqs;R(:,3)-cross(R(:,1),R(:,2))];


if nargout == 3
    xx = create_vars(9+81);
    eqs_data = problem_opt_pnp_nakanoR(xx(10:end));
end

