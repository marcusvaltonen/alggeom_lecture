function [ eqs, data0, eqs_data ] = problem_6pt1radial_elim( data0 )

if nargin < 1 || isempty(data0)
    data0 = randi(50,10*16,1);
end


xx = create_vars(9);

F0 = reshape(data0(1:16),4,4);
F1 = reshape(data0(17:32),4,4);
F2 = reshape(data0(33:48),4,4);
F3 = reshape(data0(49:64),4,4);
F4 = reshape(data0(65:80),4,4);
F5 = reshape(data0(81:96),4,4);
F6 = reshape(data0(97:112),4,4);
F7 = reshape(data0(113:128),4,4);
F8 = reshape(data0(129:144),4,4);
F9 = reshape(data0(145:160),4,4);

F = F0 + xx(1)*F1 + xx(2)*F2 + xx(3)*F3 + xx(4)*F4 + xx(5)*F5 + xx(6)*F6 + xx(7)*F7 + xx(8)*F8 + xx(9)*F9;

f11 = F(1,1);
f21 = F(2,1);
f31 = F(3,1);
f12 = F(1,2);
f22 = F(2,2);
f32 = F(3,2);
f13 = F(1,3);
f23 = F(2,3);
f33 = F(3,3);
y13 = F(1,4);
y23 = F(2,4);
y33 = F(3,4);
x31 = F(4,1);
x32 = F(4,2);
x33 = F(4,3);
z33 = F(4,4);


eqs = [y33-x33; x33^2-f33*z33; x32*x33-f32*z33; x31*x33-f31*z33;...
      y23*x33-f23*z33; y13*x33-f13*z33; f33*x32-f32*x33; f33*x31-f31*x33;...
      f32*x31-f31*x32; f33*y23-f23*x33; f32*y23-f23*x32; f31*y23-f23*x31;...
      f33*y13-f13*x33; f32*y13-f13*x32; f31*y13-f13*x31; f23*y13-f13*y23;...
      f22*y13*x31-f12*y23*x31-f21*y13*x32+f11*y23*x32+f12*f21*z33-f11*f22*z33;...
      2*f11*y13*x31+2*f21*y23*x31+2*f12*y13*x32+2*f22*y23*x32-f11^2*z33-f12^2*z33+f13^2*z33-f21^2*z33-f22^2*z33+f23^2*z33+f31^2*z33+f32^2*z33+f33^2*z33;...
      f13*f22*x31-f12*f23*x31-f13*f21*x32+f11*f23*x32+f12*f21*x33-f11*f22*x33;...
      2*f11*f13*x31+2*f21*f23*x31+2*f12*f13*x32+2*f22*f23*x32-f11^2*x33-f12^2*x33+f13^2*x33-f21^2*x33-f22^2*x33+f23^2*x33+f31^2*x33+f32^2*x33+f33^2*x33;...
      2*f11*f12*x31+2*f21*f22*x31-f11^2*x32+f12^2*x32-f13^2*x32-f21^2*x32+f22^2*x32-f23^2*x32+f31^2*x32+f32^2*x32+2*f12*f13*x33+2*f22*f23*x33+f32*f33*x33;...
      f11^2*x31-f12^2*x31-f13^2*x31+f21^2*x31-f22^2*x31-f23^2*x31+f31^2*x31+2*f11*f12*x32+2*f21*f22*x32+f31*f32*x32+2*f11*f13*x33+2*f21*f23*x33+f31*f33*x33;...
      2*f11*f21*y13+2*f12*f22*y13-f11^2*y23-f12^2*y23+f13^2*y23+f21^2*y23+f22^2*y23+f23^2*y23-f23*f31*x31-f23*f32*x32+2*f21*f31*x33+2*f22*f32*x33+f23*f33*x33;...
      f11^2*y13+f12^2*y13+f13^2*y13-f21^2*y13-f22^2*y13+2*f11*f21*y23+2*f12*f22*y23+f13*f23*y23-f13*f31*x31-f13*f32*x32+2*f11*f31*x33+2*f12*f32*x33+f13*f33*x33;...
      f13*f22*f31-f12*f23*f31-f13*f21*f32+f11*f23*f32+f12*f21*f33-f11*f22*f33;...
      2*f11*f13*f31+2*f21*f23*f31+2*f12*f13*f32+2*f22*f23*f32-f11^2*f33-f12^2*f33+f13^2*f33-f21^2*f33-f22^2*f33+f23^2*f33+f31^2*f33+f32^2*f33+f33^3;...
      2*f11*f12*f31+2*f21*f22*f31-f11^2*f32+f12^2*f32-f13^2*f32-f21^2*f32+f22^2*f32-f23^2*f32+f31^2*f32+f32^3+2*f12*f13*f33+2*f22*f23*f33+f32*f33^2;...
      f11^2*f31-f12^2*f31-f13^2*f31+f21^2*f31-f22^2*f31-f23^2*f31+f31^3+2*f11*f12*f32+2*f21*f22*f32+f31*f32^2+2*f11*f13*f33+2*f21*f23*f33+f31*f33^2;...
      2*f11*f13*f21+2*f12*f13*f22-f11^2*f23-f12^2*f23+f13^2*f23+f21^2*f23+f22^2*f23+f23^3-f23*f31^2-f23*f32^2+2*f21*f31*f33+2*f22*f32*f33+f23*f33^2;...
      2*f11*f12*f21-f11^2*f22+f12^2*f22-f13^2*f22+f21^2*f22+f22^3+2*f12*f13*f23+f22*f23^2-f22*f31^2+2*f21*f31*f32+f22*f32^2+2*f23*f32*f33-f22*f33^2;...
      f11^2*f21-f12^2*f21-f13^2*f21+f21^3+2*f11*f12*f22+f21*f22^2+2*f11*f13*f23+f21*f23^2+f21*f31^2+2*f22*f31*f32-f21*f32^2+2*f23*f31*f33-f21*f33^2;...
      f11^2*f13+f12^2*f13+f13^3-f13*f21^2-f13*f22^2+2*f11*f21*f23+2*f12*f22*f23+f13*f23^2-f13*f31^2-f13*f32^2+2*f11*f31*f33+2*f12*f32*f33+f13*f33^2;...
      f11^2*f12+f12^3+f12*f13^2-f12*f21^2+2*f11*f21*f22+f12*f22^2+2*f13*f22*f23-f12*f23^2-f12*f31^2+2*f11*f31*f32+f12*f32^2+2*f13*f32*f33-f12*f33^2;...
      f11^3+f11*f12^2+f11*f13^2+f11*f21^2+2*f12*f21*f22-f11*f22^2+2*f13*f21*f23-f11*f23^2+f11*f31^2+2*f12*f31*f32-f11*f32^2+2*f13*f31*f33-f11*f33^2];
  


if nargout == 3
    xx = create_vars(4+54);
    data = xx(5:end);
    e23 = xx(1);
e31 = xx(2);
e32 = xx(3);
l = xx(4);
e33 = 1;

vv = [e23*l e31*l  e32*l  l^2 e23 e31 e32 l 1]';

e11 = data(1:9)'*vv;
e12 = data(10:18)'*vv;
e13 = data(19:27)'*vv;
e21 = data(28:36)'*vv;
e22 = data(37:45)'*vv;
g5 = data(46:54)'*vv;

E = [e11 e12 e13;e21 e22 e23;e31 e32 e33];
eqs_data = 2*(E*E')*E - sum(diag(E*E'))*E;
eqs_data = [eqs_data(:);l*e13+g5;det(E)];


end
