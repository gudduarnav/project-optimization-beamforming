% Least Square method

% clear
close all; 
clear all;
clc;


% initialize
rng(1234);  % to produce reproducible value

m = 4; 
n = 2;

A = randn(m,n);
b = randn(m,1);
bnds = randn(n,2);
l = min( bnds, [], 2 );
u = max( bnds, [], 2 );

% calculate the least square solution
cvx_begin
    variable x(n)
    expression t1
    t1=norm(A*x-b) 
    minimize(t1)
    subject to
        l <= x <= u
cvx_end



disp("A = ")
disp(A)

disp("b = ")
disp(b)


disp("Min bound is")
disp(l')

disp("Max bound is")
disp(u')

disp("CVX calculated x as")
disp(x')
