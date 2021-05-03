function [eqs,data0,eqs_data] = problem_group_exercise01(data0)

nbr_unknowns = 2;
nbr_generic_coeffs = 9*3;

if nargin < 1 || isempty(data0)
    % no input, generate a random integer instance
    data0 = randi(30, nbr_generic_coeffs, 1);
end

xx = create_vars(nbr_unknowns);
F0 = reshape(data0(1:9), 3, 3);
F1 = reshape(data0(10:18), 3, 3);
F2 = reshape(data0(19:27), 3, 3);

% Parameterize  (fix scale)
F = F0 + xx(1) * F1 + xx(2) * F2;

% Use Kukelova's strategy (see separate file for a derivation)
% TODO: Fix such a file
f11 = F(1,1);
f21 = F(2,1);
f31 = F(3,1);
f12 = F(1,2);
f22 = F(2,2);
f32 = F(3,2);
f13 = F(1,3);
f23 = F(2,3);
f33 = F(3,3);

eqs = [f13*f22*f31-f12*f23*f31-f13*f21*f32+f11*f23*f32+f12*f21*f33-f11*f22*f33;...
      f11*f13*f23*f31+f21*f23^2*f31+f12*f13*f23*f32+f22*f23^2*f32-f11*f13*f21*f33-f12*f13*f22*f33-f21^2*f23*f33-f22^2*f23*f33+f23*f31^2*f33+f23*f32^2*f33-f21*f31*f33^2-f22*f32*f33^2;...
      f11*f13^2*f31+f13*f21*f23*f31+f12*f13^2*f32+f13*f22*f23*f32-f11^2*f13*f33-f12^2*f13*f33-f11*f21*f23*f33-f12*f22*f23*f33+f13*f31^2*f33+f13*f32^2*f33-f11*f31*f33^2-f12*f32*f33^2;...
      f11*f13^2*f21+f12*f13^2*f22-f11^2*f13*f23-f12^2*f13*f23+f13*f21^2*f23+f13*f22^2*f23-f11*f21*f23^2-f12*f22*f23^2+f13*f21*f31*f33-f11*f23*f31*f33+f13*f22*f32*f33-f12*f23*f32*f33];

% Setup equation with data as additional unknowns
if nargout == 3
    xx = create_vars(nbr_unknowns + nbr_generic_coeffs);
    eqs_data = problem_group_exercise01(xx(nbr_unknowns+1:end));
end