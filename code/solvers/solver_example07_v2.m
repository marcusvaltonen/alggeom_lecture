function sols = solver_example07_v2(x)
% Coefficients obtained using the hidden variable trick.
% TODO: You might want to find common sub-expressions (CSE). In native
% MATLAB it is not so important, but when you are hunting microseconds in
% C++ it gives an extra boost. E.g. you see the expression x(1)*x(8) appear
% three times in the beginning of cfs(1:3). Instead of computing this
% quantity three times, you compute it once and store the result. The
% compiler (with optimization flags) will do this, but I have found on
% several occasions that using e.g. Maples 'optimize' function using the
% 'tryhard' flag gives superior results.
cfs = zeros(5, 1);
cfs(1) = x(1)*x(8)*x(15) - x(1)*x(9)*x(14) - x(2)*x(7)*x(15) + x(2)*x(9)*x(13) + x(3)*x(7)*x(14) - x(3)*x(8)*x(13);
cfs(2) = x(1)*x(8)*x(18) - x(1)*x(9)*x(17) + x(1)*x(11)*x(15) - x(1)*x(12)*x(14) - x(2)*x(7)*x(18) + x(2)*x(9)*x(16) - x(2)*x(10)*x(15) + x(2)*x(12)*x(13) + x(3)*x(7)*x(17) - x(3)*x(8)*x(16) + x(3)*x(10)*x(14) - x(3)*x(11)*x(13) + x(4)*x(8)*x(15) - x(4)*x(9)*x(14) - x(5)*x(7)*x(15) + x(5)*x(9)*x(13) + x(6)*x(7)*x(14) - x(6)*x(8)*x(13);
cfs(3) = x(1)*x(8)*x(21) - x(1)*x(9)*x(20) + x(1)*x(11)*x(18) - x(1)*x(12)*x(17) - x(2)*x(7)*x(21) + x(2)*x(9)*x(19) - x(2)*x(10)*x(18) + x(2)*x(12)*x(16) + x(3)*x(7)*x(20) - x(3)*x(8)*x(19) + x(3)*x(10)*x(17) - x(3)*x(11)*x(16) + x(4)*x(8)*x(18) - x(4)*x(9)*x(17) + x(4)*x(11)*x(15) - x(4)*x(12)*x(14) - x(5)*x(7)*x(18) + x(5)*x(9)*x(16) - x(5)*x(10)*x(15) + x(5)*x(12)*x(13) + x(6)*x(7)*x(17) - x(6)*x(8)*x(16) + x(6)*x(10)*x(14) - x(6)*x(11)*x(13);
cfs(4) = x(1)*x(11)*x(21) - x(1)*x(12)*x(20) - x(2)*x(10)*x(21) + x(2)*x(12)*x(19) + x(3)*x(10)*x(20) - x(3)*x(11)*x(19) + x(4)*x(8)*x(21) - x(4)*x(9)*x(20) + x(4)*x(11)*x(18) - x(4)*x(12)*x(17) - x(5)*x(7)*x(21) + x(5)*x(9)*x(19) - x(5)*x(10)*x(18) + x(5)*x(12)*x(16) + x(6)*x(7)*x(20) - x(6)*x(8)*x(19) + x(6)*x(10)*x(17) - x(6)*x(11)*x(16);
cfs(5) = x(4)*x(11)*x(21) - x(4)*x(12)*x(20) - x(5)*x(10)*x(21) + x(5)*x(12)*x(19) + x(6)*x(10)*x(20) - x(6)*x(11)*x(19);

% Use a root finding algorithm.
% NOTE: If you have many roots, and only a few are real-valued, you might
% want to consider Sturm sequences (e.g. using the Danilevski trick). There
% is template code for this (using C++), see the autogen folder.
z = roots(cfs);

% TODO: Potentially we want to remove complex solutions
sols = zeros(3, 4);
for i = 1:4
    M = [z(i)*x(1) + x(4), z(i)*x(7) + x(10), z(i)^2*x(13) + z(i)*x(16) + x(19); ...
         z(i)*x(2) + x(5), z(i)*x(8) + x(11), z(i)^2*x(14) + z(i)*x(17) + x(20); ...
         z(i)*x(3) + x(6), z(i)*x(9) + x(12), z(i)^2*x(15) + z(i)*x(18) + x(21)];
     
     % Find null space vector
     [~, ~, V] = svd(M, 0);
     
     % Normalize with last element equal to one
     v = V(:,3) / V(3,3);
     
     % These are the solutions!
     sols(:,i) = [v(1:2); z(i)];
end