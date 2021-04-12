

clear

addpath problems
addpath(genpath('generator'))

% add path to multipol, https://github.com/LundUniversityComputerVision/multipol
addpath multipol

% if the folder 'solvers' doesn't exist, mkdir solvers 
if ~exist('solvers','dir')
    mkdir('solvers');
end



%% Run generator
solv_name = 'example08';
problem = @problem_example08;
opt = default_options();


% if Macaulay2 is not runnable as M2 on your system, update this
opt.M2_path = '/usr/bin/M2';
%opt.cg_language = 'cpp_eigen';
%opt.cg_eigen_dir = '/usr/include/eigen3';

% Make sure extract_monomials.cpp in generator is mex'ed
% if you are not able to mex the file, you can instead use the option
% opt.fast_monomial_extraction = 0;

solv = generate_solver(solv_name,problem,opt)

%% Test solver

addpath solvers
rehash
disp('Now benchmarking')
solv_fun = str2func(['solver_' solv_name]);
stats = benchmark_solver(solv_fun,problem,50)

figure(1)
clf
hist(log10(stats.all_res),50)
title(sprintf('Mean: %.2f, Median: %.2f\n Mode: %.2f, Time: %.2f ms\n',...
        stats.res_mean,stats.res_median,stats.res_mode,...
        1000*median(stats.time_taken)));
xlabel('log10 residual')
ylabel('freq.')
